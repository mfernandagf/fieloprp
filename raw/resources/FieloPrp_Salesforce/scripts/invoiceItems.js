(function() {
  'use strict';

  /**
   * @description Controlador para el formulario FieloInvoiceItems.
   * Permite el envío del formulario
   * Implementa los patrones de diseño definidos por MDL en
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Elemento que será mejorado.
   * @constructor
   */
  var FieloInvoiceItems = function FieloInvoiceItems(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloInvoiceItems = FieloInvoiceItems;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloInvoiceItems.prototype.Constant_ = {
    DATA_UPGRADED: 'data-upgraded',
    DATA_CONTROLLER: 'data-controller-element',
    DATA_FIELD_NAME: 'data-field-name',
    OBJECT_TYPE: 'FieloPRP__InvoiceItem__c'

  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloInvoiceItems.prototype.CssClasses_ = {
    ITEM: 'fielosf-invoice__item',
    CONTAINER: 'fielosf-invoice__container',
    DELETE: 'slds-button--delete',
    NEW: 'slds-button--new',
    FORM_ELEMENT: 'slds-form-element',
    PRODUCT_QTY: 'fielosf-product_qty',
    PRODUCT_UNIT_PRICE: 'fielosf-product_unit-price',
    PRODUCT_TOTAL_PRICE: 'fielosf-product_total-price',
    PRODUCT_NAME: 'fielosf-product_name',
    PILL_REMOVE: 'slds-pill__remove'

  };

  FieloInvoiceItems.prototype.initItem_ = function(invoiceItem) {
    invoiceItem.deleteBtn_ =
      invoiceItem.getElementsByClassName(this.CssClasses_.DELETE)[0];
    invoiceItem.deleteBtn_.addEventListener(
      'click',
      this.deleteItem_.bind(this, invoiceItem)
    );
  };

  FieloInvoiceItems.prototype.refreshTotalPrice_ = function() {
    var invoiceItems =
        this.element_.getElementsByClassName(this.CssClasses_.ITEM);
    var redemptionFormLst = $(this.element_).closest(
        '.fielosf-invoice-form');
    if (redemptionFormLst.length > 0) {
      var redemptionForm = redemptionFormLst[0].FieloFormRedemption;
      redemptionForm.refreshPoints(invoiceItems[0]);
    }
  };

  FieloInvoiceItems.prototype.deleteItem_ = function(invoiceItem) {
    if (this.invoiceItems_.length > 1) {
      invoiceItem.remove();
      this.refreshTotalPrice_();
    }
  };

  FieloInvoiceItems.prototype.newinvoiceItem_ = function() {
    var invoiceItem = this.model_.cloneNode(true);
    this.container_.appendChild(invoiceItem);
    [].forEach.call(
      invoiceItem.querySelectorAll('[' + this.Constant_.DATA_UPGRADED + ']'),
      function(element, position) {
        element.removeAttribute(this.Constant_.DATA_UPGRADED);
        element.id = String(element.id + '-' + this.invoiceItems_.length);
        var dataController = element
          .getAttribute(this.Constant_.DATA_CONTROLLER) || null;
        if (dataController && position !== 0) {
          element.setAttribute(
            this.Constant_.DATA_CONTROLLER,
            String(dataController + '-' + this.invoiceItems_.length)
          );
        }
        componentHandler.upgradeElement(element);
      },
        this
    );
    this.initItem_(invoiceItem);
  };

  /**
   *
   * Getter y Setters
   *
   */

  /**
   * Retorna la lista de items
   * @return {Array | Object} - Lista de objetos (sObjects)
   */
  FieloInvoiceItems.prototype.get = function() {
    var sObjectList = [];
    [].forEach.call(this.invoiceItems_, function(item) {
      var sObject = {};
      [].forEach.call(item.getElementsByClassName(this
          .CssClasses_.FORM_ELEMENT), function(element) {
        var sObjectValue = element.FieloFormElement.get('value');
        sObject[element.getAttribute(this.Constant_.DATA_FIELD_NAME)] =
            sObjectValue;
      }, this);
      sObjectList.push(sObject);
    }, this);
    // sObjectList.sObjectType = this.Constant_.OBJECT_TYPE;
    return sObjectList;
  };

  FieloInvoiceItems.prototype.set = function() {
    return console.log('recibe lista de objetos');
  };

  FieloInvoiceItems.prototype.clear = function() {
    var items = this.element_.getElementsByClassName(this.CssClasses_.DELETE);
    while (items.length > 1) {
      items[0].click();
    }
    // Ver de mejorar esta parte, ahora alcanza para que ande el clean
    this.element_.querySelector('.' + this.CssClasses_.PRODUCT_QTY + ' .' +
      this.CssClasses_.FORM_ELEMENT).FieloFormElement.set('value', 1);

    this.element_.querySelector('.' + this.CssClasses_.PRODUCT_NAME + ' .' +
      this.CssClasses_.FORM_ELEMENT).FieloFormElement.clear();

    this.element_.querySelector('.' +
      this.CssClasses_.PRODUCT_TOTAL_PRICE + ' .' +
        this.CssClasses_.FORM_ELEMENT).FieloFormElement.set('value', null);
  };

  /**
   * Inicializa el elemento
   */
  FieloInvoiceItems.prototype.init = function() {
    if (this.element_) {
      this.container_ =
        this.element_.getElementsByClassName(this.CssClasses_.CONTAINER)[0];
      this.invoiceItems_ =
        this.element_.getElementsByClassName(this.CssClasses_.ITEM);
      this.model_ = this.invoiceItems_[0].cloneNode(true);
      this.newBtn_ =
        this.element_.getElementsByClassName(this.CssClasses_.NEW)[0];
      if (this.newBtn_) {
        this.newBtn_
          .addEventListener('click', this.newinvoiceItem_.bind(this));
      }
      [].forEach.call(this.invoiceItems_, this.initItem_.bind(this));
    }
  };

  fielo.util.register({
    constructor: FieloInvoiceItems,
    classAsString: 'FieloInvoiceItems',
    cssClass: 'fielosf-invoice-items',
    widget: true
  });
})();

