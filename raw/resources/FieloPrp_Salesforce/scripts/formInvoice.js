(function() {
  'use strict';

  var FieloFormInvoice = function FieloFormInvoice(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloFormInvoice = FieloFormInvoice;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloFormInvoice.prototype.Constant_ = {
    SAVE_CONTROLLER: 'FieloPLT.RedemptionLandingController.save',
    MEMBER: 'FieloPLT__Member__c',
    REWARD_RECENT: 'recentRewardRecords',
    DATA_RECORD_ID: 'data-record-id'
  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloFormInvoice.prototype.CssClasses_ = {
    ITEMS_CONTAINER: 'fielosf-items',
    SAVE: 'slds-form__save',
    CANCEL: 'slds-form__cancel',
    DELETE: 'slds-button--delete',
    NEW: 'slds-button--new',
    ELEMENT: 'slds-form-element',
    REDEMPTION_ITEM: 'fielosf-redemption__item',
    ADD_REWARDS: 'slds-button--addrewards',
    REWARD_QTY: 'fielosf-reward_qty',
    REWARD_NAME: 'fielosf-reward_name',
    REWARD_POINTS: 'fielosf-reward_points',
    REWARD_FORM: 'fielosf-redemption-form-addrewards',
    REWARD_ADD: 'slds-form-reward__add',
    REWARD_CANCEL: 'slds-form-reward__cancel',
    REWARD_SEARCH: 'slds-form-reward__search',
    RECENT_RECORDS: 'fielosf-recent-records__model',
    RECENT_CHECKBOX: 'fielosf-recent-records-checkbox',
    LOOKUP_PILL: 'slds-pill_container',
    SHOW: 'slds-show',
    TOTAL_POINTS: 'fielosf-total_points'

  };

  /**
   * Envía el formulario
   */
  FieloFormInvoice.prototype.save_ = function() {
    fielo.util.spinner.FieloSpinner.show();
    var memberValue = this.element_
      .querySelector('[data-field-name="' + this.Constant_.MEMBER + '"]')
        .FieloFormElement.get('value');
    var event = '';
    if (memberValue) {
      fielo.util.spinner.FieloSpinner.show();
      var formValues = this.getValues_();
      var itemValues = this.itemsContainer_.FieloItems.get();
      // verifico si hay al menos un item en cero o un reward sin elegir
      var quantityInCero = false;
      var emptyReward = false;
      itemValues.forEach(function(item) {
        if (item.FieloPLT__Quantity__c === '0') {
          quantityInCero = true;
        }
        if (item.FieloPLT__Reward__c === null) {
          emptyReward = true;
        }
      });

      if (quantityInCero) {
        fielo.util.spinner.FieloSpinner.hide();

        event = {message: 'Quantity cannot be 0'};
        this.form_.processRemoteActionResult_(null, event);
      } else if (emptyReward) {
        fielo.util.spinner.FieloSpinner.hide();

        event = {message: 'Reward cannot be empty'};
        this.form_.processRemoteActionResult_(null, event);
      } else {
        try {
          Visualforce.remoting.Manager.invokeAction(
            this.Constant_.SAVE_CONTROLLER,
            formValues,
            itemValues,
            this.form_.processRemoteActionResult_.bind(this.form_),
            {
              escape: false
            }
          );
        } catch (e) {
          console.warn(e);
        }
      }
    } else {
      event = {message: 'Must select a member'};
      this.form_.processRemoteActionResult_(null, event);
    }
    this.keepItems_ = false;
  };

  FieloFormInvoice.prototype.getValues_ = function() {
    this.form_.elements_ = [];
    var redemptionValues = {};
    // redemptionValues.sObjectType =
    //  this.form_.element_.getAttribute(this.form_.Constant_.OBJECT_NAME);

    [].forEach.call(this.redemptionElements_, function(element) {
      if (element.FieloFormElement.get('fieldName') !== '') {
        var property = element.FieloFormElement.get('fieldName');
        if (property) {
          this.form_.elements_[property] = element;
          redemptionValues[property] = element.FieloFormElement.get('value');
        }
      }
    }, this);
    return redemptionValues;
  };

  FieloFormInvoice.prototype.setValues_ = function() {
    return this.itemsContainer_.FieloItems.set();
  };

  FieloFormInvoice.prototype.clear_ = function() {
    if (!this.keepItems_) {
      [].forEach.call(this.redemptionElements_, function(item) {
        item.FieloFormElement.clear();
      });
      this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)[0]
        .FieloItems.clear();
    }
  };

  FieloFormInvoice.prototype.setMemberFilter_ = function() {
    this.rewardRecent_ = document.getElementById(
      this.Constant_.REWARD_RECENT);
    this.rewardPaginator_ =
      this.rewardRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
    this.memberFilter = [];

    this.memberFilter[this.Constant_.MEMBER] =
      this.element_.querySelector(
        '[data-field-name="FieloPLT__Member__c"]').FieloFormElement.get(
        'value');
    this.rewardPaginator_.setFilters(
        this.memberFilter);
  };

  /**
   * Reload Reward Recent Records
   */
  FieloFormInvoice.prototype.reloadRewardRecent_ = function() {
    this.keepItems_ = true;
    this.rewardRecent_ = document.getElementById(
      this.Constant_.REWARD_RECENT);
    if (this.rewardRecent_ !== null && this.rewardRecent_ !== undefined) {
      this.resetSearch_();
      this.setMemberFilter_();
      this.recentPaginator_ =
        this.rewardRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
      this.recentPaginator_.setPage();
      this.recentPaginator_.getRecords();
    }
  };

  FieloFormInvoice.prototype.resetSearch_ = function() {
    this.rewardRecent_ = document.getElementById(
      this.Constant_.REWARD_RECENT);
    if (this.rewardRecent_ !== null && this.rewardRecent_ !== undefined) {
      this.searchFields_ = this.rewardForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];
      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.rewardPaginator_ =
          this.rewardRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
        delete this.rewardPaginator_.getFilters()[
            this.filterField_.get('fieldName')];
      },
      this
      );
      this.rewardPaginator_.setFilters(this.newFilters_);
    }
  };

  /**
   * Execute Search
   */
  FieloFormInvoice.prototype.searchRecords_ = function() {
    this.rewardRecent_ = document.getElementById(
      this.Constant_.REWARD_RECENT);
    if (this.rewardRecent_ !== null && this.rewardRecent_ !== undefined) {
      this.searchFields_ = this.rewardForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];

      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.rewardPaginator_ =
          this.rewardRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
        if (this.filterField_.get('value') !== '' &&
          this.filterField_.get('value') !== null &&
          this.filterField_.get('value') !== undefined) {
          if (this.filterField_.get('type') === 'input-double') {
            this.newFilters_[
              this.filterField_.get('fieldName')] =
              parseFloat(this.filterField_.get('value'));
          } else {
            this.newFilters_[
              this.filterField_.get('fieldName')] =
              this.filterField_.get('value');
          }
        } else {
          delete this.rewardPaginator_.getFilters()[
            this.filterField_.get('fieldName')];
        }
      },
      this
      );
      this.rewardPaginator_.setFilters(this.newFilters_);
      this.rewardPaginator_.setPage();
      this.rewardPaginator_.getRecords();
    }
  };

  FieloFormInvoice.prototype.resetKeepItems = function() {
    this.keepItems_ = false;
  };

  FieloFormInvoice.prototype.showItems_ = function() {
    if (this.memberField_.FieloFormElement.get('value') === null ||
      this.memberField_.FieloFormElement.get('value') === undefined) {
      $(this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)
        ).addClass('slds-hide');
    } else {
      $(this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)
        ).removeClass('slds-hide');
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloFormInvoice.prototype.init = function() {
    if (this.element_) {
      this.openForm_ = location.hash.split('#').slice(1);

      this.form_ = this.element_.FieloForm;
      this.itemsContainer_ =
        this.element_
          .getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)[0];
      componentHandler.upgradeElement(this.itemsContainer_);
      this.element_.FieloForm.save_ = this.save_.bind(this);

      this.form_.clear_ = this.clear_.bind(this);

      this.redemptionElements_ = $(
        this.element_
          .getElementsByClassName(this.CssClasses_.ELEMENT)
      ).not(
        this.itemsContainer_.getElementsByClassName(this.CssClasses_.ELEMENT)
      );

      this.form_.save_ = this.save_.bind(this);

      this.memberField_ =
        this.element_.querySelector('[data-field-name="FieloPLT__Member__c"]');

      if (this.openForm_.length > 0) {
        var Id = this.openForm_[1];
        this.memberField_.FieloFormElement.set('value', Id);
        $(this.element_).modal('show');
      }
      this.orderTotal_ =
        this.element_.querySelector('.' + this.CssClasses_.TOTAL_POINTS);

      if (this.keepItems_ === null || this.keepItems_ === undefined) {
        this.keepItems_ = false;
      }

      this.addRewardsBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.ADD_REWARDS)[0];
      // Method to disable any action when no member is given
      this.addRewardsBtn_.addEventListener('click',
        this.verifyMember_.bind(this));
      // Method to refresh recend records from the add rewards modal
      this.addRewardsBtn_.addEventListener('click',
        this.reloadRewardRecent_.bind(this));

      this.cancelBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.CANCEL)[0];
      // Make filled fields persistent
      this.cancelBtn_.addEventListener('click',
        this.resetKeepItems.bind(this));

      this.newRewardBtn = this.element_.getElementsByClassName(
        this.CssClasses_.NEW)[0];
      // Method to disable any action when no member is given
      this.newRewardBtn.addEventListener('click',
        this.verifyMember_.bind(this));

      this.rewardForm_ =
        document.getElementsByClassName(this.CssClasses_.REWARD_FORM)[0];
      if (this.rewardForm_ !== null && this.rewardForm_ !== undefined) {
        this.rewardFormAddBtn_ =
          this.rewardForm_.getElementsByClassName(
            this.CssClasses_.REWARD_ADD)[0];
        // Add selected rewards to basket
        this.rewardFormAddBtn_.addEventListener('click',
          this.updateRetemptionBasket.bind(this));

        this.rewardFormSearchBtn_ =
          this.rewardForm_.getElementsByClassName(
            this.CssClasses_.REWARD_SEARCH)[0];
        // Executes the reward search based on modal filters
        this.rewardFormSearchBtn_.addEventListener('click',
          this.searchRecords_.bind(this));

        this.cancelRewardsAddBtn_ = document.getElementsByClassName(
          this.CssClasses_.REWARD_CANCEL)[0];
        this.rewardRecent_ = document.getElementById(
          this.Constant_.REWARD_RECENT);
        // Unmark selected rows in the rewards modal
        this.cancelRewardsAddBtn_.addEventListener('click',
          this.rewardRecent_.FieloRecentRecords.uncheckAll.bind(
            this.rewardRecent_.FieloRecentRecords));
      }
    }
  };

  FieloFormInvoice.prototype.updateRetemptionBasket = function() {
    this.recentRewardRecords_ =
      this.rewardForm_.getElementsByClassName(this.CssClasses_.RECENT_RECORDS);
    this.rewardsInfo_ = {};
    [].forEach.call(this.recentRewardRecords_, function(element) {
      this.recordCheckbox =
        element.getElementsByClassName(
          this.CssClasses_.RECENT_CHECKBOX)[0];
      if (this.recordCheckbox.checked === true) {
        this.rewardsInfo_[element.getAttribute(
            this.Constant_.DATA_RECORD_ID)] =
              element.querySelector(
                '[data-field="FieloPLT__Points__c"]').innerHTML;
      }
    },
      this
    );
    this.redemptionItems_ = this.element_.getElementsByClassName(
      this.CssClasses_.ITEMS_CONTAINER)[0];
    this.getEmptyRedemptionItems();
    for (var rewardId in this.rewardsInfo_) {
      if (this.rewardsInfo_[rewardId] !== null &&
        this.rewardsInfo_[rewardId] !== undefined) {
        if (this.availableSlots.length > 0) {
          this.lastRedemptionItem = this.availableSlots.pop();
        } else {
          this.redemptionContainerItems_ = this.element_.getElementsByClassName(
          this.CssClasses_.ITEMS_CONTAINER)[0];
          // todo: discover a new way to create redemption items, or turn the
          // the method into a public method
          this.redemptionContainerItems_.FieloItems.newRedemptionItem_();
          this.redemptionItems_ =
            this.element_.getElementsByClassName(
              this.CssClasses_.REDEMPTION_ITEM);
          this.lastRedemptionItem =
            this.redemptionItems_[this.redemptionItems_.length - 1];
        }

        this.elementFields = this.lastRedemptionItem.getElementsByClassName(
          this.CssClasses_.ELEMENT);

        for (var fieldPtr = 0; fieldPtr < this.elementFields.length;
          fieldPtr++) {
          if (this.elementFields[fieldPtr].FieloFormElement.get('fieldName') ===
            'FieloPLT__Reward__c') {
            this.elementFields[fieldPtr].FieloFormElement.set('value',
              rewardId);
            this.activeItem = this.lastRedemptionItem;
            this.activeItem.setAttribute('data-value',
              this.rewardsInfo_[rewardId]);
            this.refreshPoints();
          }
        }
      }
    }
    this.rewardRecent_.FieloRecentRecords.uncheckAll();
  };

  /**
   * Set the available redemptions slots array
   *
   */
  FieloFormInvoice.prototype.getEmptyRedemptionItems = function() {
    var reward;
    this.availableSlots = [];
    [].forEach.call(
      this.element_.getElementsByClassName(this.CssClasses_.REDEMPTION_ITEM),
      function(element) {
        reward =
          $(element).find(
            $('[data-field-name="FieloPLT__Reward__c"]')
            )[0].FieloFormElement.get('value');
        if (reward === null || reward === undefined) {
          this.availableSlots.push(element);
        }
      },
        this
    );
  };

  FieloFormInvoice.prototype.refreshPoints = function() {
    var points = this.activeItem.getAttribute('data-value');
    var qty = this.activeItem.querySelector(
      '.' + this.CssClasses_.REWARD_QTY + ' .' + this.CssClasses_.ELEMENT
    ).FieloFormElement.get('value');

    if (
      !points ||
      !this.activeItem.querySelector(
        '.' + this.CssClasses_.REWARD_NAME + ' .' + this.CssClasses_.ELEMENT
        ).FieloFormElement.get('value')
    ) {
      points = 0;
    }
    var totalPoints = qty * points;
    this.activeItem.querySelector('.' + this.CssClasses_.REWARD_POINTS)
      .innerHTML = totalPoints;

    var orderPoints = 0;
    var orderedElements =
      this.element_.querySelectorAll('.' + this.CssClasses_.REWARD_POINTS);
    [].forEach.call(orderedElements, function(item) {
      orderPoints += Number(item.innerHTML);
    });
    this.orderTotal_.innerHTML = orderPoints;

    this.keepItems_ = true;
  };

  FieloFormInvoice.prototype.refreshPointsProxy_ = function(
    value
  ) {
    var _this = $(this.element_).closest(
        '.fielosf-redemption-form')[0].FieloFormInvoice;
    if (_this !== null && _this !== undefined) {
      _this.activeItem = $(this.element_).closest(
        '.fielosf-redemption__item')[0];
      if (value && value.metaLabel !== undefined) {
        _this.activeItem.setAttribute('data-value', value.metaLabel);
      }
      _this.refreshPoints();
    }
  };

  FieloFormInvoice.prototype.verifyMember_ = function(event) {
    var memberId = document.querySelector(
      '[data-field-name="FieloPLT__Member__c"]'
      ).FieloFormElement.get('value');
    if (memberId === null || memberId === undefined) {
      event.stopPropagation();
      event.preventDefault();
      this.keepItems_ = false;
      this.clear_();
      var result = {message: 'Must select a member.'};
      this.form_.processRemoteActionResult_(null, result);
    }
  };

  window.FieloFormRedemption_refreshPoints = // eslint-disable-line camelcase
      FieloFormInvoice.prototype.refreshPointsProxy_;

  fielo.helper.register({
    constructor: FieloFormInvoice,
    classAsString: 'FieloFormInvoice',
    cssClass: 'fielosf-redemption-form',
    widget: true
  });
})();

