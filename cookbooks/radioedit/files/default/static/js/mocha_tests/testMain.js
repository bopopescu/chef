// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var $, JSCovReporter, chaiJquery, console, sinonChai;
    sinonChai = require('sinon-chai');
    JSCovReporter = require('JSCovReporter');
    $ = require('jquery');
    chaiJquery = require('chai-jquery');
    require('util/spec_helper');
    require('spec/catalogTest');
    require('spec/cropTest');
    require('spec/datePickerTest');
    require('spec/jsonviewTest');
    require('spec/browse/baseTest');
    require('spec/browse/modelsTest');
    require('spec/browse/treeTest');
    require('spec/browse/mapperTest');
    require('spec/browse/routerTest');
    require('spec/browse/commitsTest');
    require('spec/browse/typeviews/conciergeTest');
    require('spec/browse/typeviews/externalTest');
    require('spec/browse/typeviews/featuredTest');
    require('spec/browse/typeviews/queryTest');
    require('spec/browse/bread_crumb_test');
    require('spec/relational_model_test');
    require('spec/browse/modify_test');
    require('spec/browse/acl_test');
    require('spec/toggle_field_test');
    chai.use(sinonChai);
    chai.use(chaiJquery);
    chai.should();
    console = window.console || function() {};
    window.notrack = true;
    $.fx.off = true;
    if (window.RUNNER === 'browser') {
      return mocha.run(function() {
        var reporter;
        if (typeof window.__$coverObject !== 'undefined') {
          return reporter = new JSCovReporter({
            coverObject: window.__$coverObject
          });
        }
      });
    } else {
      return alert(JSON.stringify({
        state: 'start'
      }));
    }
  });

}).call(this);
