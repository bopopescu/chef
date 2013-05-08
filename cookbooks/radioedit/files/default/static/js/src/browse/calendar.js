// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, AlertView, Backbone, BaseView, Calendar, DatePicker, DayViewGroup, ItemsList, MiniCal, PopoverView, ScheduledDayViewGroup, SingleDayView, baseCalendarTemplate, itemsListTemplate, moment, scheduledDayTemplate, _, _ref, _ref1;
    Backbone = require('backbone');
    $ = require('jquery');
    _ = require('underscore');
    _ref = require('src/browse/base'), PopoverView = _ref.PopoverView, BaseView = _ref.BaseView, AlertView = _ref.AlertView;
    _ref1 = require('src/datePicker'), DatePicker = _ref1.DatePicker, DayViewGroup = _ref1.DayViewGroup;
    baseCalendarTemplate = require('eco/calendar/base');
    scheduledDayTemplate = require('eco/calendar/scheduled_day');
    itemsListTemplate = require('eco/calendar/items_list');
    moment = require('moment');
    ScheduledDayViewGroup = (function(_super) {

      __extends(ScheduledDayViewGroup, _super);

      function ScheduledDayViewGroup() {
        return ScheduledDayViewGroup.__super__.constructor.apply(this, arguments);
      }

      ScheduledDayViewGroup.prototype.initialize = function() {
        ScheduledDayViewGroup.__super__.initialize.call(this);
        return this.model.on('change:schedule', this.render, this);
      };

      ScheduledDayViewGroup.prototype.supplementalRender = function(date) {
        var refs;
        refs = this.model.getActiveRefs(date.valueOf());
        if (refs.length) {
          return scheduledDayTemplate({
            height: 100 / refs.length,
            refs: refs,
            colors: this.model.refColorMap
          });
        }
      };

      ScheduledDayViewGroup.prototype.supplementalClass = function(date) {
        if (this.model.getActiveCount(date.valueOf()) > 0) {
          return ' active';
        }
      };

      ScheduledDayViewGroup.prototype.onClose = function() {
        return this.model.off(null, null, this);
      };

      return ScheduledDayViewGroup;

    })(DayViewGroup);
    Calendar = (function(_super) {

      __extends(Calendar, _super);

      function Calendar() {
        return Calendar.__super__.constructor.apply(this, arguments);
      }

      Calendar.prototype.className = 'objectPushPopover';

      Calendar.prototype.initialize = function() {
        Calendar.__super__.initialize.call(this, arguments);
        this.scheduleModel = this.options.scheduleModel;
        this.datePicker = DatePicker.instance(this.scheduleModel, ScheduledDayViewGroup);
        this.alertView = new AlertView();
        this.itemsList = new ItemsList({
          model: this.model,
          scheduleModel: this.scheduleModel,
          alertView: this.alertView
        });
        this.subPopovers.push(this.itemsList.calendar);
        return this.scheduleModel.on('error', this.handleErrors, this);
      };

      Calendar.prototype.render = function() {
        Calendar.__super__.render.call(this, 'Push Object', baseCalendarTemplate());
        this.datePicker.setElement(this.$('.calendar')).render();
        this.itemsList.setElement(this.$('.itemsList')).render();
        this.alertView.setElement(this.$('.status'));
        return this;
      };

      Calendar.prototype.handleErrors = function(schedule) {
        var error;
        error = schedule.errors.last();
        return this.alertView.showAlert('error', error.get('status'), error.getExtendedMessage());
      };

      Calendar.prototype.onClose = function() {
        return this.scheduleModel.off(null, null, this);
      };

      return Calendar;

    })(PopoverView);
    ItemsList = (function(_super) {

      __extends(ItemsList, _super);

      function ItemsList() {
        return ItemsList.__super__.constructor.apply(this, arguments);
      }

      ItemsList.prototype.events = {
        'click .btn.add': 'addItem',
        'click .btn.delete': 'deleteItem',
        'click .editItem .scheduleStatus button': 'changeScheduleStatus'
      };

      ItemsList.prototype.initialize = function() {
        var _ref2;
        _ref2 = this.options, this.scheduleModel = _ref2.scheduleModel, this.alertView = _ref2.alertView;
        this.calendar = new MiniCal();
        this.calendar.setDelegateSelector('.objectPushPopover .calendarIcon');
        this.calendar.on('dayClicked', this.dayClicked, this);
        return this.scheduleModel.on('change:schedule', this.render, this);
      };

      ItemsList.prototype.render = function() {
        this.calendar.render();
        this.$el.html(itemsListTemplate({
          today: moment().format('MMM DD YYYY'),
          commitId: this.model.commitId(),
          schedule: this.scheduleModel.get('schedule'),
          colors: this.scheduleModel.refColorMap,
          commonTags: JSON.stringify(['Staging', 'Live']),
          moment: moment
        }));
        this.$dateInput = this.$('.scheduleDate input.date');
        return this;
      };

      ItemsList.prototype.dayClicked = function(date) {
        return this.$dateInput.val(date.format('MMM DD YYYY'));
      };

      ItemsList.prototype.addItem = function() {
        var $input, commit, input, inputMap, inputs, schedule, time, _i, _len;
        this.alertView.closeAlert();
        inputs = this.$('.addSchedule input');
        commit = this.$('.addSchedule .scheduleStatus .active').data('commit');
        schedule = _.clone(this.scheduleModel.get('schedule'));
        inputMap = {};
        for (_i = 0, _len = inputs.length; _i < _len; _i++) {
          input = inputs[_i];
          $input = $(input);
          inputMap[$input.attr('name')] = $input.val() || $input.attr('placeholder');
        }
        time = moment("" + inputMap.date + " " + inputMap.time + " +0000", "MMM DD YYYY hh:mm ZZ").valueOf();
        schedule.push({
          time: time,
          ref: inputMap.ref,
          commit: commit
        });
        return this.scheduleModel.save({
          schedule: schedule
        }, {
          wait: true
        });
      };

      ItemsList.prototype._getElementIndex = function($element) {
        return $element.parents('.item').data('index');
      };

      ItemsList.prototype.deleteItem = function() {
        var index, schedule;
        schedule = _.clone(this.scheduleModel.get('schedule'));
        index = this._getElementIndex($(event.target));
        schedule.splice(index, 1);
        return this.scheduleModel.set('schedule', schedule).save();
      };

      ItemsList.prototype.changeScheduleStatus = function() {
        var $target, index, schedule;
        schedule = JSON.parse(JSON.stringify(this.scheduleModel.get('schedule')));
        $target = $(event.target);
        index = this._getElementIndex($target);
        schedule[index].commit = $target.data('commit');
        return this.scheduleModel.set('schedule', schedule).save();
      };

      ItemsList.prototype.onClose = function() {
        this.calendar.off(null, null, this);
        return this.scheduleModel.off(null, null, this);
      };

      return ItemsList;

    })(BaseView);
    SingleDayView = (function(_super) {

      __extends(SingleDayView, _super);

      function SingleDayView() {
        return SingleDayView.__super__.constructor.apply(this, arguments);
      }

      SingleDayView.prototype.initialize = function() {
        this.options.numberSubViews = 1;
        return SingleDayView.__super__.initialize.call(this);
      };

      return SingleDayView;

    })(DayViewGroup);
    MiniCal = (function(_super) {

      __extends(MiniCal, _super);

      function MiniCal() {
        return MiniCal.__super__.constructor.apply(this, arguments);
      }

      MiniCal.prototype.className = 'miniCalPopover';

      MiniCal.prototype.events = function() {
        return _.extend(MiniCal.__super__.events.call(this), {
          'click .day': 'dayClicked'
        });
      };

      MiniCal.prototype.initialize = function() {
        this.options.placement = 'right';
        MiniCal.__super__.initialize.call(this);
        return this.datePicker = DatePicker.instance(this.model, SingleDayView);
      };

      MiniCal.prototype.render = function() {
        MiniCal.__super__.render.call(this, 'Choose Date');
        this.$content.html(this.datePicker.rendel());
        return this;
      };

      MiniCal.prototype.dayClicked = function(event) {
        var $target, date;
        $target = $(event.currentTarget);
        date = moment($target.data('date')).utc();
        this.hidePopover();
        return this.trigger('dayClicked', date);
      };

      return MiniCal;

    })(PopoverView);
    return {
      Calendar: Calendar
    };
  });

}).call(this);