// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var FixtureHelper;
    return FixtureHelper = (function() {

      function FixtureHelper(data) {
        this.data = data;
      }

      FixtureHelper.prototype.getResponse = function(responseCode) {
        if (responseCode == null) {
          responseCode = 200;
        }
        return [
          responseCode, {
            'Content-Type': 'application/json'
          }, JSON.stringify(this.data)
        ];
      };

      return FixtureHelper;

    })();
  });

}).call(this);
