CKEDITOR.plugins.add( 'codetag', {
	init: function( editor ) {
    editor.addCommand('codetagDialog', new CKEDITOR.dialogCommand('codetagDialog'));
    
    editor.ui.addButton('codetag', {
      label: 'Insert Code',
      command: 'codetagDialog',
      icon: this.path + 'images/icon.png'
    });
    
    CKEDITOR.dialog.add('codetagDialog', function(editor) {
      return {
        title: 'Insert Code',
        minWidth: 400,
        minHeight: 200,
        contents: [
          {
            id: 'codetag',
            label: 'Insert Code',
            elements: [
              {
                type: 'select',
                id: 'language',
                label: 'Language',
                items: parent._.map(parent.Syntax.brushNames(), function(i) { return [i, i]; }),
                commit : function( data ) { data.language = this.getValue(); }//,
                // IE7 and 8 think 'default' is a reserved word. Ugh.
                //default: 'plain'
              },
              {
                type: 'textarea',
                id: 'sourcecode',
                label: 'Code',
                required: true,
                commit : function( data ) {
                  // make sure to do HTML escaping!!!!
                  // IE does some strange things with all of this
                  //data.sourcecode = parent._.escape(this.getValue());
                  data.sourcecode = parent._.map(this.getValue().split("\n"), function(i) { return parent._.escape(i); }).join("\n");
                }
              }
            ]
          }
        ],
        onOk: function() {
          var dialog = this;
          var data = {};
          this.commitContent(data);
          var pre = editor.document.createElement('pre');
          pre.setAttribute('class', 'syntax ' + data.language);
          pre.setHtml(data.sourcecode);
          editor.insertElement(pre);
        }
      }
    });
	}
});
