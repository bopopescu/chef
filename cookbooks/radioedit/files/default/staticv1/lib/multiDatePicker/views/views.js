// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, CalendarView, DatePickerSubViewBase, Handlebars, MonthView, MultiDatePickerView, YearView, datePickerTemplate, models, monthsTemplate, multiDatePickerTemplate, yearsTemplate, _;
    Handlebars = require('handlebars');
    Backbone = require('backbone');
    multiDatePickerTemplate = Handlebars.compile(require('text!multiDatePicker/multiDateTemplates/multiDatePicker.html'));
    datePickerTemplate = Handlebars.compile(require('text!multiDatePicker/multiDateTemplates/calendar.html'));
    monthsTemplate = Handlebars.compile(require('text!multiDatePicker/multiDateTemplates/months.html'));
    yearsTemplate = Handlebars.compile(require('text!multiDatePicker/multiDateTemplates/years.html'));
    models = require('multiDatePicker/models');
    $ = require('jquery');
    _ = require('underscore');
    require('multiDatePicker/handlebarsHelpers');
    DatePickerSubViewBase = (function(_super) {

      __extends(DatePickerSubViewBase, _super);

      function DatePickerSubViewBase() {
        return DatePickerSubViewBase.__super__.constructor.apply(this, arguments);
      }

      DatePickerSubViewBase.prototype.chronologyModel = null;

      DatePickerSubViewBase.prototype.template = null;

      DatePickerSubViewBase.prototype.tagName = 'div';

      DatePickerSubViewBase.prototype.initialize = function() {
        return this.chronologyModel = this.options.chronologyModel;
      };

      return DatePickerSubViewBase;

    })(Backbone.View);
    MonthView = (function(_super) {

      __extends(MonthView, _super);

      function MonthView() {
        return MonthView.__super__.constructor.apply(this, arguments);
      }

      MonthView.prototype.className = 'datepicker-months';

      MonthView.prototype.events = {
        'click .month': 'setMonth'
      };

      MonthView.prototype.initialize = function() {
        MonthView.__super__.initialize.call(this);
        this.template = monthsTemplate;
        this.chronologyModel.on('change', this.render, this);
        return this.render();
      };

      MonthView.prototype.render = function() {
        var activeDateList, endOfYear, startOfYear;
        activeDateList = this.chronologyModel.getActiveDateRangeList();
        startOfYear = this.chronologyModel.getDate().clone().set({
          month: 0,
          day: 1
        }).resetTime();
        endOfYear = startOfYear.clone().advance({
          years: 1
        }).rewind({
          day: 1
        });
        return this.$el.html(this.template({
          currentYear: this.chronologyModel.get('year'),
          startDate: startOfYear,
          endDate: endOfYear,
          activeDateStart: activeDateList.shift().set({
            day: 1
          }),
          activeDateEnd: activeDateList.shift().endOfMonth().resetTime()
        }));
      };

      MonthView.prototype.setMonth = function(event) {
        var newMonth;
        newMonth = _.indexOf(this.chronologyModel.get('monthsShort'), $(event.target).text());
        return this.chronologyModel.set({
          month: newMonth
        });
      };

      MonthView.prototype.onClose = function() {
        return this.chronologyModel.off('change', this.render, this);
      };

      return MonthView;

    })(DatePickerSubViewBase);
    YearView = (function(_super) {

      __extends(YearView, _super);

      function YearView() {
        return YearView.__super__.constructor.apply(this, arguments);
      }

      YearView.prototype.className = 'datepicker-years';

      YearView.prototype.events = {
        'click .year': 'setYear'
      };

      YearView.prototype.initialize = function() {
        YearView.__super__.initialize.call(this);
        this.template = yearsTemplate;
        this.chronologyModel.on('change', this.render, this);
        return this.render();
      };

      YearView.prototype.render = function() {
        var activeDateList, endOfYears, startOfYears, year;
        year = this.chronologyModel.get('year');
        startOfYears = Date.create(String(year));
        endOfYears = startOfYears.clone().advance({
          years: 27
        });
        activeDateList = this.chronologyModel.getActiveDateRangeList();
        return this.$el.html(this.template({
          yearRange: "" + year + "-" + (year + 26),
          startDate: startOfYears,
          endDate: endOfYears,
          activeDateStart: activeDateList.shift().format('{yyyy}'),
          activeDateEnd: activeDateList.shift().format('{yyyy}')
        }));
      };

      YearView.prototype.setYear = function() {
        return this.chronologyModel.set({
          year: parseInt($(event.target).text(), 10)
        });
      };

      YearView.prototype.onClose = function() {
        return this.chronologyModel.off('change', this.render, this);
      };

      return YearView;

    })(DatePickerSubViewBase);
    CalendarView = (function(_super) {

      __extends(CalendarView, _super);

      function CalendarView() {
        return CalendarView.__super__.constructor.apply(this, arguments);
      }

      CalendarView.BEGIN = 'begin';

      CalendarView.END = 'end';

      CalendarView.prototype.className = 'datepicker-days';

      CalendarView.prototype.events = {
        'click .day': 'setActiveDay'
      };

      CalendarView.prototype.initialize = function() {
        CalendarView.__super__.initialize.call(this);
        this.template = datePickerTemplate;
        this.chronologyModel.on('change', this.fill, this);
        this.type = this.options.type;
        return this.render();
      };

      CalendarView.prototype.render = function() {
        this.$el.append(this.template({
          days: this.chronologyModel.get('daysMin')
        }));
        return this.fill();
      };

      CalendarView.prototype.fill = function() {
        var activeDateList, clsName, currentMonth, currentMonthStartDay, day, html, month, nextMonth, year, _i;
        currentMonth = this.type === CalendarView.BEGIN ? this.chronologyModel.getDate().clone() : this.chronologyModel.getDate().clone().advance({
          months: 1
        });
        year = currentMonth.getFullYear();
        month = currentMonth.getMonth();
        nextMonth = currentMonth.clone().advance({
          months: 1
        });
        currentMonthStartDay = currentMonth.getDay();
        html = [];
        activeDateList = this.chronologyModel.getActiveDateRangeList();
        this.$el.find('th.switch').text("" + (currentMonth.format('{Month} {yyyy}')));
        if (currentMonthStartDay !== 0) {
          html.push('<tr>');
          for (day = _i = currentMonthStartDay; currentMonthStartDay <= 0 ? _i < 0 : _i > 0; day = currentMonthStartDay <= 0 ? ++_i : --_i) {
            html.push('<td></td>');
          }
        }
        while (currentMonth.valueOf() < nextMonth.valueOf()) {
          clsName = '';
          if (currentMonth.getDay() === 0) {
            html.push('<tr>');
          }
          if (currentMonth.isBetween(activeDateList[0].clone().rewind({
            second: 1
          }), activeDateList[1].clone().advance({
            second: 1
          }))) {
            clsName += ' active';
          }
          html.push("<td class=\"day" + clsName + "\"         data-date=\"" + (currentMonth.format('{MM}/{dd}/{yyyy}')) + "\">" + (currentMonth.getDate()) + "</td>");
          if (currentMonth.getDay() === 6) {
            html.push('</tr>');
          }
          currentMonth.setDate(currentMonth.getDate() + 1);
        }
        this.$el.find('tbody').empty().append(html.join(''));
        return this;
      };

      CalendarView.prototype.setActiveDay = function(event) {
        var date;
        date = $(event.target).data('date');
        return this.chronologyModel.setActiveDate(date);
      };

      CalendarView.prototype.onClose = function() {
        return this.chronologyModel.off('change', this.fill, this);
      };

      return CalendarView;

    })(DatePickerSubViewBase);
    MultiDatePickerView = (function(_super) {

      __extends(MultiDatePickerView, _super);

      function MultiDatePickerView() {
        return MultiDatePickerView.__super__.constructor.apply(this, arguments);
      }

      MultiDatePickerView.CALENDARS = 'days';

      MultiDatePickerView.MONTHS = 'months';

      MultiDatePickerView.YEARS = 'years';

      MultiDatePickerView.STATES = [MultiDatePickerView.CALENDARS, MultiDatePickerView.MONTHS, MultiDatePickerView.YEARS];

      MultiDatePickerView.prototype.tagName = 'div';

      MultiDatePickerView.prototype.className = 'datepicker';

      MultiDatePickerView.prototype.events = {
        'click .next': 'move',
        'click .prev': 'move',
        'click .switch': 'pushState',
        'click .month': 'popState',
        'click .year': 'popState',
        'mousedown': 'mouseDown'
      };

      MultiDatePickerView.prototype.state = null;

      MultiDatePickerView.prototype.chronologyModel = null;

      MultiDatePickerView.prototype.calendars = [];

      MultiDatePickerView.prototype.calendarButton = null;

      MultiDatePickerView.prototype.calendarInput = null;

      MultiDatePickerView.prototype.monthView = null;

      MultiDatePickerView.prototype.yearView = null;

      MultiDatePickerView.prototype.dayViews = [];

      MultiDatePickerView.prototype.initialize = function() {
        var existingDateRange, formElementContainerDiv;
        if (!_.has(this.options, 'formElementContainerDiv')) {
          throw new Error('Multi Date Picker must be constructed with an associated form element container.');
        }
        _.bindAll(this, 'show');
        this.chronologyModel = new models.ChronologyModel();
        this.state = new Backbone.Model();
        this.state.on('change:currentState', this.changeState, this);
        this.state.set({
          currentState: MultiDatePickerView.CALENDARS
        });
        formElementContainerDiv = $(this.options.formElementContainerDiv);
        this.calendarButton = formElementContainerDiv.find('.dateselect');
        this.calendarButton.on('click', this, this.show);
        this.calendarInput = formElementContainerDiv.find('input');
        existingDateRange = this.getDateRangeFromInput();
        if (existingDateRange.length) {
          this.chronologyModel.set({
            activeDateStart: Date.create(existingDateRange.shift())
          });
          this.chronologyModel.set({
            activeDateEnd: Date.create(existingDateRange.shift())
          });
          this.chronologyModel.setDate(this.chronologyModel.get('activeDateStart'));
        }
        return this.render();
      };

      MultiDatePickerView.prototype.render = function() {
        this.monthView = new MonthView({
          chronologyModel: this.chronologyModel
        });
        this.yearView = new YearView({
          chronologyModel: this.chronologyModel
        });
        this.dayViews = [
          new CalendarView({
            type: CalendarView.BEGIN,
            chronologyModel: this.chronologyModel
          }), new CalendarView({
            type: CalendarView.END,
            chronologyModel: this.chronologyModel
          })
        ];
        this.$el.addClass('dropdown-menu multiDatePicker').append(multiDatePickerTemplate());
        this.$el.find('.calendarContainer').append(this.dayViews[0].$el).append(this.dayViews[1].$el).append(this.monthView.$el).append(this.yearView.$el);
        this.$el.appendTo('body');
        return this;
      };

      MultiDatePickerView.prototype.move = function(event) {
        var direction, movement;
        movement = {};
        direction = $(event.currentTarget).attr('class') === 'next' ? 'advance' : 'rewind';
        switch (this.state.get('currentState')) {
          case MultiDatePickerView.CALENDARS:
            movement = {
              months: 1
            };
            break;
          case MultiDatePickerView.MONTHS:
            movement = {
              years: 1
            };
            break;
          case MultiDatePickerView.YEARS:
            movement = {
              years: 27
            };
        }
        return this.chronologyModel.setDate(this.chronologyModel.getDate().clone()[direction](movement));
      };

      MultiDatePickerView.prototype.show = function(event) {
        event.data.place();
        event.data.$el.show();
        event.stopPropagation();
        return $(document).on('mousedown', event.data, event.data.hide);
      };

      MultiDatePickerView.prototype.hide = function(event) {
        event.data.trigger('hide', event.data);
        event.data.$el.hide();
        event.data.state.set('currentState', MultiDatePickerView.CALENDARS);
        event.data.setDateValueToInput();
        return $(document).off('mousedown', this.hide);
      };

      MultiDatePickerView.prototype.place = function() {
        var offset;
        offset = this.calendarButton.offset();
        return this.$el.css({
          top: offset.top + this.calendarButton.outerHeight(),
          left: offset.left
        });
      };

      MultiDatePickerView.prototype.pushState = function() {
        var nextIndex, states;
        states = MultiDatePickerView.STATES;
        nextIndex = _.indexOf(states, this.state.get('currentState')) + 1;
        if (nextIndex < states.length) {
          return this.state.set({
            currentState: states[nextIndex]
          });
        }
      };

      MultiDatePickerView.prototype.popState = function() {
        var previousIndex, states;
        states = MultiDatePickerView.STATES;
        previousIndex = _.indexOf(states, this.state.get('currentState')) - 1;
        if (previousIndex >= 0) {
          return this.state.set({
            currentState: states[previousIndex]
          });
        }
      };

      MultiDatePickerView.prototype.changeState = function() {
        var states;
        states = MultiDatePickerView.STATES.clone();
        return this.$el.addClass(states.splice(_.indexOf(states, this.state.get('currentState')), 1).pop()).removeClass(states.join(' '));
      };

      MultiDatePickerView.prototype.getDateRangeFromInput = function() {
        var out;
        out = [];
        out = [_.isNumber(this.calendarInput.data('startdate')) ? this.calendarInput.data('startdate') : void 0, _.isNumber(this.calendarInput.data('enddate')) ? this.calendarInput.data('enddate') : void 0];
        return out;
      };

      MultiDatePickerView.prototype.setDateValueToInput = function() {
        return this.calendarInput.attr('value', this.chronologyModel.getActiveDatesAsString());
      };

      MultiDatePickerView.prototype.mouseDown = function(event) {
        event.stopPropagation();
        return event.preventDefault();
      };

      MultiDatePickerView.prototype.onClose = function() {
        var dayView, _i, _len, _ref, _results;
        this.calendarButton.off('click', this, this.show);
        this.state.off('change:currentState', this.changeState, this);
        this.monthView.close();
        this.yearView.close();
        _ref = this.dayViews;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dayView = _ref[_i];
          _results.push(dayView.close());
        }
        return _results;
      };

      return MultiDatePickerView;

    })(Backbone.View);
    return {
      'MultiDatePickerView': MultiDatePickerView,
      'CalendarView': CalendarView
    };
  });

}).call(this);