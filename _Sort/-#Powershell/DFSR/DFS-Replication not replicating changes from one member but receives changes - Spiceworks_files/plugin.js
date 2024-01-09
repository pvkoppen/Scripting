(function(){
  var name = "pre";
  CKEDITOR.plugins.add(name, {
    init: function(editor) {
      editor.addCommand(name, {
        exec:function(editor){
          var style = new CKEDITOR.style({element : "pre"});
          style.apply(editor.document);
        }
      });
      editor.ui.addButton(name, {
        label: name,
        icon: this.path + "bt_pre.png",
        command: name
      });
    }
  });
})();
