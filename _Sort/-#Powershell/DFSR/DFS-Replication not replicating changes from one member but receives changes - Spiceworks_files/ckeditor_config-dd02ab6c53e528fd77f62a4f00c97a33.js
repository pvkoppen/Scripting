// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html
CKEDITOR.editorConfig = function(config){
  config.bodyClass = 'rich_text_editor';
  config.docType = '<!DOCTYPE html>';
  var commonOptions = ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink', '-', 'Undo', 'Redo', 'pre', 'codetag'];
  var advancedOptions = ['Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyFull', '-', 'Image', '-', 'Source'];
  config.toolbar_Basic = [ commonOptions ];
  config.toolbar_Full = [ commonOptions, '/', advancedOptions ];
  config.toolbarCanCollapse = false;
  config.disableObjectResizing = true;
  config.disableNativeSpellChecker = false;
  config.pasteFromWordPromptCleanup = true;
  config.pasteFromWordRemoveStyles = true;
  config.forcePasteAsPlainText = true;
  config.skin = 'spiceworks,/assets/ckskins/spiceworks/';
  // config.skin = 'spiceworks,/assets/ckskins/_source/spiceworks/'; // development version
  config.removePlugins = 'elementspath,scayt,menubutton,contextmenu';
  config.extraPlugins = 'pre,codetag';
};
