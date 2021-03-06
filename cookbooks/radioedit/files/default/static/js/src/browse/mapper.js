// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var DataTypesCollection, Mapper, defaults, _;
    defaults = require('src/browse/defaults');
    _ = require('underscore');
    DataTypesCollection = (function(_super) {

      __extends(DataTypesCollection, _super);

      function DataTypesCollection() {
        return DataTypesCollection.__super__.constructor.apply(this, arguments);
      }

      DataTypesCollection.prototype.deferred = null;

      DataTypesCollection.prototype.url = "" + window.API_PREFIX + "/utils/datatypes/";

      DataTypesCollection.prototype.fetch = function(options) {
        return this.deferred = DataTypesCollection.__super__.fetch.call(this, options);
      };

      DataTypesCollection.prototype.populate = function(options, callback) {
        var deferred;
        deferred = this.deferred || this.fetch(options);
        if (_.isFunction(callback)) {
          deferred.done(callback);
        }
        return deferred;
      };

      DataTypesCollection.prototype.parse = function(response) {
        var id, name, schema, _i, _len, _ref, _ref1, _results;
        _ref = response.datatypes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          _ref1 = _ref[_i], id = _ref1.type, name = _ref1.name, schema = _ref1.schema;
          if (id !== 'folder') {
            _results.push({
              id: id,
              name: name,
              schema: schema
            });
          }
        }
        return _results;
      };

      return DataTypesCollection;

    })(Backbone.Collection);
    Mapper = (function() {

      Mapper.prototype.ROW = 'row';

      Mapper.prototype.MODIFY = 'modify';

      Mapper.prototype["default"] = defaults;

      function Mapper(collection) {
        this.collection = collection;
        this.collection || (this.collection = new DataTypesCollection());
        this.dataTypes = {};
      }

      Mapper.prototype.register = function(name, dataType, classToMap) {
        var _base;
        ((_base = this.dataTypes)[dataType] || (_base[dataType] = {}))[name] = classToMap;
        return this;
      };

      Mapper.prototype.get = function(name, dataType, callback) {
        var deferred,
          _this = this;
        deferred = new $.Deferred();
        this.collection.populate().done(function() {
          var mappedClass, model, type;
          model = _this.collection.get(dataType);
          type = _this.dataTypes[model != null ? model.id : void 0];
          mappedClass = (type != null ? type[name] : void 0) || _this["default"][name];
          if (!(mappedClass != null)) {
            throw new Error("" + name + " is not a valid name.");
          }
          deferred.resolve(mappedClass);
          return typeof callback === "function" ? callback(mappedClass) : void 0;
        });
        return deferred.promise();
      };

      return Mapper;

    })();
    return {
      mapper: new Mapper(),
      Mapper: Mapper,
      DataTypesCollection: DataTypesCollection
    };
  });

}).call(this);
