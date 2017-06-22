(function() {
  'use strict';

  /**
   * @description Controlador para el formulario FieloProgramSelectorPRP.
   * Permite el envío del formulario
   * Implementa los patrones de diseño definidos por MDL en
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Elemento que será mejorado.
   * @constructor
   */
  var FieloProgramSelectorPRP = function FieloProgramSelectorPRP(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloProgramSelectorPRP = FieloProgramSelectorPRP;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloProgramSelectorPRP.prototype.Constant_ = {
    PROGRAM: 'FieloPRP__Program__c'
  };

  /**
   * Guarda strings para nombres de clases definidas por este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloProgramSelectorPRP.prototype.CssClasses_ = {
    PAGINATOR: 'fielosf-paginator'
  };

  FieloProgramSelectorPRP.prototype.onChange = function() {
    var filter = {};
    this.getProgramId_();
    [].forEach.call(this.programActions_, function(action) {
      action.FieloButton.setParameter(this.Constant_.PROGRAM, this.programId_);
    }, this);

    filter[this.field_] = this.programId_;

    try {
      Visualforce.remoting.Manager.invokeAction(
        'FieloPRP.BackEndProgramSelectorController.selectProgram',
        filter[this.field_],
        function() {},
        {escape: false}
      );
    } catch (e) {
      // Ya está todo listo. Oculto el spinner
      console.log(e);
      fielo.util.spinner.FieloSpinner.hide();
    }

    // disparo los paginadores
    [].forEach.call(this.listOfPaginators_, function(paginator) {
      // Seteo el paginador
      if ($(paginator).is(':visible')) {
        paginator.FieloPaginator.setFilters(filter);
        paginator.FieloPaginator.setPage();
        paginator.FieloPaginator.getRecords();
      }
    }, this);

    this.callback();
  };

  /**
   * Guarda el programId
   */
  FieloProgramSelectorPRP.prototype.getProgramId_ = function() {
    this.programId_ = this.element_.FieloFormElement.get('value');
  };

  /**
   * Inicializa el elemento
   */
  FieloProgramSelectorPRP.prototype.init = function() {
    if (this.element_) {
      componentHandler.upgradeElement(this.element_);
      window.fieloProgramSelectorPRP = this.onChange.bind(this);
      this.field_ = 'FieloPRP__Member__r.FieloPLT__Program__c';
      this.getProgramId_();
      // para evitar el undefined
      this.callback = function() {};

      // Registro los paginadores de este filtro
      this.listOfPaginators_ =
        document.getElementsByClassName(this.CssClasses_.PAGINATOR);

      // Registro los input hidden dependientes del program
      this.programActions_ = document.querySelectorAll(
        '.slds-button[data-parameters*="' + this.Constant_.PROGRAM + '"]'
      );
    }
  };

  componentHandler.register({
    constructor: FieloProgramSelectorPRP,
    classAsString: 'FieloProgramSelectorPRP',
    cssClass: 'fielosf-program-selector-prp',
    widget: true
  });
})();
