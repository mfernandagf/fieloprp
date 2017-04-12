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
    SAVE_CONTROLLER: 'FieloPRP.InvoiceLandingController.save',
    MEMBER: 'FieloPRP__Member__c',
    PRODUCT_RECENT: 'recentProductRecords',
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
    ITEMS_CONTAINER: 'fielosf-invoice-items',
    SAVE: 'slds-form__save',
    CANCEL: 'slds-form__cancel',
    DELETE: 'slds-button--delete',
    NEW: 'slds-button--new',
    ELEMENT: 'slds-form-element',
    INVOICE_ITEM: 'fielosf-invoice__item',
    ADD_PRODUCTS: 'slds-button--addproducts',
    PRODUCT_QTY: 'fielosf-product_qty',
    PRODUCT_UNIT_PRICE: 'fielosf-product_unit-price',
    PRODUCT_TOTAL_PRICE: 'fielosf-product_total-price',
    PRODUCT_NAME: 'fielosf-product_name',
    PRODUCT_FORM: 'fielosf-invoice-form-addproducts',
    PRODUCT_ADD: 'slds-form-product__add',
    PRODUCT_CANCEL: 'slds-form-product__cancel',
    PRODUCT_SEARCH: 'slds-form-product__search',
    RECENT_RECORDS: 'fielosf-recent-records__model',
    RECENT_CHECKBOX: 'fielosf-recent-records-checkbox',
    LOOKUP_PILL: 'slds-pill_container',
    SHOW: 'slds-show',
    INVOICE_AMOUNT: 'fielosf-invoice_amount'

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
      if (formValues.Id === '') {
        delete formValues.Id;
      }
      for (var field in formValues) {
        if (field !== null) {
          if (field === 'FieloPRP__Date__c') {
            formValues[field] =
              formValues[field].toDate().getTime();
          }
        }
      }
      console.log(formValues);
      var itemValues = this.itemsContainer_.FieloInvoiceItems.get();
      // verifico si hay al menos un item en cero o un reward sin elegir
      var quantityInCero = false;
      var emptyProduct = false;
      itemValues.forEach(function(item) {
        if (item.FieloPRP__Quantity__c === '0') {
          quantityInCero = true;
        }
        if (item.FieloPRP__Product__c === null) {
          emptyProduct = true;
        }
      });

      if (quantityInCero) {
        fielo.util.spinner.FieloSpinner.hide();

        event = {message: 'Quantity cannot be 0'};
        this.form_.processRemoteActionResult_(null, event);
      } else if (emptyProduct) {
        fielo.util.spinner.FieloSpinner.hide();

        event = {message: 'Product cannot be empty'};
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
    var invoiceValues = {};
    // invoiceValues.sObjectType =
    //  this.form_.element_.getAttribute(this.form_.Constant_.OBJECT_NAME);

    [].forEach.call(this.invoiceElements_, function(element) {
      if (element.FieloFormElement.get('fieldName') !== '') {
        var property = element.FieloFormElement.get('fieldName');
        if (property) {
          this.form_.elements_[property] = element;
          invoiceValues[property] = element.FieloFormElement.get('value');
        }
      }
    }, this);
    return invoiceValues;
  };

  FieloFormInvoice.prototype.setValues_ = function() {
    return this.itemsContainer_.FieloInvoiceItems.set();
  };

  FieloFormInvoice.prototype.clear_ = function() {
    if (!this.keepItems_) {
      [].forEach.call(this.invoiceElements_, function(item) {
        item.FieloFormElement.clear();
      });
      this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)[0]
        .FieloInvoiceItems.clear();
    }
  };

  FieloFormInvoice.prototype.setMemberFilter_ = function() {
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    this.rewardPaginator_ =
      this.productRecent_.FieloRecentRecords.getPaginator(
        ).FieloPaginator;
    this.memberFilter = [];

    this.memberFilter[this.Constant_.MEMBER] =
      this.element_.querySelector(
        '[data-field-name="FieloPRP__Member__c"]').FieloFormElement.get(
        'value');
    this.rewardPaginator_.setFilters(
        this.memberFilter);
  };

  /**
   * Reload Reward Recent Records
   */
  FieloFormInvoice.prototype.reloadproductRecent_ = function() {
    this.keepItems_ = true;
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.resetSearch_();
      // this.setMemberFilter_();
      this.recentPaginator_ =
        this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
      this.recentPaginator_.setPage();
      this.recentPaginator_.getRecords();
    }
  };

  FieloFormInvoice.prototype.resetSearch_ = function() {
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.searchFields_ = this.productForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];
      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.rewardPaginator_ =
          this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
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
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.searchFields_ = this.productForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];

      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.rewardPaginator_ =
          this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
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
      if (this.itemsContainer_ !== null && this.itemsContainer_ !== undefined) {
        componentHandler.upgradeElement(this.itemsContainer_);
      }

      this.element_.FieloForm.save_ = this.save_.bind(this);

      this.form_.clear_ = this.clear_.bind(this);

      this.invoiceElements_ = $(
        this.element_
          .getElementsByClassName(this.CssClasses_.ELEMENT)
      ).not(
        this.itemsContainer_ !== null &&
          this.itemsContainer_ !== undefined ?
          this.itemsContainer_.getElementsByClassName(
            this.CssClasses_.ELEMENT) :
          null
      );

      this.form_.save_ = this.save_.bind(this);

      this.memberField_ =
        this.element_.querySelector('[data-field-name="FieloPRP__Member__c"]');

      if (this.openForm_.length > 0) {
        var Id = this.openForm_[1];
        this.memberField_.FieloFormElement.set('value', Id);
        $(this.element_).modal('show');
      }
      this.invoiceAmount_ =
        this.element_.querySelector('.' + this.CssClasses_.INVOICE_AMOUNT);

      if (this.keepItems_ === null || this.keepItems_ === undefined) {
        this.keepItems_ = false;
      }

      this.addProductsBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.ADD_PRODUCTS)[0];
      // Method to disable any action when no member is given
      this.addProductsBtn_.addEventListener('click',
        this.verifyMember_.bind(this));
      // Method to refresh recend records from the add rewards modal
      this.addProductsBtn_.addEventListener('click',
        this.reloadproductRecent_.bind(this));

      this.cancelBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.CANCEL)[0];
      // Make filled fields persistent
      this.cancelBtn_.addEventListener('click',
        this.resetKeepItems.bind(this));

      this.newProductBtn = this.element_.getElementsByClassName(
        this.CssClasses_.NEW)[0];
      // Method to disable any action when no member is given
      this.newProductBtn.addEventListener('click',
        this.verifyMember_.bind(this));

      this.productForm_ =
        document.getElementsByClassName(this.CssClasses_.PRODUCT_FORM)[0];
      if (this.productForm_ !== null && this.productForm_ !== undefined) {
        this.productFormAddBtn_ =
          this.productForm_.getElementsByClassName(
            this.CssClasses_.PRODUCT_ADD)[0];
        // Add selected rewards to basket
        this.productFormAddBtn_.addEventListener('click',
          this.updateProductBasket.bind(this));

        this.productFormSearchBtn_ =
          this.productForm_.getElementsByClassName(
            this.CssClasses_.PRODUCT_SEARCH)[0];
        // Executes the reward search based on modal filters
        this.productFormSearchBtn_.addEventListener('click',
          this.searchRecords_.bind(this));

        this.cancelProductsAddBtn_ = document.getElementsByClassName(
          this.CssClasses_.PRODUCT_CANCEL)[0];
        this.productRecent_ = document.getElementById(
          this.Constant_.PRODUCT_RECENT);
        // Unmark selected rows in the rewards modal
        this.cancelProductsAddBtn_.addEventListener('click',
          this.productRecent_.FieloRecentRecords.uncheckAll.bind(
            this.productRecent_.FieloRecentRecords));
      }
    }
  };

  FieloFormInvoice.prototype.updateProductBasket = function() {
    this.recentProductRecords_ =
      this.productForm_.getElementsByClassName(this.CssClasses_.RECENT_RECORDS);
    this.productsInfo_ = [];

    [].forEach.call(this.recentProductRecords_, function(element) {
      this.recordCheckbox =
        element.getElementsByClassName(
          this.CssClasses_.RECENT_CHECKBOX)[0];
      if (this.recordCheckbox.checked === true) {
        this.productsInfo_.push(element.getAttribute(
            this.Constant_.DATA_RECORD_ID));
      }
    },
      this
    );

    this.invoiceItems_ = this.element_.getElementsByClassName(
      this.CssClasses_.ITEMS_CONTAINER)[0];

    this.getEmptyInvoiceItems();

    [].forEach.call(this.productsInfo_, function(productId) {
      if (productId !== null &&
        productId !== undefined) {
        if (this.availableSlots.length > 0) {
          this.lastInvoiceItem = this.availableSlots.pop();
        } else {
          this.invoiceContainerItems_ = this.element_.getElementsByClassName(
          this.CssClasses_.ITEMS_CONTAINER)[0];
          // todo: discover a new way to create redemption items, or turn the
          // the method into a public method
          this.invoiceContainerItems_.FieloInvoiceItems.newinvoiceItem_();
          this.invoiceItems_ =
            this.element_.getElementsByClassName(
              this.CssClasses_.INVOICE_ITEM);
          this.lastInvoiceItem =
            this.invoiceItems_[this.invoiceItems_.length - 1];
        }

        this.elementFields = this.lastInvoiceItem.getElementsByClassName(
          this.CssClasses_.ELEMENT);

        $(this.lastInvoiceItem).find(
            $('[data-field-name="FieloPRP__Product__c"]')
            )[0].FieloFormElement.set('value', productId);
        $(this.lastInvoiceItem).find(
            $('[data-field-name="FieloPRP__Quantity__c"]')
            )[0].FieloFormElement.set('value', 1);
        this.activeItem = this.lastInvoiceItem;
        this.activeItem.setAttribute('data-value', productId);
        this.refreshTotalPrice();
      }
    },
      this
    );
    this.productRecent_.FieloRecentRecords.uncheckAll();
  };

  /**
   * Set the available redemptions slots array
   *
   */
  FieloFormInvoice.prototype.getEmptyInvoiceItems = function() {
    var product;
    this.availableSlots = [];
    [].forEach.call(
      this.element_.getElementsByClassName(this.CssClasses_.INVOICE_ITEM),
      function(element) {
        product =
          $(element).find(
            $('[data-field-name="FieloPRP__Product__c"]')
            )[0].FieloFormElement.get('value');
        if (product === null || product === undefined) {
          this.availableSlots.push(element);
        }
      },
        this
    );
  };

  FieloFormInvoice.prototype.refreshTotalPrice = function() {
    console.log('refreshTotalPrice');
  };

  FieloFormInvoice.prototype.refreshTotalPriceProxy_ = function(
    value
  ) {
    var _this = $(this.element_).closest(
        '.fielosf-invoice-form')[0].FieloFormInvoice;
    /*
    if (_this !== null && _this !== undefined) {
      _this.activeItem = $(this.element_).closest(
        '.fielosf-invoice__item')[0];
      if (value && value.metaLabel !== undefined) {
        _this.activeItem.setAttribute('data-value', value.metaLabel);
      }
      _this.refreshPoints();
    }
    */
    console.log('refreshTotalPriceProxy_');
    console.log('value: ' + value);
    _this.refreshTotalPrice();
  };

  FieloFormInvoice.prototype.verifyMember_ = function(event) {
    var memberId = document.querySelector(
      '[data-field-name="FieloPRP__Member__c"]'
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

  window.FieloFormInvoice_refreshPoints = // eslint-disable-line camelcase
      FieloFormInvoice.prototype.refreshTotalPriceProxy_;

  fielo.helper.register({
    constructor: FieloFormInvoice,
    classAsString: 'FieloFormInvoice',
    cssClass: 'fielosf-invoice-form',
    widget: true
  });
})();

