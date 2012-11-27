#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use DBI;
use LWP::UserAgent;
use HTTP::Request;
use Data::Dumper;
use Sys::Syslog qw( :DEFAULT setlogsock );
setlogsock( 'unix' );
# used in &to_syslog
#my $FACILITY    = 'local7';
my $FACILITY     = 'file';
my $SERVER_NAME = 'ipplan-exportdns.pl';
my $PRIORITY    = 'info';

# used in &fake_request
my $IPPLAN_USER = 'ops-auto';

# used in &query_db
my $DSN = 'dbi:mysql:ipplan:host=lax-ss-db001a:port=3306';
my $DBUSER = 'ipplan';
my $DBPASS = 'ipplanpw';

# @ARGV will contain:
#  ( 120, domain )  = delete fwd record
#  ( 121, domain )  = add fwd record
#  ( 122, domain )  = modify fwd record
#  ( 130, ip )      = modify rev record
#  ( 131, ip )      = add rev record
#  ( 132, ip )      = delete rev record

my ( $event, $arg ) = @ARGV;

my $customer = 1;  # "AddThis-Internal" in IPPlan. hardcoad is ok for now, easy to change later if needed.
#my @fwd_script = ('php-cgi', '/data/www/ipplan/user/modifydns.php');
my @fwd_script = ('curl', "-u $IPPLAN_USER:$IPPLAN_USER", 'http://lax-ss-admin001b/ipplan/user/modifydns.php?');
my $fwd_query_base = "action=export&cust=$customer";
#my @rev_script = ('php-cgi', '/data/www/ipplan/user/modifyzone.php');
my @rev_script = ('curl', "-u $IPPLAN_USER:$IPPLAN_USER", 'http://lax-ss-admin001b/ipplan/user/modifyzone.php?');
my $rev_query_base = "action=export&cust=$customer";

if ( $event =~ /^12(0|1|2)$/ ) {
    to_syslog( "fwd dns actions for domain $arg" );
    export_fwd_dns( $arg );
}
elsif ( $event =~ /^13(0|1|2)$/ ){
    to_syslog( "rev dns actions for all zones" );
    export_rev_dns(  );
    to_syslog("Done exporting rev-dns \n\n\n");
}
else {
    to_syslog( "Unsupported event: @ARGV" );
}


# subs

sub export_fwd_dns {
    my $domain = shift;
    
    my $sql = qq{
        SELECT data_id, responsiblemail,
               serialdate, serialnum,
               ttl, retry, refresh, expire,
               minimum, slaveonly,
               zonefilepath1, zonefilepath2

          FROM fwdzone

         WHERE domain = "$domain"
    }; $sql =~ s/\s+/ /g;

    my $ref = query_db( $sql );

    my $query_string = $fwd_query_base
        . '&domain='          . $domain
        . '&dataid='          . $ref->{data_id}
        . '&responsiblemail=' . $ref->{responsiblemail}
        . '&serialdate='      . $ref->{serialdate}
        . '&serialnum='       . $ref->{serialnum}
        . '&ttl='             . $ref->{ttl}
        . '&retry='           . $ref->{retry}
        . '&refresh='         . $ref->{refresh}
        . '&expire='          . $ref->{expire}
        . '&minimum='         . $ref->{minimum}
        . '&slaveonly='       . $ref->{slaveonly}
        . '&zonepath='        . $ref->{zonefilepath1}
        . '&seczonepath='     . $ref->{zonefilepath2}
    ;

    to_syslog("Invoking forward script");
    to_syslog(Dumper($query_string));
    fake_request( @fwd_script, $query_string );
}

sub export_rev_dns {
    #http://lax-ss-admin001/ipplan/user/modifyzone.php?cust=2&zoneid=0&action=export
    to_syslog("Invoking reverse script to export all changed reverse zones");
    fake_request( @rev_script, 'cust=1&zoneid=0&action=export' );
}

sub query_db {
    my $query = shift;
    to_syslog( "query_db $query" );

    my $dbh = DBI->connect( $DSN, $DBUSER, $DBPASS, { RaiseError => 1, AutoCommit => 1 } )
      or die to_syslog( "Can't connect to database" . DBI->errstr() );

    my $res;
    eval {
        $res = $dbh->selectrow_hashref( $query )
    };
    $dbh->disconnect;

    if (@$) {
        to_syslog( "query failed: $query " . DBI->errstr() );
        exit 255; # beh
    }

    unless ( $res ) {
        to_syslog( "returned no rows: $query" );
        exit 255; # beh
    }

    return $res;
}    

sub rtrim($)
{
    my $string = shift;
    $string =~ s/\s+$//;
    return $string;
}

sub fake_request {
    my @args = @_;
    to_syslog("Args:\n".Dumper(@args)."\n\n");

    my $cmd = "$args[0] $args[1] $args[2] ";
    foreach my $keyval(split ('&', $args[3])){
	$keyval = rtrim($keyval);
	$cmd .= "-F $keyval "
    }

    to_syslog("command is\n$cmd");
    my $rv = `$cmd`;
    to_syslog("RESULT\n".Dumper($rv)."\n\n\n");

  # Check the outcome of the response
    if ($rv) {
        to_syslog( 'Fake Request success' );
    } else {
	to_syslog( 'Fake Request fail: ');
    }
}

sub to_syslog {
    my $msg = shift;
    
    #openlog( $SERVER_NAME, 'ndelay,console', $FACILITY );
    #syslog( $PRIORITY, $msg );
    #closelog();
    open(LOGFILE, '>>/var/log/ipplan-export.log') or die "Unable to open logfile: $!\n";
    print LOGFILE "$msg\n";
    close(LOGFILE) or die "unable to close logfile: $!\n";   
}
