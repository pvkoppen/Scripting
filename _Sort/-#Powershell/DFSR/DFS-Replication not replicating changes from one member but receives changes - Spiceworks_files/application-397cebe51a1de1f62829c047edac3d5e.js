/**
*	@name							Elastic
*	@descripton						Elastic is jQuery plugin that grow and shrink your textareas automatically
*	@version						1.6.11
*	@requires						jQuery 1.2.6+
*
*	@author							Jan Jarfalk
*	@author-email					jan.jarfalk@unwrongest.com
*	@author-website					http://www.unwrongest.com
*
*	@licence						MIT License - http://www.opensource.org/licenses/mit-license.php
*/


(function($){ 
	jQuery.fn.extend({  
		elastic: function() {
		
			//	We will create a div clone of the textarea
			//	by copying these attributes from the textarea to the div.
			var mimics = [
				'paddingTop',
				'paddingRight',
				'paddingBottom',
				'paddingLeft',
				'fontSize',
				'lineHeight',
				'fontFamily',
				'width',
				'fontWeight',
				'border-top-width',
				'border-right-width',
				'border-bottom-width',
				'border-left-width',
				'borderTopStyle',
				'borderTopColor',
				'borderRightStyle',
				'borderRightColor',
				'borderBottomStyle',
				'borderBottomColor',
				'borderLeftStyle',
				'borderLeftColor'
				];
			
			return this.each( function() {

				// Elastic only works on textareas
				if ( this.type !== 'textarea' ) {
					return false;
				}
					
			var $textarea	= jQuery(this),
				$twin		= jQuery('<div />').css({
					'position'		: 'absolute',
					'display'		: 'none',
					'word-wrap'		: 'break-word',
					'white-space'	:'pre-wrap'
				}),
				lineHeight	= parseInt($textarea.css('line-height'),10) || parseInt($textarea.css('font-size'),'10'),
				minheight	= parseInt($textarea.css('height'),10) || lineHeight*3,
				maxheight	= parseInt($textarea.css('max-height'),10) || Number.MAX_VALUE,
				goalheight	= 0;
				
				// Opera returns max-height of -1 if not set
				if (maxheight < 0) { maxheight = Number.MAX_VALUE; }
					
				// Append the twin to the DOM
				// We are going to meassure the height of this, not the textarea.
				$twin.appendTo($textarea.parent());
				
				// Copy the essential styles (mimics) from the textarea to the twin
				var i = mimics.length;
				while(i--){
					$twin.css(mimics[i].toString(),$textarea.css(mimics[i].toString()));
				}
				
				// Updates the width of the twin. (solution for textareas with widths in percent)
				function setTwinWidth(){
					var curatedWidth = Math.floor(parseInt($textarea.width(),10));
					if($twin.width() !== curatedWidth){
						$twin.css({'width': curatedWidth + 'px'});
						
						// Update height of textarea
						update(true);
					}
				}
				
				// Sets a given height and overflow state on the textarea
				function setHeightAndOverflow(height, overflow){
				
					var curratedHeight = Math.floor(parseInt(height,10));
					if($textarea.height() !== curratedHeight){
						$textarea.css({'height': curratedHeight + 'px','overflow':overflow});
					}
				}
				
				// This function will update the height of the textarea if necessary 
				function update(forced) {
					
					// Get curated content from the textarea.
					var textareaContent = $textarea.val().replace(/&/g,'&amp;').replace(/ {2}/g, '&nbsp;').replace(/<|>/g, '&gt;').replace(/\n/g, '<br />');
					
					// Compare curated content with curated twin.
					var twinContent = $twin.html().replace(/<br>/ig,'<br />');
					
					if(forced || textareaContent+'&nbsp;' !== twinContent){
					
						// Add an extra white space so new rows are added when you are at the end of a row.
						$twin.html(textareaContent+'&nbsp;');
						
						// Change textarea height if twin plus the height of one line differs more than 3 pixel from textarea height
						if(Math.abs($twin.height() + lineHeight - $textarea.height()) > 3){
							
							var goalheight = $twin.height()+lineHeight;
							if(goalheight >= maxheight) {
								setHeightAndOverflow(maxheight,'auto');
							} else if(goalheight <= minheight) {
								setHeightAndOverflow(minheight,'hidden');
							} else {
								setHeightAndOverflow(goalheight,'hidden');
							}
							
						}
						
					}
					
				}
				
				// Hide scrollbars
				$textarea.css({'overflow':'hidden'});
				
				// Update textarea size on keyup, change, cut and paste
				$textarea.bind('keyup change cut paste', function(){
					update(); 
				});
				
				// Update width of twin if browser or textarea is resized (solution for textareas with widths in percent)
				$(window).bind('resize', setTwinWidth);
				$textarea.bind('resize', setTwinWidth);
				$textarea.bind('update', update);
				
				// Compact textarea on blur
				/*
				$textarea.bind('blur',function(){
					if($twin.height() < maxheight){
						if($twin.height() > minheight) {
							$textarea.height($twin.height());
						} else {
							$textarea.height(minheight);
						}
					}
				});
				*/
				
				// And this line is to catch the browser paste event
				$textarea.bind('input paste',function(e){ setTimeout( update, 250); });				
				
				// Run update once when elastic is initialized
				update();
				
			});
			
        } 
    }); 
})(jQuery);
(function($, undefined) {

/**
 * Unobtrusive scripting adapter for jQuery
 *
 * Requires jQuery 1.6.0 or later.
 * https://github.com/rails/jquery-ujs

 * Uploading file using rails.js
 * =============================
 *
 * By default, browsers do not allow files to be uploaded via AJAX. As a result, if there are any non-blank file fields
 * in the remote form, this adapter aborts the AJAX submission and allows the form to submit through standard means.
 *
 * The `ajax:aborted:file` event allows you to bind your own handler to process the form submission however you wish.
 *
 * Ex:
 *     $('form').live('ajax:aborted:file', function(event, elements){
 *       // Implement own remote file-transfer handler here for non-blank file inputs passed in `elements`.
 *       // Returning false in this handler tells rails.js to disallow standard form submission
 *       return false;
 *     });
 *
 * The `ajax:aborted:file` event is fired when a file-type input is detected with a non-blank value.
 *
 * Third-party tools can use this hook to detect when an AJAX file upload is attempted, and then use
 * techniques like the iframe method to upload the file instead.
 *
 * Required fields in rails.js
 * ===========================
 *
 * If any blank required inputs (required="required") are detected in the remote form, the whole form submission
 * is canceled. Note that this is unlike file inputs, which still allow standard (non-AJAX) form submission.
 *
 * The `ajax:aborted:required` event allows you to bind your own handler to inform the user of blank required inputs.
 *
 * !! Note that Opera does not fire the form's submit event if there are blank required inputs, so this event may never
 *    get fired in Opera. This event is what causes other browsers to exhibit the same submit-aborting behavior.
 *
 * Ex:
 *     $('form').live('ajax:aborted:required', function(event, elements){
 *       // Returning false in this handler tells rails.js to submit the form anyway.
 *       // The blank required inputs are passed to this function in `elements`.
 *       return ! confirm("Would you like to submit the form with missing info?");
 *     });
 */

  // Shorthand to make it a little easier to call public rails functions from within rails.js
  var rails;

  $.rails = rails = {
    // Link elements bound by jquery-ujs
    linkClickSelector: 'a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]',

    // Select elements bound by jquery-ujs
    inputChangeSelector: 'select[data-remote], input[data-remote], textarea[data-remote]',

    // Form elements bound by jquery-ujs
    formSubmitSelector: 'form',

    // Form input elements bound by jquery-ujs
    formInputClickSelector: 'form input[type=submit], form input[type=image], form button[type=submit], form button:not(button[type])',

    // Form input elements disabled during form submission
    disableSelector: 'input[data-disable-with], button[data-disable-with], textarea[data-disable-with]',

    // Form input elements re-enabled after form submission
    enableSelector: 'input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled',

    // Form required input elements
    requiredInputSelector: 'input[name][required]:not([disabled]),textarea[name][required]:not([disabled])',

    // Form file input elements
    fileInputSelector: 'input:file',

    // Link onClick disable selector with possible reenable after remote submission
    linkDisableSelector: 'a[data-disable-with]',

    // Make sure that every Ajax request sends the CSRF token
    CSRFProtection: function(xhr) {
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) xhr.setRequestHeader('X-CSRF-Token', token);
    },

    // Triggers an event on an element and returns false if the event result is false
    fire: function(obj, name, data) {
      var event = $.Event(name);
      obj.trigger(event, data);
      return event.result !== false;
    },

    // Default confirm dialog, may be overridden with custom confirm dialog in $.rails.confirm
    confirm: function(message) {
      return confirm(message);
    },

    // Default ajax function, may be overridden with custom function in $.rails.ajax
    ajax: function(options) {
      return $.ajax(options);
    },

    // Default way to get an element's href. May be overridden at $.rails.href.
    href: function(element) {
      return element.attr('href');
    },

    // Submits "remote" forms and links with ajax
    handleRemote: function(element) {
      var method, url, data, crossDomain, dataType, options;

      if (rails.fire(element, 'ajax:before')) {
        crossDomain = element.data('cross-domain') || null;
        dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType);

        if (element.is('form')) {
          method = element.attr('method');
          url = element.attr('action');
          data = element.serializeArray();
          // memoized value from clicked submit button
          var button = element.data('ujs:submit-button');
          if (button) {
            data.push(button);
            element.data('ujs:submit-button', null);
          }
        } else if (element.is(rails.inputChangeSelector)) {
          method = element.data('method');
          url = element.data('url');
          data = element.serialize();
          if (element.data('params')) data = data + "&" + element.data('params');
        } else {
          method = element.data('method');
          url = rails.href(element);
          data = element.data('params') || null;
        }

        options = {
          type: method || 'GET', data: data, dataType: dataType, crossDomain: crossDomain,
          // stopping the "ajax:beforeSend" event will cancel the ajax request
          beforeSend: function(xhr, settings) {
            if (settings.dataType === undefined) {
              xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            }
            return rails.fire(element, 'ajax:beforeSend', [xhr, settings]);
          },
          success: function(data, status, xhr) {
            element.trigger('ajax:success', [data, status, xhr]);
          },
          complete: function(xhr, status) {
            element.trigger('ajax:complete', [xhr, status]);
          },
          error: function(xhr, status, error) {
            element.trigger('ajax:error', [xhr, status, error]);
          }
        };
        // Only pass url to `ajax` options if not blank
        if (url) { options.url = url; }

        return rails.ajax(options);
      } else {
        return false;
      }
    },

    // Handles "data-method" on links such as:
    // <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
    handleMethod: function(link) {
      var href = rails.href(link),
        method = link.data('method'),
        target = link.attr('target'),
        csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content'),
        form = $('<form method="post" action="' + href + '"></form>'),
        metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

      if (csrf_param !== undefined && csrf_token !== undefined) {
        metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
      }

      if (target) { form.attr('target', target); }

      form.hide().append(metadata_input).appendTo('body');
      form.submit();
    },

    /* Disables form elements:
      - Caches element value in 'ujs:enable-with' data store
      - Replaces element text with value of 'data-disable-with' attribute
      - Sets disabled property to true
    */
    disableFormElements: function(form) {
      form.find(rails.disableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        element.data('ujs:enable-with', element[method]());
        element[method](element.data('disable-with'));
        element.prop('disabled', true);
      });
    },

    /* Re-enables disabled form elements:
      - Replaces element text with cached value from 'ujs:enable-with' data store (created in `disableFormElements`)
      - Sets disabled property to false
    */
    enableFormElements: function(form) {
      form.find(rails.enableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        if (element.data('ujs:enable-with')) element[method](element.data('ujs:enable-with'));
        element.prop('disabled', false);
      });
    },

   /* For 'data-confirm' attribute:
      - Fires `confirm` event
      - Shows the confirmation dialog
      - Fires the `confirm:complete` event

      Returns `true` if no function stops the chain and user chose yes; `false` otherwise.
      Attaching a handler to the element's `confirm` event that returns a `falsy` value cancels the confirmation dialog.
      Attaching a handler to the element's `confirm:complete` event that returns a `falsy` value makes this function
      return false. The `confirm:complete` event is fired whether or not the user answered true or false to the dialog.
   */
    allowAction: function(element) {
      var message = element.data('confirm'),
          answer = false, callback;
      if (!message) { return true; }

      if (rails.fire(element, 'confirm')) {
        answer = rails.confirm(message);
        callback = rails.fire(element, 'confirm:complete', [answer]);
      }
      return answer && callback;
    },

    // Helper function which checks for blank inputs in a form that match the specified CSS selector
    blankInputs: function(form, specifiedSelector, nonBlank) {
      var inputs = $(), input,
        selector = specifiedSelector || 'input,textarea';
      form.find(selector).each(function() {
        input = $(this);
        // Collect non-blank inputs if nonBlank option is true, otherwise, collect blank inputs
        if (nonBlank ? input.val() : !input.val()) {
          inputs = inputs.add(input);
        }
      });
      return inputs.length ? inputs : false;
    },

    // Helper function which checks for non-blank inputs in a form that match the specified CSS selector
    nonBlankInputs: function(form, specifiedSelector) {
      return rails.blankInputs(form, specifiedSelector, true); // true specifies nonBlank
    },

    // Helper function, needed to provide consistent behavior in IE
    stopEverything: function(e) {
      $(e.target).trigger('ujs:everythingStopped');
      e.stopImmediatePropagation();
      return false;
    },

    // find all the submit events directly bound to the form and
    // manually invoke them. If anyone returns false then stop the loop
    callFormSubmitBindings: function(form, event) {
      var events = form.data('events'), continuePropagation = true;
      if (events !== undefined && events['submit'] !== undefined) {
        $.each(events['submit'], function(i, obj){
          if (typeof obj.handler === 'function') return continuePropagation = obj.handler(event);
        });
      }
      return continuePropagation;
    },

    //  replace element's html with the 'data-disable-with' after storing original html
    //  and prevent clicking on it
    disableElement: function(element) {
      element.data('ujs:enable-with', element.html()); // store enabled state
      element.html(element.data('disable-with')); // set to disabled state
      element.bind('click.railsDisable', function(e) { // prevent further clicking
        return rails.stopEverything(e)
      });
    },

    // restore element to its original state which was disabled by 'disableElement' above
    enableElement: function(element) {
      if (element.data('ujs:enable-with') !== undefined) {
        element.html(element.data('ujs:enable-with')); // set to old enabled state
        // this should be element.removeData('ujs:enable-with')
        // but, there is currently a bug in jquery which makes hyphenated data attributes not get removed
        element.data('ujs:enable-with', false); // clean up cache
      }
      element.unbind('click.railsDisable'); // enable element
    }

  };

  $.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { rails.CSRFProtection(xhr); }});

  $(document).delegate(rails.linkDisableSelector, 'ajax:complete', function() {
      rails.enableElement($(this));
  });

  $(document).delegate(rails.linkClickSelector, 'click.rails', function(e) {
    var link = $(this), method = link.data('method'), data = link.data('params');
    if (!rails.allowAction(link)) return rails.stopEverything(e);

    if (link.is(rails.linkDisableSelector)) rails.disableElement(link);

    if (link.data('remote') !== undefined) {
      if ( (e.metaKey || e.ctrlKey) && (!method || method === 'GET') && !data ) { return true; }

      if (rails.handleRemote(link) === false) { rails.enableElement(link); }
      return false;

    } else if (link.data('method')) {
      rails.handleMethod(link);
      return false;
    }
  });

  $(document).delegate(rails.inputChangeSelector, 'change.rails', function(e) {
    var link = $(this);
    if (!rails.allowAction(link)) return rails.stopEverything(e);

    rails.handleRemote(link);
    return false;
  });

  $(document).delegate(rails.formSubmitSelector, 'submit.rails', function(e) {
    var form = $(this),
      remote = form.data('remote') !== undefined,
      blankRequiredInputs = rails.blankInputs(form, rails.requiredInputSelector),
      nonBlankFileInputs = rails.nonBlankInputs(form, rails.fileInputSelector);

    if (!rails.allowAction(form)) return rails.stopEverything(e);

    // skip other logic when required values are missing or file upload is present
    if (blankRequiredInputs && form.attr("novalidate") == undefined && rails.fire(form, 'ajax:aborted:required', [blankRequiredInputs])) {
      return rails.stopEverything(e);
    }

    if (remote) {
      if (nonBlankFileInputs) {
        return rails.fire(form, 'ajax:aborted:file', [nonBlankFileInputs]);
      }

      // If browser does not support submit bubbling, then this live-binding will be called before direct
      // bindings. Therefore, we should directly call any direct bindings before remotely submitting form.
      if (!$.support.submitBubbles && $().jquery < '1.7' && rails.callFormSubmitBindings(form, e) === false) return rails.stopEverything(e);

      rails.handleRemote(form);
      return false;

    } else {
      // slight timeout so that the submit button gets properly serialized
      setTimeout(function(){ rails.disableFormElements(form); }, 13);
    }
  });

  $(document).delegate(rails.formInputClickSelector, 'click.rails', function(event) {
    var button = $(this);

    if (!rails.allowAction(button)) return rails.stopEverything(event);

    // register the pressed submit button
    var name = button.attr('name'),
      data = name ? {name:name, value:button.val()} : null;

    button.closest('form').data('ujs:submit-button', data);
  });

  $(document).delegate(rails.formSubmitSelector, 'ajax:beforeSend.rails', function(event) {
    if (this == event.target) rails.disableFormElements($(this));
  });

  $(document).delegate(rails.formSubmitSelector, 'ajax:complete.rails', function(event) {
    if (this == event.target) rails.enableFormElements($(this));
  });

  $(function(){
    // making sure that all forms have actual up-to-date token(cached forms contain old one)
    csrf_token = $('meta[name=csrf-token]').attr('content');
    csrf_param = $('meta[name=csrf-param]').attr('content');
    $('form input[name="' + csrf_param + '"]').val(csrf_token);
  });

})( jQuery );
(function($){
  $.extend({
    determine: function(val){
      // for config options that can be a value (e.g. 1, 'bob')
      //   --OR-- a function that returns the value (e.g. function(){return $('$id').value;})
      return $.isFunction(val) ? val() : val;
    }
  });
})(jQuery);
(function(){
  _.mixin({
    capitalize: function(string) {
      return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();
    },
    titleize: function(string) {
      var val = string.split(/(?=[\_])/);
      val = _.map(val, function(p) {
        p = p.replace('_', '');
        return p.charAt(0).toUpperCase() + p.slice(1);
      }).join('');
      val = val.split(/(?=[A-Z])/);
      return _.map(val, function(p) {
        return p.charAt(0).toUpperCase() + p.slice(1);
      }).join(' ');
    }
  });
})();
// script.aculo.us effects.js v1.8.3, Thu Oct 08 11:23:33 +0200 2009

// Copyright (c) 2005-2009 Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)
// Contributors:
//  Justin Palmer (http://encytemedia.com/)
//  Mark Pilgrim (http://diveintomark.org/)
//  Martin Bialasinki
//
// script.aculo.us is freely distributable under the terms of an MIT-style license.
// For details, see the script.aculo.us web site: http://script.aculo.us/

// converts rgb() and #xxx to #xxxxxx format,
// returns self (or first argument) if not convertable
String.prototype.parseColor = function() {
  var color = '#';
  if (this.slice(0,4) == 'rgb(') {
    var cols = this.slice(4,this.length-1).split(',');
    var i=0; do { color += parseInt(cols[i]).toColorPart() } while (++i<3);
  } else {
    if (this.slice(0,1) == '#') {
      if (this.length==4) for(var i=1;i<4;i++) color += (this.charAt(i) + this.charAt(i)).toLowerCase();
      if (this.length==7) color = this.toLowerCase();
    }
  }
  return (color.length==7 ? color : (arguments[0] || this));
};

/*--------------------------------------------------------------------------*/

Element.collectTextNodes = function(element) {
  return $A($(element).childNodes).collect( function(node) {
    return (node.nodeType==3 ? node.nodeValue :
      (node.hasChildNodes() ? Element.collectTextNodes(node) : ''));
  }).flatten().join('');
};

Element.collectTextNodesIgnoreClass = function(element, className) {
  return $A($(element).childNodes).collect( function(node) {
    return (node.nodeType==3 ? node.nodeValue :
      ((node.hasChildNodes() && !Element.hasClassName(node,className)) ?
        Element.collectTextNodesIgnoreClass(node, className) : ''));
  }).flatten().join('');
};

Element.setContentZoom = function(element, percent) {
  element = $(element);
  element.setStyle({fontSize: (percent/100) + 'em'});
  if (Prototype.Browser.WebKit) window.scrollBy(0,0);
  return element;
};

Element.getInlineOpacity = function(element){
  return $(element).style.opacity || '';
};

Element.forceRerendering = function(element) {
  try {
    element = $(element);
    var n = document.createTextNode(' ');
    element.appendChild(n);
    element.removeChild(n);
  } catch(e) { }
};

/*--------------------------------------------------------------------------*/

var Effect = {
  _elementDoesNotExistError: {
    name: 'ElementDoesNotExistError',
    message: 'The specified DOM element does not exist, but is required for this effect to operate'
  },
  Transitions: {
    linear: Prototype.K,
    sinoidal: function(pos) {
      return (-Math.cos(pos*Math.PI)/2) + .5;
    },
    reverse: function(pos) {
      return 1-pos;
    },
    flicker: function(pos) {
      var pos = ((-Math.cos(pos*Math.PI)/4) + .75) + Math.random()/4;
      return pos > 1 ? 1 : pos;
    },
    wobble: function(pos) {
      return (-Math.cos(pos*Math.PI*(9*pos))/2) + .5;
    },
    pulse: function(pos, pulses) {
      return (-Math.cos((pos*((pulses||5)-.5)*2)*Math.PI)/2) + .5;
    },
    spring: function(pos) {
      return 1 - (Math.cos(pos * 4.5 * Math.PI) * Math.exp(-pos * 6));
    },
    none: function(pos) {
      return 0;
    },
    full: function(pos) {
      return 1;
    }
  },
  DefaultOptions: {
    duration:   1.0,   // seconds
    fps:        100,   // 100= assume 66fps max.
    sync:       false, // true for combining
    from:       0.0,
    to:         1.0,
    delay:      0.0,
    queue:      'parallel'
  },
  tagifyText: function(element) {
    var tagifyStyle = 'position:relative';
    if (Prototype.Browser.IE) tagifyStyle += ';zoom:1';

    element = $(element);
    $A(element.childNodes).each( function(child) {
      if (child.nodeType==3) {
        child.nodeValue.toArray().each( function(character) {
          element.insertBefore(
            new Element('span', {style: tagifyStyle}).update(
              character == ' ' ? String.fromCharCode(160) : character),
              child);
        });
        Element.remove(child);
      }
    });
  },
  multiple: function(element, effect) {
    var elements;
    if (((typeof element == 'object') ||
        Object.isFunction(element)) &&
       (element.length))
      elements = element;
    else
      elements = $(element).childNodes;

    var options = Object.extend({
      speed: 0.1,
      delay: 0.0
    }, arguments[2] || { });
    var masterDelay = options.delay;

    $A(elements).each( function(element, index) {
      new effect(element, Object.extend(options, { delay: index * options.speed + masterDelay }));
    });
  },
  PAIRS: {
    'slide':  ['SlideDown','SlideUp'],
    'blind':  ['BlindDown','BlindUp'],
    'appear': ['Appear','Fade']
  },
  toggle: function(element, effect, options) {
    element = $(element);
    effect  = (effect || 'appear').toLowerCase();

    return Effect[ Effect.PAIRS[ effect ][ element.visible() ? 1 : 0 ] ](element, Object.extend({
      queue: { position:'end', scope:(element.id || 'global'), limit: 1 }
    }, options || {}));
  }
};

Effect.DefaultOptions.transition = Effect.Transitions.sinoidal;

/* ------------- core effects ------------- */

Effect.ScopedQueue = Class.create(Enumerable, {
  initialize: function() {
    this.effects  = [];
    this.interval = null;
  },
  _each: function(iterator) {
    this.effects._each(iterator);
  },
  add: function(effect) {
    var timestamp = new Date().getTime();

    var position = Object.isString(effect.options.queue) ?
      effect.options.queue : effect.options.queue.position;

    switch(position) {
      case 'front':
        // move unstarted effects after this effect
        this.effects.findAll(function(e){ return e.state=='idle' }).each( function(e) {
            e.startOn  += effect.finishOn;
            e.finishOn += effect.finishOn;
          });
        break;
      case 'with-last':
        timestamp = this.effects.pluck('startOn').max() || timestamp;
        break;
      case 'end':
        // start effect after last queued effect has finished
        timestamp = this.effects.pluck('finishOn').max() || timestamp;
        break;
    }

    effect.startOn  += timestamp;
    effect.finishOn += timestamp;

    if (!effect.options.queue.limit || (this.effects.length < effect.options.queue.limit))
      this.effects.push(effect);

    if (!this.interval)
      this.interval = setInterval(this.loop.bind(this), 15);
  },
  remove: function(effect) {
    this.effects = this.effects.reject(function(e) { return e==effect });
    if (this.effects.length == 0) {
      clearInterval(this.interval);
      this.interval = null;
    }
  },
  loop: function() {
    var timePos = new Date().getTime();
    for(var i=0, len=this.effects.length;i<len;i++)
      this.effects[i] && this.effects[i].loop(timePos);
  }
});

Effect.Queues = {
  instances: $H(),
  get: function(queueName) {
    if (!Object.isString(queueName)) return queueName;

    return this.instances.get(queueName) ||
      this.instances.set(queueName, new Effect.ScopedQueue());
  }
};
Effect.Queue = Effect.Queues.get('global');

Effect.Base = Class.create({
  position: null,
  start: function(options) {
    if (options && options.transition === false) options.transition = Effect.Transitions.linear;
    this.options      = Object.extend(Object.extend({ },Effect.DefaultOptions), options || { });
    this.currentFrame = 0;
    this.state        = 'idle';
    this.startOn      = this.options.delay*1000;
    this.finishOn     = this.startOn+(this.options.duration*1000);
    this.fromToDelta  = this.options.to-this.options.from;
    this.totalTime    = this.finishOn-this.startOn;
    this.totalFrames  = this.options.fps*this.options.duration;

    this.render = (function() {
      function dispatch(effect, eventName) {
        if (effect.options[eventName + 'Internal'])
          effect.options[eventName + 'Internal'](effect);
        if (effect.options[eventName])
          effect.options[eventName](effect);
      }

      return function(pos) {
        if (this.state === "idle") {
          this.state = "running";
          dispatch(this, 'beforeSetup');
          if (this.setup) this.setup();
          dispatch(this, 'afterSetup');
        }
        if (this.state === "running") {
          pos = (this.options.transition(pos) * this.fromToDelta) + this.options.from;
          this.position = pos;
          dispatch(this, 'beforeUpdate');
          if (this.update) this.update(pos);
          dispatch(this, 'afterUpdate');
        }
      };
    })();

    this.event('beforeStart');
    if (!this.options.sync)
      Effect.Queues.get(Object.isString(this.options.queue) ?
        'global' : this.options.queue.scope).add(this);
  },
  loop: function(timePos) {
    if (timePos >= this.startOn) {
      if (timePos >= this.finishOn) {
        this.render(1.0);
        this.cancel();
        this.event('beforeFinish');
        if (this.finish) this.finish();
        this.event('afterFinish');
        return;
      }
      var pos   = (timePos - this.startOn) / this.totalTime,
          frame = (pos * this.totalFrames).round();
      if (frame > this.currentFrame) {
        this.render(pos);
        this.currentFrame = frame;
      }
    }
  },
  cancel: function() {
    if (!this.options.sync)
      Effect.Queues.get(Object.isString(this.options.queue) ?
        'global' : this.options.queue.scope).remove(this);
    this.state = 'finished';
  },
  event: function(eventName) {
    if (this.options[eventName + 'Internal']) this.options[eventName + 'Internal'](this);
    if (this.options[eventName]) this.options[eventName](this);
  },
  inspect: function() {
    var data = $H();
    for(property in this)
      if (!Object.isFunction(this[property])) data.set(property, this[property]);
    return '#<Effect:' + data.inspect() + ',options:' + $H(this.options).inspect() + '>';
  }
});

Effect.Parallel = Class.create(Effect.Base, {
  initialize: function(effects) {
    this.effects = effects || [];
    this.start(arguments[1]);
  },
  update: function(position) {
    this.effects.invoke('render', position);
  },
  finish: function(position) {
    this.effects.each( function(effect) {
      effect.render(1.0);
      effect.cancel();
      effect.event('beforeFinish');
      if (effect.finish) effect.finish(position);
      effect.event('afterFinish');
    });
  }
});

Effect.Tween = Class.create(Effect.Base, {
  initialize: function(object, from, to) {
    object = Object.isString(object) ? $(object) : object;
    var args = $A(arguments), method = args.last(),
      options = args.length == 5 ? args[3] : null;
    this.method = Object.isFunction(method) ? method.bind(object) :
      Object.isFunction(object[method]) ? object[method].bind(object) :
      function(value) { object[method] = value };
    this.start(Object.extend({ from: from, to: to }, options || { }));
  },
  update: function(position) {
    this.method(position);
  }
});

Effect.Event = Class.create(Effect.Base, {
  initialize: function() {
    this.start(Object.extend({ duration: 0 }, arguments[0] || { }));
  },
  update: Prototype.emptyFunction
});

Effect.Opacity = Class.create(Effect.Base, {
  initialize: function(element) {
    this.element = $(element);
    if (!this.element) throw(Effect._elementDoesNotExistError);
    // make this work on IE on elements without 'layout'
    if (Prototype.Browser.IE && (!this.element.currentStyle.hasLayout))
      this.element.setStyle({zoom: 1});
    var options = Object.extend({
      from: this.element.getOpacity() || 0.0,
      to:   1.0
    }, arguments[1] || { });
    this.start(options);
  },
  update: function(position) {
    this.element.setOpacity(position);
  }
});

Effect.Move = Class.create(Effect.Base, {
  initialize: function(element) {
    this.element = $(element);
    if (!this.element) throw(Effect._elementDoesNotExistError);
    var options = Object.extend({
      x:    0,
      y:    0,
      mode: 'relative'
    }, arguments[1] || { });
    this.start(options);
  },
  setup: function() {
    this.element.makePositioned();
    this.originalLeft = parseFloat(this.element.getStyle('left') || '0');
    this.originalTop  = parseFloat(this.element.getStyle('top')  || '0');
    if (this.options.mode == 'absolute') {
      this.options.x = this.options.x - this.originalLeft;
      this.options.y = this.options.y - this.originalTop;
    }
  },
  update: function(position) {
    this.element.setStyle({
      left: (this.options.x  * position + this.originalLeft).round() + 'px',
      top:  (this.options.y  * position + this.originalTop).round()  + 'px'
    });
  }
});

// for backwards compatibility
Effect.MoveBy = function(element, toTop, toLeft) {
  return new Effect.Move(element,
    Object.extend({ x: toLeft, y: toTop }, arguments[3] || { }));
};

Effect.Scale = Class.create(Effect.Base, {
  initialize: function(element, percent) {
    this.element = $(element);
    if (!this.element) throw(Effect._elementDoesNotExistError);
    var options = Object.extend({
      scaleX: true,
      scaleY: true,
      scaleContent: true,
      scaleFromCenter: false,
      scaleMode: 'box',        // 'box' or 'contents' or { } with provided values
      scaleFrom: 100.0,
      scaleTo:   percent
    }, arguments[2] || { });
    this.start(options);
  },
  setup: function() {
    this.restoreAfterFinish = this.options.restoreAfterFinish || false;
    this.elementPositioning = this.element.getStyle('position');

    this.originalStyle = { };
    ['top','left','width','height','fontSize'].each( function(k) {
      this.originalStyle[k] = this.element.style[k];
    }.bind(this));

    this.originalTop  = this.element.offsetTop;
    this.originalLeft = this.element.offsetLeft;

    var fontSize = this.element.getStyle('font-size') || '100%';
    ['em','px','%','pt'].each( function(fontSizeType) {
      if (fontSize.indexOf(fontSizeType)>0) {
        this.fontSize     = parseFloat(fontSize);
        this.fontSizeType = fontSizeType;
      }
    }.bind(this));

    this.factor = (this.options.scaleTo - this.options.scaleFrom)/100;

    this.dims = null;
    if (this.options.scaleMode=='box')
      this.dims = [this.element.offsetHeight, this.element.offsetWidth];
    if (/^content/.test(this.options.scaleMode))
      this.dims = [this.element.scrollHeight, this.element.scrollWidth];
    if (!this.dims)
      this.dims = [this.options.scaleMode.originalHeight,
                   this.options.scaleMode.originalWidth];
  },
  update: function(position) {
    var currentScale = (this.options.scaleFrom/100.0) + (this.factor * position);
    if (this.options.scaleContent && this.fontSize)
      this.element.setStyle({fontSize: this.fontSize * currentScale + this.fontSizeType });
    this.setDimensions(this.dims[0] * currentScale, this.dims[1] * currentScale);
  },
  finish: function(position) {
    if (this.restoreAfterFinish) this.element.setStyle(this.originalStyle);
  },
  setDimensions: function(height, width) {
    var d = { };
    if (this.options.scaleX) d.width = width.round() + 'px';
    if (this.options.scaleY) d.height = height.round() + 'px';
    if (this.options.scaleFromCenter) {
      var topd  = (height - this.dims[0])/2;
      var leftd = (width  - this.dims[1])/2;
      if (this.elementPositioning == 'absolute') {
        if (this.options.scaleY) d.top = this.originalTop-topd + 'px';
        if (this.options.scaleX) d.left = this.originalLeft-leftd + 'px';
      } else {
        if (this.options.scaleY) d.top = -topd + 'px';
        if (this.options.scaleX) d.left = -leftd + 'px';
      }
    }
    this.element.setStyle(d);
  }
});

Effect.Highlight = Class.create(Effect.Base, {
  initialize: function(element) {
    this.element = $(element);
    if (!this.element) throw(Effect._elementDoesNotExistError);
    var options = Object.extend({ startcolor: '#ffff99' }, arguments[1] || { });
    this.start(options);
  },
  setup: function() {
    // Prevent executing on elements not in the layout flow
    if (this.element.getStyle('display')=='none') { this.cancel(); return; }
    // Disable background image during the effect
    this.oldStyle = { };
    if (!this.options.keepBackgroundImage) {
      this.oldStyle.backgroundImage = this.element.getStyle('background-image');
      this.element.setStyle({backgroundImage: 'none'});
    }
    if (!this.options.endcolor)
      this.options.endcolor = this.element.getStyle('background-color').parseColor('#ffffff');
    if (!this.options.restorecolor)
      this.options.restorecolor = this.element.getStyle('background-color');
    // init color calculations
    this._base  = $R(0,2).map(function(i){ return parseInt(this.options.startcolor.slice(i*2+1,i*2+3),16) }.bind(this));
    this._delta = $R(0,2).map(function(i){ return parseInt(this.options.endcolor.slice(i*2+1,i*2+3),16)-this._base[i] }.bind(this));
  },
  update: function(position) {
    this.element.setStyle({backgroundColor: $R(0,2).inject('#',function(m,v,i){
      return m+((this._base[i]+(this._delta[i]*position)).round().toColorPart()); }.bind(this)) });
  },
  finish: function() {
    this.element.setStyle(Object.extend(this.oldStyle, {
      backgroundColor: this.options.restorecolor
    }));
  }
});

Effect.ScrollTo = function(element) {
  var options = arguments[1] || { },
  scrollOffsets = document.viewport.getScrollOffsets(),
  elementOffsets = $(element).cumulativeOffset();

  if (options.offset) elementOffsets[1] += options.offset;

  return new Effect.Tween(null,
    scrollOffsets.top,
    elementOffsets[1],
    options,
    function(p){ scrollTo(scrollOffsets.left, p.round()); }
  );
};

/* ------------- combination effects ------------- */

Effect.Fade = function(element) {
  element = $(element);
  var oldOpacity = element.getInlineOpacity();
  var options = Object.extend({
    from: element.getOpacity() || 1.0,
    to:   0.0,
    afterFinishInternal: function(effect) {
      if (effect.options.to!=0) return;
      effect.element.hide().setStyle({opacity: oldOpacity});
    }
  }, arguments[1] || { });
  return new Effect.Opacity(element,options);
};

Effect.Appear = function(element) {
  element = $(element);
  var options = Object.extend({
  from: (element.getStyle('display') == 'none' ? 0.0 : element.getOpacity() || 0.0),
  to:   1.0,
  // force Safari to render floated elements properly
  afterFinishInternal: function(effect) {
    effect.element.forceRerendering();
  },
  beforeSetup: function(effect) {
    effect.element.setOpacity(effect.options.from).show();
  }}, arguments[1] || { });
  return new Effect.Opacity(element,options);
};

Effect.Puff = function(element) {
  element = $(element);
  var oldStyle = {
    opacity: element.getInlineOpacity(),
    position: element.getStyle('position'),
    top:  element.style.top,
    left: element.style.left,
    width: element.style.width,
    height: element.style.height
  };
  return new Effect.Parallel(
   [ new Effect.Scale(element, 200,
      { sync: true, scaleFromCenter: true, scaleContent: true, restoreAfterFinish: true }),
     new Effect.Opacity(element, { sync: true, to: 0.0 } ) ],
     Object.extend({ duration: 1.0,
      beforeSetupInternal: function(effect) {
        Position.absolutize(effect.effects[0].element);
      },
      afterFinishInternal: function(effect) {
         effect.effects[0].element.hide().setStyle(oldStyle); }
     }, arguments[1] || { })
   );
};

Effect.BlindUp = function(element) {
  element = $(element);
  element.makeClipping();
  return new Effect.Scale(element, 0,
    Object.extend({ scaleContent: false,
      scaleX: false,
      restoreAfterFinish: true,
      afterFinishInternal: function(effect) {
        effect.element.hide().undoClipping();
      }
    }, arguments[1] || { })
  );
};

Effect.BlindDown = function(element) {
  element = $(element);
  var elementDimensions = element.getDimensions();
  return new Effect.Scale(element, 100, Object.extend({
    scaleContent: false,
    scaleX: false,
    scaleFrom: 0,
    scaleMode: {originalHeight: elementDimensions.height, originalWidth: elementDimensions.width},
    restoreAfterFinish: true,
    afterSetup: function(effect) {
      effect.element.makeClipping().setStyle({height: '0px'}).show();
    },
    afterFinishInternal: function(effect) {
      effect.element.undoClipping();
    }
  }, arguments[1] || { }));
};

Effect.SwitchOff = function(element) {
  element = $(element);
  var oldOpacity = element.getInlineOpacity();
  return new Effect.Appear(element, Object.extend({
    duration: 0.4,
    from: 0,
    transition: Effect.Transitions.flicker,
    afterFinishInternal: function(effect) {
      new Effect.Scale(effect.element, 1, {
        duration: 0.3, scaleFromCenter: true,
        scaleX: false, scaleContent: false, restoreAfterFinish: true,
        beforeSetup: function(effect) {
          effect.element.makePositioned().makeClipping();
        },
        afterFinishInternal: function(effect) {
          effect.element.hide().undoClipping().undoPositioned().setStyle({opacity: oldOpacity});
        }
      });
    }
  }, arguments[1] || { }));
};

Effect.DropOut = function(element) {
  element = $(element);
  var oldStyle = {
    top: element.getStyle('top'),
    left: element.getStyle('left'),
    opacity: element.getInlineOpacity() };
  return new Effect.Parallel(
    [ new Effect.Move(element, {x: 0, y: 100, sync: true }),
      new Effect.Opacity(element, { sync: true, to: 0.0 }) ],
    Object.extend(
      { duration: 0.5,
        beforeSetup: function(effect) {
          effect.effects[0].element.makePositioned();
        },
        afterFinishInternal: function(effect) {
          effect.effects[0].element.hide().undoPositioned().setStyle(oldStyle);
        }
      }, arguments[1] || { }));
};

Effect.Shake = function(element) {
  element = $(element);
  var options = Object.extend({
    distance: 20,
    duration: 0.5
  }, arguments[1] || {});
  var distance = parseFloat(options.distance);
  var split = parseFloat(options.duration) / 10.0;
  var oldStyle = {
    top: element.getStyle('top'),
    left: element.getStyle('left') };
    return new Effect.Move(element,
      { x:  distance, y: 0, duration: split, afterFinishInternal: function(effect) {
    new Effect.Move(effect.element,
      { x: -distance*2, y: 0, duration: split*2,  afterFinishInternal: function(effect) {
    new Effect.Move(effect.element,
      { x:  distance*2, y: 0, duration: split*2,  afterFinishInternal: function(effect) {
    new Effect.Move(effect.element,
      { x: -distance*2, y: 0, duration: split*2,  afterFinishInternal: function(effect) {
    new Effect.Move(effect.element,
      { x:  distance*2, y: 0, duration: split*2,  afterFinishInternal: function(effect) {
    new Effect.Move(effect.element,
      { x: -distance, y: 0, duration: split, afterFinishInternal: function(effect) {
        effect.element.undoPositioned().setStyle(oldStyle);
  }}); }}); }}); }}); }}); }});
};

Effect.SlideDown = function(element) {
  element = $(element).cleanWhitespace();
  // SlideDown need to have the content of the element wrapped in a container element with fixed height!
  var oldInnerBottom = element.down().getStyle('bottom');
  var elementDimensions = element.getDimensions();
  return new Effect.Scale(element, 100, Object.extend({
    scaleContent: false,
    scaleX: false,
    scaleFrom: window.opera ? 0 : 1,
    scaleMode: {originalHeight: elementDimensions.height, originalWidth: elementDimensions.width},
    restoreAfterFinish: true,
    afterSetup: function(effect) {
      effect.element.makePositioned();
      effect.element.down().makePositioned();
      if (window.opera) effect.element.setStyle({top: ''});
      effect.element.makeClipping().setStyle({height: '0px'}).show();
    },
    afterUpdateInternal: function(effect) {
      effect.element.down().setStyle({bottom:
        (effect.dims[0] - effect.element.clientHeight) + 'px' });
    },
    afterFinishInternal: function(effect) {
      effect.element.undoClipping().undoPositioned();
      effect.element.down().undoPositioned().setStyle({bottom: oldInnerBottom}); }
    }, arguments[1] || { })
  );
};

Effect.SlideUp = function(element) {
  element = $(element).cleanWhitespace();
  var oldInnerBottom = element.down().getStyle('bottom');
  var elementDimensions = element.getDimensions();
  return new Effect.Scale(element, window.opera ? 0 : 1,
   Object.extend({ scaleContent: false,
    scaleX: false,
    scaleMode: 'box',
    scaleFrom: 100,
    scaleMode: {originalHeight: elementDimensions.height, originalWidth: elementDimensions.width},
    restoreAfterFinish: true,
    afterSetup: function(effect) {
      effect.element.makePositioned();
      effect.element.down().makePositioned();
      if (window.opera) effect.element.setStyle({top: ''});
      effect.element.makeClipping().show();
    },
    afterUpdateInternal: function(effect) {
      effect.element.down().setStyle({bottom:
        (effect.dims[0] - effect.element.clientHeight) + 'px' });
    },
    afterFinishInternal: function(effect) {
      effect.element.hide().undoClipping().undoPositioned();
      effect.element.down().undoPositioned().setStyle({bottom: oldInnerBottom});
    }
   }, arguments[1] || { })
  );
};

// Bug in opera makes the TD containing this element expand for a instance after finish
Effect.Squish = function(element) {
  return new Effect.Scale(element, window.opera ? 1 : 0, {
    restoreAfterFinish: true,
    beforeSetup: function(effect) {
      effect.element.makeClipping();
    },
    afterFinishInternal: function(effect) {
      effect.element.hide().undoClipping();
    }
  });
};

Effect.Grow = function(element) {
  element = $(element);
  var options = Object.extend({
    direction: 'center',
    moveTransition: Effect.Transitions.sinoidal,
    scaleTransition: Effect.Transitions.sinoidal,
    opacityTransition: Effect.Transitions.full
  }, arguments[1] || { });
  var oldStyle = {
    top: element.style.top,
    left: element.style.left,
    height: element.style.height,
    width: element.style.width,
    opacity: element.getInlineOpacity() };

  var dims = element.getDimensions();
  var initialMoveX, initialMoveY;
  var moveX, moveY;

  switch (options.direction) {
    case 'top-left':
      initialMoveX = initialMoveY = moveX = moveY = 0;
      break;
    case 'top-right':
      initialMoveX = dims.width;
      initialMoveY = moveY = 0;
      moveX = -dims.width;
      break;
    case 'bottom-left':
      initialMoveX = moveX = 0;
      initialMoveY = dims.height;
      moveY = -dims.height;
      break;
    case 'bottom-right':
      initialMoveX = dims.width;
      initialMoveY = dims.height;
      moveX = -dims.width;
      moveY = -dims.height;
      break;
    case 'center':
      initialMoveX = dims.width / 2;
      initialMoveY = dims.height / 2;
      moveX = -dims.width / 2;
      moveY = -dims.height / 2;
      break;
  }

  return new Effect.Move(element, {
    x: initialMoveX,
    y: initialMoveY,
    duration: 0.01,
    beforeSetup: function(effect) {
      effect.element.hide().makeClipping().makePositioned();
    },
    afterFinishInternal: function(effect) {
      new Effect.Parallel(
        [ new Effect.Opacity(effect.element, { sync: true, to: 1.0, from: 0.0, transition: options.opacityTransition }),
          new Effect.Move(effect.element, { x: moveX, y: moveY, sync: true, transition: options.moveTransition }),
          new Effect.Scale(effect.element, 100, {
            scaleMode: { originalHeight: dims.height, originalWidth: dims.width },
            sync: true, scaleFrom: window.opera ? 1 : 0, transition: options.scaleTransition, restoreAfterFinish: true})
        ], Object.extend({
             beforeSetup: function(effect) {
               effect.effects[0].element.setStyle({height: '0px'}).show();
             },
             afterFinishInternal: function(effect) {
               effect.effects[0].element.undoClipping().undoPositioned().setStyle(oldStyle);
             }
           }, options)
      );
    }
  });
};

Effect.Shrink = function(element) {
  element = $(element);
  var options = Object.extend({
    direction: 'center',
    moveTransition: Effect.Transitions.sinoidal,
    scaleTransition: Effect.Transitions.sinoidal,
    opacityTransition: Effect.Transitions.none
  }, arguments[1] || { });
  var oldStyle = {
    top: element.style.top,
    left: element.style.left,
    height: element.style.height,
    width: element.style.width,
    opacity: element.getInlineOpacity() };

  var dims = element.getDimensions();
  var moveX, moveY;

  switch (options.direction) {
    case 'top-left':
      moveX = moveY = 0;
      break;
    case 'top-right':
      moveX = dims.width;
      moveY = 0;
      break;
    case 'bottom-left':
      moveX = 0;
      moveY = dims.height;
      break;
    case 'bottom-right':
      moveX = dims.width;
      moveY = dims.height;
      break;
    case 'center':
      moveX = dims.width / 2;
      moveY = dims.height / 2;
      break;
  }

  return new Effect.Parallel(
    [ new Effect.Opacity(element, { sync: true, to: 0.0, from: 1.0, transition: options.opacityTransition }),
      new Effect.Scale(element, window.opera ? 1 : 0, { sync: true, transition: options.scaleTransition, restoreAfterFinish: true}),
      new Effect.Move(element, { x: moveX, y: moveY, sync: true, transition: options.moveTransition })
    ], Object.extend({
         beforeStartInternal: function(effect) {
           effect.effects[0].element.makePositioned().makeClipping();
         },
         afterFinishInternal: function(effect) {
           effect.effects[0].element.hide().undoClipping().undoPositioned().setStyle(oldStyle); }
       }, options)
  );
};

Effect.Pulsate = function(element) {
  element = $(element);
  var options    = arguments[1] || { },
    oldOpacity = element.getInlineOpacity(),
    transition = options.transition || Effect.Transitions.linear,
    reverser   = function(pos){
      return 1 - transition((-Math.cos((pos*(options.pulses||5)*2)*Math.PI)/2) + .5);
    };

  return new Effect.Opacity(element,
    Object.extend(Object.extend({  duration: 2.0, from: 0,
      afterFinishInternal: function(effect) { effect.element.setStyle({opacity: oldOpacity}); }
    }, options), {transition: reverser}));
};

Effect.Fold = function(element) {
  element = $(element);
  var oldStyle = {
    top: element.style.top,
    left: element.style.left,
    width: element.style.width,
    height: element.style.height };
  element.makeClipping();
  return new Effect.Scale(element, 5, Object.extend({
    scaleContent: false,
    scaleX: false,
    afterFinishInternal: function(effect) {
    new Effect.Scale(element, 1, {
      scaleContent: false,
      scaleY: false,
      afterFinishInternal: function(effect) {
        effect.element.hide().undoClipping().setStyle(oldStyle);
      } });
  }}, arguments[1] || { }));
};

Effect.Morph = Class.create(Effect.Base, {
  initialize: function(element) {
    this.element = $(element);
    if (!this.element) throw(Effect._elementDoesNotExistError);
    var options = Object.extend({
      style: { }
    }, arguments[1] || { });

    if (!Object.isString(options.style)) this.style = $H(options.style);
    else {
      if (options.style.include(':'))
        this.style = options.style.parseStyle();
      else {
        this.element.addClassName(options.style);
        this.style = $H(this.element.getStyles());
        this.element.removeClassName(options.style);
        var css = this.element.getStyles();
        this.style = this.style.reject(function(style) {
          return style.value == css[style.key];
        });
        options.afterFinishInternal = function(effect) {
          effect.element.addClassName(effect.options.style);
          effect.transforms.each(function(transform) {
            effect.element.style[transform.style] = '';
          });
        };
      }
    }
    this.start(options);
  },

  setup: function(){
    function parseColor(color){
      if (!color || ['rgba(0, 0, 0, 0)','transparent'].include(color)) color = '#ffffff';
      color = color.parseColor();
      return $R(0,2).map(function(i){
        return parseInt( color.slice(i*2+1,i*2+3), 16 );
      });
    }
    this.transforms = this.style.map(function(pair){
      var property = pair[0], value = pair[1], unit = null;

      if (value.parseColor('#zzzzzz') != '#zzzzzz') {
        value = value.parseColor();
        unit  = 'color';
      } else if (property == 'opacity') {
        value = parseFloat(value);
        if (Prototype.Browser.IE && (!this.element.currentStyle.hasLayout))
          this.element.setStyle({zoom: 1});
      } else if (Element.CSS_LENGTH.test(value)) {
          var components = value.match(/^([\+\-]?[0-9\.]+)(.*)$/);
          value = parseFloat(components[1]);
          unit = (components.length == 3) ? components[2] : null;
      }

      var originalValue = this.element.getStyle(property);
      return {
        style: property.camelize(),
        originalValue: unit=='color' ? parseColor(originalValue) : parseFloat(originalValue || 0),
        targetValue: unit=='color' ? parseColor(value) : value,
        unit: unit
      };
    }.bind(this)).reject(function(transform){
      return (
        (transform.originalValue == transform.targetValue) ||
        (
          transform.unit != 'color' &&
          (isNaN(transform.originalValue) || isNaN(transform.targetValue))
        )
      );
    });
  },
  update: function(position) {
    var style = { }, transform, i = this.transforms.length;
    while(i--)
      style[(transform = this.transforms[i]).style] =
        transform.unit=='color' ? '#'+
          (Math.round(transform.originalValue[0]+
            (transform.targetValue[0]-transform.originalValue[0])*position)).toColorPart() +
          (Math.round(transform.originalValue[1]+
            (transform.targetValue[1]-transform.originalValue[1])*position)).toColorPart() +
          (Math.round(transform.originalValue[2]+
            (transform.targetValue[2]-transform.originalValue[2])*position)).toColorPart() :
        (transform.originalValue +
          (transform.targetValue - transform.originalValue) * position).toFixed(3) +
            (transform.unit === null ? '' : transform.unit);
    this.element.setStyle(style, true);
  }
});

Effect.Transform = Class.create({
  initialize: function(tracks){
    this.tracks  = [];
    this.options = arguments[1] || { };
    this.addTracks(tracks);
  },
  addTracks: function(tracks){
    tracks.each(function(track){
      track = $H(track);
      var data = track.values().first();
      this.tracks.push($H({
        ids:     track.keys().first(),
        effect:  Effect.Morph,
        options: { style: data }
      }));
    }.bind(this));
    return this;
  },
  play: function(){
    return new Effect.Parallel(
      this.tracks.map(function(track){
        var ids = track.get('ids'), effect = track.get('effect'), options = track.get('options');
        var elements = [$(ids) || $$(ids)].flatten();
        return elements.map(function(e){ return new effect(e, Object.extend({ sync:true }, options)) });
      }).flatten(),
      this.options
    );
  }
});

Element.CSS_PROPERTIES = $w(
  'backgroundColor backgroundPosition borderBottomColor borderBottomStyle ' +
  'borderBottomWidth borderLeftColor borderLeftStyle borderLeftWidth ' +
  'borderRightColor borderRightStyle borderRightWidth borderSpacing ' +
  'borderTopColor borderTopStyle borderTopWidth bottom clip color ' +
  'fontSize fontWeight height left letterSpacing lineHeight ' +
  'marginBottom marginLeft marginRight marginTop markerOffset maxHeight '+
  'maxWidth minHeight minWidth opacity outlineColor outlineOffset ' +
  'outlineWidth paddingBottom paddingLeft paddingRight paddingTop ' +
  'right textIndent top width wordSpacing zIndex');

Element.CSS_LENGTH = /^(([\+\-]?[0-9\.]+)(em|ex|px|in|cm|mm|pt|pc|\%))|0$/;

String.__parseStyleElement = document.createElement('div');
String.prototype.parseStyle = function(){
  var style, styleRules = $H();
  if (Prototype.Browser.WebKit)
    style = new Element('div',{style:this}).style;
  else {
    String.__parseStyleElement.innerHTML = '<div style="' + this + '"></div>';
    style = String.__parseStyleElement.childNodes[0].style;
  }

  Element.CSS_PROPERTIES.each(function(property){
    if (style[property]) styleRules.set(property, style[property]);
  });

  if (Prototype.Browser.IE && this.include('opacity'))
    styleRules.set('opacity', this.match(/opacity:\s*((?:0|1)?(?:\.\d*)?)/)[1]);

  return styleRules;
};

if (document.defaultView && document.defaultView.getComputedStyle) {
  Element.getStyles = function(element) {
    var css = document.defaultView.getComputedStyle($(element), null);
    return Element.CSS_PROPERTIES.inject({ }, function(styles, property) {
      styles[property] = css[property];
      return styles;
    });
  };
} else {
  Element.getStyles = function(element) {
    element = $(element);
    var css = element.currentStyle, styles;
    styles = Element.CSS_PROPERTIES.inject({ }, function(results, property) {
      results[property] = css[property];
      return results;
    });
    if (!styles.opacity) styles.opacity = element.getOpacity();
    return styles;
  };
}

Effect.Methods = {
  morph: function(element, style) {
    element = $(element);
    new Effect.Morph(element, Object.extend({ style: style }, arguments[2] || { }));
    return element;
  },
  visualEffect: function(element, effect, options) {
    element = $(element);
    var s = effect.dasherize().camelize(), klass = s.charAt(0).toUpperCase() + s.substring(1);
    new Effect[klass](element, options);
    return element;
  },
  highlight: function(element, options) {
    element = $(element);
    new Effect.Highlight(element, options);
    return element;
  }
};

$w('fade appear grow shrink fold blindUp blindDown slideUp slideDown '+
  'pulsate shake puff squish switchOff dropOut').each(
  function(effect) {
    Effect.Methods[effect] = function(element, options){
      element = $(element);
      Effect[effect.charAt(0).toUpperCase() + effect.substring(1)](element, options);
      return element;
    };
  }
);

$w('getInlineOpacity forceRerendering setContentZoom collectTextNodes collectTextNodesIgnoreClass getStyles').each(
  function(f) { Effect.Methods[f] = Element[f]; }
);

Element.addMethods(Effect.Methods);
// script.aculo.us controls.js v1.8.3, Thu Oct 08 11:23:33 +0200 2009

// Copyright (c) 2005-2009 Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)
//           (c) 2005-2009 Ivan Krstic (http://blogs.law.harvard.edu/ivan)
//           (c) 2005-2009 Jon Tirsen (http://www.tirsen.com)
// Contributors:
//  Richard Livsey
//  Rahul Bhargava
//  Rob Wills
//
// script.aculo.us is freely distributable under the terms of an MIT-style license.
// For details, see the script.aculo.us web site: http://script.aculo.us/

// Autocompleter.Base handles all the autocompletion functionality
// that's independent of the data source for autocompletion. This
// includes drawing the autocompletion menu, observing keyboard
// and mouse events, and similar.
//
// Specific autocompleters need to provide, at the very least,
// a getUpdatedChoices function that will be invoked every time
// the text inside the monitored textbox changes. This method
// should get the text for which to provide autocompletion by
// invoking this.getToken(), NOT by directly accessing
// this.element.value. This is to allow incremental tokenized
// autocompletion. Specific auto-completion logic (AJAX, etc)
// belongs in getUpdatedChoices.
//
// Tokenized incremental autocompletion is enabled automatically
// when an autocompleter is instantiated with the 'tokens' option
// in the options parameter, e.g.:
// new Ajax.Autocompleter('id','upd', '/url/', { tokens: ',' });
// will incrementally autocomplete with a comma as the token.
// Additionally, ',' in the above example can be replaced with
// a token array, e.g. { tokens: [',', '\n'] } which
// enables autocompletion on multiple tokens. This is most
// useful when one of the tokens is \n (a newline), as it
// allows smart autocompletion after linebreaks.

if(typeof Effect == 'undefined')
  throw("controls.js requires including script.aculo.us' effects.js library");

var Autocompleter = { };
Autocompleter.Base = Class.create({
  baseInitialize: function(element, update, options) {
    element          = $(element);
    this.element     = element;
    this.update      = $(update);
    this.hasFocus    = false;
    this.changed     = false;
    this.active      = false;
    this.index       = 0;
    this.entryCount  = 0;
    this.oldElementValue = this.element.value;

    if(this.setOptions)
      this.setOptions(options);
    else
      this.options = options || { };

    this.options.paramName    = this.options.paramName || this.element.name;
    this.options.tokens       = this.options.tokens || [];
    this.options.frequency    = this.options.frequency || 0.4;
    this.options.minChars     = this.options.minChars || 1;
    this.options.onShow       = this.options.onShow ||
      function(element, update){
        if(!update.style.position || update.style.position=='absolute') {
          update.style.position = 'absolute';
          Position.clone(element, update, {
            setHeight: false,
            offsetTop: element.offsetHeight
          });
        }
        Effect.Appear(update,{duration:0.15});
      };
    this.options.onHide = this.options.onHide ||
      function(element, update){ new Effect.Fade(update,{duration:0.15}) };

    if(typeof(this.options.tokens) == 'string')
      this.options.tokens = new Array(this.options.tokens);
    // Force carriage returns as token delimiters anyway
    if (!this.options.tokens.include('\n'))
      this.options.tokens.push('\n');

    this.observer = null;

    this.element.setAttribute('autocomplete','off');

    Element.hide(this.update);

    Event.observe(this.element, 'blur', this.onBlur.bindAsEventListener(this));
    Event.observe(this.element, 'keydown', this.onKeyPress.bindAsEventListener(this));
  },

  show: function() {
    if(Element.getStyle(this.update, 'display')=='none') this.options.onShow(this.element, this.update);
    if(!this.iefix &&
      (Prototype.Browser.IE) &&
      (Element.getStyle(this.update, 'position')=='absolute')) {
      new Insertion.After(this.update,
       '<iframe id="' + this.update.id + '_iefix" '+
       'style="display:none;position:absolute;filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0);" ' +
       'src="javascript:false;" frameborder="0" scrolling="no"></iframe>');
      this.iefix = $(this.update.id+'_iefix');
    }
    if(this.iefix) setTimeout(this.fixIEOverlapping.bind(this), 50);
  },

  fixIEOverlapping: function() {
    Position.clone(this.update, this.iefix, {setTop:(!this.update.style.height)});
    this.iefix.style.zIndex = 1;
    this.update.style.zIndex = 2;
    Element.show(this.iefix);
  },

  hide: function() {
    this.stopIndicator();
    if(Element.getStyle(this.update, 'display')!='none') this.options.onHide(this.element, this.update);
    if(this.iefix) Element.hide(this.iefix);
  },

  startIndicator: function() {
    if(this.options.indicator) Element.show(this.options.indicator);
  },

  stopIndicator: function() {
    if(this.options.indicator) Element.hide(this.options.indicator);
  },

  onKeyPress: function(event) {
    if(this.active)
      switch(event.keyCode) {
       case Event.KEY_TAB:
       case Event.KEY_RETURN:
         this.selectEntry();
         Event.stop(event);
       case Event.KEY_ESC:
         this.hide();
         this.active = false;
         Event.stop(event);
         return;
       case Event.KEY_LEFT:
       case Event.KEY_RIGHT:
         return;
       case Event.KEY_UP:
         this.markPrevious();
         this.render();
         Event.stop(event);
         return;
       case Event.KEY_DOWN:
         this.markNext();
         this.render();
         Event.stop(event);
         return;
      }
     else
       if(event.keyCode==Event.KEY_TAB || event.keyCode==Event.KEY_RETURN ||
         (Prototype.Browser.WebKit > 0 && event.keyCode == 0)) return;

    this.changed = true;
    this.hasFocus = true;

    if(this.observer) clearTimeout(this.observer);
      this.observer =
        setTimeout(this.onObserverEvent.bind(this), this.options.frequency*1000);
  },

  activate: function() {
    this.changed = false;
    this.hasFocus = true;
    this.getUpdatedChoices();
  },

  onHover: function(event) {
    var element = Event.findElement(event, 'LI');
    if(this.index != element.autocompleteIndex)
    {
        this.index = element.autocompleteIndex;
        this.render();
    }
    Event.stop(event);
  },

  onClick: function(event) {
    var element = Event.findElement(event, 'LI');
    this.index = element.autocompleteIndex;
    this.selectEntry();
    this.hide();
  },

  onBlur: function(event) {
    // needed to make click events working
    setTimeout(this.hide.bind(this), 250);
    this.hasFocus = false;
    this.active = false;
  },

  render: function() {
    if(this.entryCount > 0) {
      for (var i = 0; i < this.entryCount; i++)
        this.index==i ?
          Element.addClassName(this.getEntry(i),"selected") :
          Element.removeClassName(this.getEntry(i),"selected");
      if(this.hasFocus) {
        this.show();
        this.active = true;
      }
    } else {
      this.active = false;
      this.hide();
    }
  },

  markPrevious: function() {
    if(this.index > 0) this.index--;
      else this.index = this.entryCount-1;
    this.getEntry(this.index).scrollIntoView(true);
  },

  markNext: function() {
    if(this.index < this.entryCount-1) this.index++;
      else this.index = 0;
    this.getEntry(this.index).scrollIntoView(false);
  },

  getEntry: function(index) {
    return this.update.firstChild.childNodes[index];
  },

  getCurrentEntry: function() {
    return this.getEntry(this.index);
  },

  selectEntry: function() {
    this.active = false;
    this.updateElement(this.getCurrentEntry());
  },

  updateElement: function(selectedElement) {
    if (this.options.updateElement) {
      this.options.updateElement(selectedElement);
      return;
    }
    var value = '';
    if (this.options.select) {
      var nodes = $(selectedElement).select('.' + this.options.select) || [];
      if(nodes.length>0) value = Element.collectTextNodes(nodes[0], this.options.select);
    } else
      value = Element.collectTextNodesIgnoreClass(selectedElement, 'informal');

    var bounds = this.getTokenBounds();
    if (bounds[0] != -1) {
      var newValue = this.element.value.substr(0, bounds[0]);
      var whitespace = this.element.value.substr(bounds[0]).match(/^\s+/);
      if (whitespace)
        newValue += whitespace[0];
      this.element.value = newValue + value + this.element.value.substr(bounds[1]);
    } else {
      this.element.value = value;
    }
    this.oldElementValue = this.element.value;
    this.element.focus();

    if (this.options.afterUpdateElement)
      this.options.afterUpdateElement(this.element, selectedElement);
  },

  updateChoices: function(choices) {
    if(!this.changed && this.hasFocus) {
      this.update.innerHTML = choices;
      Element.cleanWhitespace(this.update);
      Element.cleanWhitespace(this.update.down());

      if(this.update.firstChild && this.update.down().childNodes) {
        this.entryCount =
          this.update.down().childNodes.length;
        for (var i = 0; i < this.entryCount; i++) {
          var entry = this.getEntry(i);
          entry.autocompleteIndex = i;
          this.addObservers(entry);
        }
      } else {
        this.entryCount = 0;
      }

      this.stopIndicator();
      this.index = 0;

      if(this.entryCount==1 && this.options.autoSelect) {
        this.selectEntry();
        this.hide();
      } else {
        this.render();
      }
    }
  },

  addObservers: function(element) {
    Event.observe(element, "mouseover", this.onHover.bindAsEventListener(this));
    Event.observe(element, "click", this.onClick.bindAsEventListener(this));
  },

  onObserverEvent: function() {
    this.changed = false;
    this.tokenBounds = null;
    if(this.getToken().length>=this.options.minChars) {
      this.getUpdatedChoices();
    } else {
      this.active = false;
      this.hide();
    }
    this.oldElementValue = this.element.value;
  },

  getToken: function() {
    var bounds = this.getTokenBounds();
    return this.element.value.substring(bounds[0], bounds[1]).strip();
  },

  getTokenBounds: function() {
    if (null != this.tokenBounds) return this.tokenBounds;
    var value = this.element.value;
    if (value.strip().empty()) return [-1, 0];
    var diff = arguments.callee.getFirstDifferencePos(value, this.oldElementValue);
    var offset = (diff == this.oldElementValue.length ? 1 : 0);
    var prevTokenPos = -1, nextTokenPos = value.length;
    var tp;
    for (var index = 0, l = this.options.tokens.length; index < l; ++index) {
      tp = value.lastIndexOf(this.options.tokens[index], diff + offset - 1);
      if (tp > prevTokenPos) prevTokenPos = tp;
      tp = value.indexOf(this.options.tokens[index], diff + offset);
      if (-1 != tp && tp < nextTokenPos) nextTokenPos = tp;
    }
    return (this.tokenBounds = [prevTokenPos + 1, nextTokenPos]);
  }
});

Autocompleter.Base.prototype.getTokenBounds.getFirstDifferencePos = function(newS, oldS) {
  var boundary = Math.min(newS.length, oldS.length);
  for (var index = 0; index < boundary; ++index)
    if (newS[index] != oldS[index])
      return index;
  return boundary;
};

Ajax.Autocompleter = Class.create(Autocompleter.Base, {
  initialize: function(element, update, url, options) {
    this.baseInitialize(element, update, options);
    this.options.asynchronous  = true;
    this.options.onComplete    = this.onComplete.bind(this);
    this.options.defaultParams = this.options.parameters || null;
    this.url                   = url;
  },

  getUpdatedChoices: function() {
    this.startIndicator();

    var entry = encodeURIComponent(this.options.paramName) + '=' +
      encodeURIComponent(this.getToken());

    this.options.parameters = this.options.callback ?
      this.options.callback(this.element, entry) : entry;

    if(this.options.defaultParams)
      this.options.parameters += '&' + this.options.defaultParams;

    new Ajax.Request(this.url, this.options);
  },

  onComplete: function(request) {
    this.updateChoices(request.responseText);
  }
});

// The local array autocompleter. Used when you'd prefer to
// inject an array of autocompletion options into the page, rather
// than sending out Ajax queries, which can be quite slow sometimes.
//
// The constructor takes four parameters. The first two are, as usual,
// the id of the monitored textbox, and id of the autocompletion menu.
// The third is the array you want to autocomplete from, and the fourth
// is the options block.
//
// Extra local autocompletion options:
// - choices - How many autocompletion choices to offer
//
// - partialSearch - If false, the autocompleter will match entered
//                    text only at the beginning of strings in the
//                    autocomplete array. Defaults to true, which will
//                    match text at the beginning of any *word* in the
//                    strings in the autocomplete array. If you want to
//                    search anywhere in the string, additionally set
//                    the option fullSearch to true (default: off).
//
// - fullSsearch - Search anywhere in autocomplete array strings.
//
// - partialChars - How many characters to enter before triggering
//                   a partial match (unlike minChars, which defines
//                   how many characters are required to do any match
//                   at all). Defaults to 2.
//
// - ignoreCase - Whether to ignore case when autocompleting.
//                 Defaults to true.
//
// It's possible to pass in a custom function as the 'selector'
// option, if you prefer to write your own autocompletion logic.
// In that case, the other options above will not apply unless
// you support them.

Autocompleter.Local = Class.create(Autocompleter.Base, {
  initialize: function(element, update, array, options) {
    this.baseInitialize(element, update, options);
    this.options.array = array;
  },

  getUpdatedChoices: function() {
    this.updateChoices(this.options.selector(this));
  },

  setOptions: function(options) {
    this.options = Object.extend({
      choices: 10,
      partialSearch: true,
      partialChars: 2,
      ignoreCase: true,
      fullSearch: false,
      selector: function(instance) {
        var ret       = []; // Beginning matches
        var partial   = []; // Inside matches
        var entry     = instance.getToken();
        var count     = 0;

        for (var i = 0; i < instance.options.array.length &&
          ret.length < instance.options.choices ; i++) {

          var elem = instance.options.array[i];
          var foundPos = instance.options.ignoreCase ?
            elem.toLowerCase().indexOf(entry.toLowerCase()) :
            elem.indexOf(entry);

          while (foundPos != -1) {
            if (foundPos == 0 && elem.length != entry.length) {
              ret.push("<li><strong>" + elem.substr(0, entry.length) + "</strong>" +
                elem.substr(entry.length) + "</li>");
              break;
            } else if (entry.length >= instance.options.partialChars &&
              instance.options.partialSearch && foundPos != -1) {
              if (instance.options.fullSearch || /\s/.test(elem.substr(foundPos-1,1))) {
                partial.push("<li>" + elem.substr(0, foundPos) + "<strong>" +
                  elem.substr(foundPos, entry.length) + "</strong>" + elem.substr(
                  foundPos + entry.length) + "</li>");
                break;
              }
            }

            foundPos = instance.options.ignoreCase ?
              elem.toLowerCase().indexOf(entry.toLowerCase(), foundPos + 1) :
              elem.indexOf(entry, foundPos + 1);

          }
        }
        if (partial.length)
          ret = ret.concat(partial.slice(0, instance.options.choices - ret.length));
        return "<ul>" + ret.join('') + "</ul>";
      }
    }, options || { });
  }
});

// AJAX in-place editor and collection editor
// Full rewrite by Christophe Porteneuve <tdd@tddsworld.com> (April 2007).

// Use this if you notice weird scrolling problems on some browsers,
// the DOM might be a bit confused when this gets called so do this
// waits 1 ms (with setTimeout) until it does the activation
Field.scrollFreeActivate = function(field) {
  setTimeout(function() {
    Field.activate(field);
  }, 1);
};

Ajax.InPlaceEditor = Class.create({
  initialize: function(element, url, options) {
    this.url = url;
    this.element = element = $(element);
    this.prepareOptions();
    this._controls = { };
    arguments.callee.dealWithDeprecatedOptions(options); // DEPRECATION LAYER!!!
    Object.extend(this.options, options || { });
    if (!this.options.formId && this.element.id) {
      this.options.formId = this.element.id + '-inplaceeditor';
      if ($(this.options.formId))
        this.options.formId = '';
    }
    if (this.options.externalControl)
      this.options.externalControl = $(this.options.externalControl);
    if (!this.options.externalControl)
      this.options.externalControlOnly = false;
    this._originalBackground = this.element.getStyle('background-color') || 'transparent';
    this.element.title = this.options.clickToEditText;
    this._boundCancelHandler = this.handleFormCancellation.bind(this);
    this._boundComplete = (this.options.onComplete || Prototype.emptyFunction).bind(this);
    this._boundFailureHandler = this.handleAJAXFailure.bind(this);
    this._boundSubmitHandler = this.handleFormSubmission.bind(this);
    this._boundWrapperHandler = this.wrapUp.bind(this);
    this.registerListeners();
  },
  checkForEscapeOrReturn: function(e) {
    if (!this._editing || e.ctrlKey || e.altKey || e.shiftKey) return;
    if (Event.KEY_ESC == e.keyCode)
      this.handleFormCancellation(e);
    else if (Event.KEY_RETURN == e.keyCode)
      this.handleFormSubmission(e);
  },
  createControl: function(mode, handler, extraClasses) {
    var control = this.options[mode + 'Control'];
    var text = this.options[mode + 'Text'];
    if ('button' == control) {
      var btn = document.createElement('input');
      btn.type = 'submit';
      btn.value = text;
      btn.className = 'editor_' + mode + '_button';
      if ('cancel' == mode)
        btn.onclick = this._boundCancelHandler;
      this._form.appendChild(btn);
      this._controls[mode] = btn;
    } else if ('link' == control) {
      var link = document.createElement('a');
      link.href = '#';
      link.appendChild(document.createTextNode(text));
      link.onclick = 'cancel' == mode ? this._boundCancelHandler : this._boundSubmitHandler;
      link.className = 'editor_' + mode + '_link';
      if (extraClasses)
        link.className += ' ' + extraClasses;
      this._form.appendChild(link);
      this._controls[mode] = link;
    }
  },
  createEditField: function() {
    var text = (this.options.loadTextURL ? this.options.loadingText : this.getText());
    var fld;
    if (1 >= this.options.rows && !/\r|\n/.test(this.getText())) {
      fld = document.createElement('input');
      fld.type = 'text';
      var size = this.options.size || this.options.cols || 0;
      if (0 < size) fld.size = size;
    } else {
      fld = document.createElement('textarea');
      fld.rows = (1 >= this.options.rows ? this.options.autoRows : this.options.rows);
      fld.cols = this.options.cols || 40;
    }
    fld.name = this.options.paramName;
    fld.value = text; // No HTML breaks conversion anymore
    fld.className = 'editor_field';
    if (this.options.submitOnBlur)
      fld.onblur = this._boundSubmitHandler;
    this._controls.editor = fld;
    if (this.options.loadTextURL)
      this.loadExternalText();
    this._form.appendChild(this._controls.editor);
  },
  createForm: function() {
    var ipe = this;
    function addText(mode, condition) {
      var text = ipe.options['text' + mode + 'Controls'];
      if (!text || condition === false) return;
      ipe._form.appendChild(document.createTextNode(text));
    };
    this._form = $(document.createElement('form'));
    this._form.id = this.options.formId;
    this._form.addClassName(this.options.formClassName);
    this._form.onsubmit = this._boundSubmitHandler;
    this.createEditField();
    if ('textarea' == this._controls.editor.tagName.toLowerCase())
      this._form.appendChild(document.createElement('br'));
    if (this.options.onFormCustomization)
      this.options.onFormCustomization(this, this._form);
    addText('Before', this.options.okControl || this.options.cancelControl);
    this.createControl('ok', this._boundSubmitHandler);
    addText('Between', this.options.okControl && this.options.cancelControl);
    this.createControl('cancel', this._boundCancelHandler, 'editor_cancel');
    addText('After', this.options.okControl || this.options.cancelControl);
  },
  destroy: function() {
    if (this._oldInnerHTML)
      this.element.innerHTML = this._oldInnerHTML;
    this.leaveEditMode();
    this.unregisterListeners();
  },
  enterEditMode: function(e) {
    if (this._saving || this._editing) return;
    this._editing = true;
    this.triggerCallback('onEnterEditMode');
    if (this.options.externalControl)
      this.options.externalControl.hide();
    this.element.hide();
    this.createForm();
    this.element.parentNode.insertBefore(this._form, this.element);
    if (!this.options.loadTextURL)
      this.postProcessEditField();
    if (e) Event.stop(e);
  },
  enterHover: function(e) {
    if (this.options.hoverClassName)
      this.element.addClassName(this.options.hoverClassName);
    if (this._saving) return;
    this.triggerCallback('onEnterHover');
  },
  getText: function() {
    return this.element.innerHTML.unescapeHTML();
  },
  handleAJAXFailure: function(transport) {
    this.triggerCallback('onFailure', transport);
    if (this._oldInnerHTML) {
      this.element.innerHTML = this._oldInnerHTML;
      this._oldInnerHTML = null;
    }
  },
  handleFormCancellation: function(e) {
    this.wrapUp();
    if (e) Event.stop(e);
  },
  handleFormSubmission: function(e) {
    var form = this._form;
    var value = $F(this._controls.editor);
    this.prepareSubmission();
    var params = this.options.callback(form, value) || '';
    if (Object.isString(params))
      params = params.toQueryParams();
    params.editorId = this.element.id;
    if (this.options.htmlResponse) {
      var options = Object.extend({ evalScripts: true }, this.options.ajaxOptions);
      Object.extend(options, {
        parameters: params,
        onComplete: this._boundWrapperHandler,
        onFailure: this._boundFailureHandler
      });
      new Ajax.Updater({ success: this.element }, this.url, options);
    } else {
      var options = Object.extend({ method: 'get' }, this.options.ajaxOptions);
      Object.extend(options, {
        parameters: params,
        onComplete: this._boundWrapperHandler,
        onFailure: this._boundFailureHandler
      });
      new Ajax.Request(this.url, options);
    }
    if (e) Event.stop(e);
  },
  leaveEditMode: function() {
    this.element.removeClassName(this.options.savingClassName);
    this.removeForm();
    this.leaveHover();
    this.element.style.backgroundColor = this._originalBackground;
    this.element.show();
    if (this.options.externalControl)
      this.options.externalControl.show();
    this._saving = false;
    this._editing = false;
    this._oldInnerHTML = null;
    this.triggerCallback('onLeaveEditMode');
  },
  leaveHover: function(e) {
    if (this.options.hoverClassName)
      this.element.removeClassName(this.options.hoverClassName);
    if (this._saving) return;
    this.triggerCallback('onLeaveHover');
  },
  loadExternalText: function() {
    this._form.addClassName(this.options.loadingClassName);
    this._controls.editor.disabled = true;
    var options = Object.extend({ method: 'get' }, this.options.ajaxOptions);
    Object.extend(options, {
      parameters: 'editorId=' + encodeURIComponent(this.element.id),
      onComplete: Prototype.emptyFunction,
      onSuccess: function(transport) {
        this._form.removeClassName(this.options.loadingClassName);
        var text = transport.responseText;
        if (this.options.stripLoadedTextTags)
          text = text.stripTags();
        this._controls.editor.value = text;
        this._controls.editor.disabled = false;
        this.postProcessEditField();
      }.bind(this),
      onFailure: this._boundFailureHandler
    });
    new Ajax.Request(this.options.loadTextURL, options);
  },
  postProcessEditField: function() {
    var fpc = this.options.fieldPostCreation;
    if (fpc)
      $(this._controls.editor)['focus' == fpc ? 'focus' : 'activate']();
  },
  prepareOptions: function() {
    this.options = Object.clone(Ajax.InPlaceEditor.DefaultOptions);
    Object.extend(this.options, Ajax.InPlaceEditor.DefaultCallbacks);
    [this._extraDefaultOptions].flatten().compact().each(function(defs) {
      Object.extend(this.options, defs);
    }.bind(this));
  },
  prepareSubmission: function() {
    this._saving = true;
    this.removeForm();
    this.leaveHover();
    this.showSaving();
  },
  registerListeners: function() {
    this._listeners = { };
    var listener;
    $H(Ajax.InPlaceEditor.Listeners).each(function(pair) {
      listener = this[pair.value].bind(this);
      this._listeners[pair.key] = listener;
      if (!this.options.externalControlOnly)
        this.element.observe(pair.key, listener);
      if (this.options.externalControl)
        this.options.externalControl.observe(pair.key, listener);
    }.bind(this));
  },
  removeForm: function() {
    if (!this._form) return;
    this._form.remove();
    this._form = null;
    this._controls = { };
  },
  showSaving: function() {
    this._oldInnerHTML = this.element.innerHTML;
    this.element.innerHTML = this.options.savingText;
    this.element.addClassName(this.options.savingClassName);
    this.element.style.backgroundColor = this._originalBackground;
    this.element.show();
  },
  triggerCallback: function(cbName, arg) {
    if ('function' == typeof this.options[cbName]) {
      this.options[cbName](this, arg);
    }
  },
  unregisterListeners: function() {
    $H(this._listeners).each(function(pair) {
      if (!this.options.externalControlOnly)
        this.element.stopObserving(pair.key, pair.value);
      if (this.options.externalControl)
        this.options.externalControl.stopObserving(pair.key, pair.value);
    }.bind(this));
  },
  wrapUp: function(transport) {
    this.leaveEditMode();
    // Can't use triggerCallback due to backward compatibility: requires
    // binding + direct element
    this._boundComplete(transport, this.element);
  }
});

Object.extend(Ajax.InPlaceEditor.prototype, {
  dispose: Ajax.InPlaceEditor.prototype.destroy
});

Ajax.InPlaceCollectionEditor = Class.create(Ajax.InPlaceEditor, {
  initialize: function($super, element, url, options) {
    this._extraDefaultOptions = Ajax.InPlaceCollectionEditor.DefaultOptions;
    $super(element, url, options);
  },

  createEditField: function() {
    var list = document.createElement('select');
    list.name = this.options.paramName;
    list.size = 1;
    this._controls.editor = list;
    this._collection = this.options.collection || [];
    if (this.options.loadCollectionURL)
      this.loadCollection();
    else
      this.checkForExternalText();
    this._form.appendChild(this._controls.editor);
  },

  loadCollection: function() {
    this._form.addClassName(this.options.loadingClassName);
    this.showLoadingText(this.options.loadingCollectionText);
    var options = Object.extend({ method: 'get' }, this.options.ajaxOptions);
    Object.extend(options, {
      parameters: 'editorId=' + encodeURIComponent(this.element.id),
      onComplete: Prototype.emptyFunction,
      onSuccess: function(transport) {
        var js = transport.responseText.strip();
        if (!/^\[.*\]$/.test(js)) // TODO: improve sanity check
          throw('Server returned an invalid collection representation.');
        this._collection = eval(js);
        this.checkForExternalText();
      }.bind(this),
      onFailure: this.onFailure
    });
    new Ajax.Request(this.options.loadCollectionURL, options);
  },

  showLoadingText: function(text) {
    this._controls.editor.disabled = true;
    var tempOption = this._controls.editor.firstChild;
    if (!tempOption) {
      tempOption = document.createElement('option');
      tempOption.value = '';
      this._controls.editor.appendChild(tempOption);
      tempOption.selected = true;
    }
    tempOption.update((text || '').stripScripts().stripTags());
  },

  checkForExternalText: function() {
    this._text = this.getText();
    if (this.options.loadTextURL)
      this.loadExternalText();
    else
      this.buildOptionList();
  },

  loadExternalText: function() {
    this.showLoadingText(this.options.loadingText);
    var options = Object.extend({ method: 'get' }, this.options.ajaxOptions);
    Object.extend(options, {
      parameters: 'editorId=' + encodeURIComponent(this.element.id),
      onComplete: Prototype.emptyFunction,
      onSuccess: function(transport) {
        this._text = transport.responseText.strip();
        this.buildOptionList();
      }.bind(this),
      onFailure: this.onFailure
    });
    new Ajax.Request(this.options.loadTextURL, options);
  },

  buildOptionList: function() {
    this._form.removeClassName(this.options.loadingClassName);
    this._collection = this._collection.map(function(entry) {
      return 2 === entry.length ? entry : [entry, entry].flatten();
    });
    var marker = ('value' in this.options) ? this.options.value : this._text;
    var textFound = this._collection.any(function(entry) {
      return entry[0] == marker;
    }.bind(this));
    this._controls.editor.update('');
    var option;
    this._collection.each(function(entry, index) {
      option = document.createElement('option');
      option.value = entry[0];
      option.selected = textFound ? entry[0] == marker : 0 == index;
      option.appendChild(document.createTextNode(entry[1]));
      this._controls.editor.appendChild(option);
    }.bind(this));
    this._controls.editor.disabled = false;
    Field.scrollFreeActivate(this._controls.editor);
  }
});

//**** DEPRECATION LAYER FOR InPlace[Collection]Editor! ****
//**** This only  exists for a while,  in order to  let ****
//**** users adapt to  the new API.  Read up on the new ****
//**** API and convert your code to it ASAP!            ****

Ajax.InPlaceEditor.prototype.initialize.dealWithDeprecatedOptions = function(options) {
  if (!options) return;
  function fallback(name, expr) {
    if (name in options || expr === undefined) return;
    options[name] = expr;
  };
  fallback('cancelControl', (options.cancelLink ? 'link' : (options.cancelButton ? 'button' :
    options.cancelLink == options.cancelButton == false ? false : undefined)));
  fallback('okControl', (options.okLink ? 'link' : (options.okButton ? 'button' :
    options.okLink == options.okButton == false ? false : undefined)));
  fallback('highlightColor', options.highlightcolor);
  fallback('highlightEndColor', options.highlightendcolor);
};

Object.extend(Ajax.InPlaceEditor, {
  DefaultOptions: {
    ajaxOptions: { },
    autoRows: 3,                                // Use when multi-line w/ rows == 1
    cancelControl: 'link',                      // 'link'|'button'|false
    cancelText: 'cancel',
    clickToEditText: 'Click to edit',
    externalControl: null,                      // id|elt
    externalControlOnly: false,
    fieldPostCreation: 'activate',              // 'activate'|'focus'|false
    formClassName: 'inplaceeditor-form',
    formId: null,                               // id|elt
    highlightColor: '#ffff99',
    highlightEndColor: '#ffffff',
    hoverClassName: '',
    htmlResponse: true,
    loadingClassName: 'inplaceeditor-loading',
    loadingText: 'Loading...',
    okControl: 'button',                        // 'link'|'button'|false
    okText: 'ok',
    paramName: 'value',
    rows: 1,                                    // If 1 and multi-line, uses autoRows
    savingClassName: 'inplaceeditor-saving',
    savingText: 'Saving...',
    size: 0,
    stripLoadedTextTags: false,
    submitOnBlur: false,
    textAfterControls: '',
    textBeforeControls: '',
    textBetweenControls: ''
  },
  DefaultCallbacks: {
    callback: function(form) {
      return Form.serialize(form);
    },
    onComplete: function(transport, element) {
      // For backward compatibility, this one is bound to the IPE, and passes
      // the element directly.  It was too often customized, so we don't break it.
      new Effect.Highlight(element, {
        startcolor: this.options.highlightColor, keepBackgroundImage: true });
    },
    onEnterEditMode: null,
    onEnterHover: function(ipe) {
      ipe.element.style.backgroundColor = ipe.options.highlightColor;
      if (ipe._effect)
        ipe._effect.cancel();
    },
    onFailure: function(transport, ipe) {
      alert('Error communication with the server: ' + transport.responseText.stripTags());
    },
    onFormCustomization: null, // Takes the IPE and its generated form, after editor, before controls.
    onLeaveEditMode: null,
    onLeaveHover: function(ipe) {
      ipe._effect = new Effect.Highlight(ipe.element, {
        startcolor: ipe.options.highlightColor, endcolor: ipe.options.highlightEndColor,
        restorecolor: ipe._originalBackground, keepBackgroundImage: true
      });
    }
  },
  Listeners: {
    click: 'enterEditMode',
    keydown: 'checkForEscapeOrReturn',
    mouseover: 'enterHover',
    mouseout: 'leaveHover'
  }
});

Ajax.InPlaceCollectionEditor.DefaultOptions = {
  loadingCollectionText: 'Loading options...'
};

// Delayed observer, like Form.Element.Observer,
// but waits for delay after last key input
// Ideal for live-search fields

Form.Element.DelayedObserver = Class.create({
  initialize: function(element, delay, callback) {
    this.delay     = delay || 0.5;
    this.element   = $(element);
    this.callback  = callback;
    this.timer     = null;
    this.lastValue = $F(this.element);
    Event.observe(this.element,'keyup',this.delayedListener.bindAsEventListener(this));
  },
  delayedListener: function(event) {
    if(this.lastValue == $F(this.element)) return;
    if(this.timer) clearTimeout(this.timer);
    this.timer = setTimeout(this.onTimerEvent.bind(this), this.delay * 1000);
    this.lastValue = $F(this.element);
  },
  onTimerEvent: function() {
    this.timer = null;
    this.callback(this.element, $F(this.element));
  }
});
// script.aculo.us builder.js v1.8.3, Thu Oct 08 11:23:33 +0200 2009

// Copyright (c) 2005-2009 Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)
//
// script.aculo.us is freely distributable under the terms of an MIT-style license.
// For details, see the script.aculo.us web site: http://script.aculo.us/

var Builder = {
  NODEMAP: {
    AREA: 'map',
    CAPTION: 'table',
    COL: 'table',
    COLGROUP: 'table',
    LEGEND: 'fieldset',
    OPTGROUP: 'select',
    OPTION: 'select',
    PARAM: 'object',
    TBODY: 'table',
    TD: 'table',
    TFOOT: 'table',
    TH: 'table',
    THEAD: 'table',
    TR: 'table'
  },
  // note: For Firefox < 1.5, OPTION and OPTGROUP tags are currently broken,
  //       due to a Firefox bug
  node: function(elementName) {
    elementName = elementName.toUpperCase();

    // try innerHTML approach
    var parentTag = this.NODEMAP[elementName] || 'div';
    var parentElement = document.createElement(parentTag);
    try { // prevent IE "feature": http://dev.rubyonrails.org/ticket/2707
      parentElement.innerHTML = "<" + elementName + "></" + elementName + ">";
    } catch(e) {}
    var element = parentElement.firstChild || null;

    // see if browser added wrapping tags
    if(element && (element.tagName.toUpperCase() != elementName))
      element = element.getElementsByTagName(elementName)[0];

    // fallback to createElement approach
    if(!element) element = document.createElement(elementName);

    // abort if nothing could be created
    if(!element) return;

    // attributes (or text)
    if(arguments[1])
      if(this._isStringOrNumber(arguments[1]) ||
        (arguments[1] instanceof Array) ||
        arguments[1].tagName) {
          this._children(element, arguments[1]);
        } else {
          var attrs = this._attributes(arguments[1]);
          if(attrs.length) {
            try { // prevent IE "feature": http://dev.rubyonrails.org/ticket/2707
              parentElement.innerHTML = "<" +elementName + " " +
                attrs + "></" + elementName + ">";
            } catch(e) {}
            element = parentElement.firstChild || null;
            // workaround firefox 1.0.X bug
            if(!element) {
              element = document.createElement(elementName);
              for(attr in arguments[1])
                element[attr == 'class' ? 'className' : attr] = arguments[1][attr];
            }
            if(element.tagName.toUpperCase() != elementName)
              element = parentElement.getElementsByTagName(elementName)[0];
          }
        }

    // text, or array of children
    if(arguments[2])
      this._children(element, arguments[2]);

     return $(element);
  },
  _text: function(text) {
     return document.createTextNode(text);
  },

  ATTR_MAP: {
    'className': 'class',
    'htmlFor': 'for'
  },

  _attributes: function(attributes) {
    var attrs = [];
    for(attribute in attributes)
      attrs.push((attribute in this.ATTR_MAP ? this.ATTR_MAP[attribute] : attribute) +
          '="' + attributes[attribute].toString().escapeHTML().gsub(/"/,'&quot;') + '"');
    return attrs.join(" ");
  },
  _children: function(element, children) {
    if(children.tagName) {
      element.appendChild(children);
      return;
    }
    if(typeof children=='object') { // array can hold nodes and text
      children.flatten().each( function(e) {
        if(typeof e=='object')
          element.appendChild(e);
        else
          if(Builder._isStringOrNumber(e))
            element.appendChild(Builder._text(e));
      });
    } else
      if(Builder._isStringOrNumber(children))
        element.appendChild(Builder._text(children));
  },
  _isStringOrNumber: function(param) {
    return(typeof param=='string' || typeof param=='number');
  },
  build: function(html) {
    var element = this.node('div');
    $(element).update(html.strip());
    return element.down();
  },
  dump: function(scope) {
    if(typeof scope != 'object' && typeof scope != 'function') scope = window; //global scope

    var tags = ("A ABBR ACRONYM ADDRESS APPLET AREA B BASE BASEFONT BDO BIG BLOCKQUOTE BODY " +
      "BR BUTTON CAPTION CENTER CITE CODE COL COLGROUP DD DEL DFN DIR DIV DL DT EM FIELDSET " +
      "FONT FORM FRAME FRAMESET H1 H2 H3 H4 H5 H6 HEAD HR HTML I IFRAME IMG INPUT INS ISINDEX "+
      "KBD LABEL LEGEND LI LINK MAP MENU META NOFRAMES NOSCRIPT OBJECT OL OPTGROUP OPTION P "+
      "PARAM PRE Q S SAMP SCRIPT SELECT SMALL SPAN STRIKE STRONG STYLE SUB SUP TABLE TBODY TD "+
      "TEXTAREA TFOOT TH THEAD TITLE TR TT U UL VAR").split(/\s+/);

    tags.each( function(tag){
      scope[tag] = function() {
        return Builder.node.apply(Builder, [tag].concat($A(arguments)));
      };
    });
  }
};
/*

Extensions to Prototype/Scriptaculous

*/

// For "registering" namespaces
// (automatically call an `initialize` method on window load)
Event.register = function(object) {
  // manage a stack of events to invoke
  if (!Event.registeredEvents) { Event.registeredEvents = $A(); }
  if (!object.initialize) { return; }

  Event.registeredEvents.push(object);

  // if the observers was already created, don't create another one
  if (Event.domLoadedObserverCreated) { return; }

  var domLoaded = function(){
    Event.registeredEvents.each(function(object){
      try{ object.initialize(); }
      catch (err){ console.log('Failed invocation because: ' + err); }
    });
  };

  document.observe('dom:loaded', domLoaded);

  Event.domLoadedObserverCreated = true;
};

Element.addMethods({
  isOrphaned: function(element){
    element = $(element);
    if (element.sourceIndex !== null) { return element.sourceIndex < 1; } // for IE only
    if (element.id) { return !element.ownerDocument.getElementById(element.id); }
    return !element.descendantOf(element.ownerDocument.documentElement);
  },
  scrollTo: function(element, container, options){
    options = Object.extend({
      offsetY:0
    }, options || {});
    if (container){
      element = $(element);
      container = $(container);
      container.scrollTop = (element.offsetTop - element.offsetHeight) + options.offsetY;
    } else {
      element = $(element);
      var pos = element.cumulativeOffset();
      window.scrollTo(pos[0], pos[1]);
    }
    return element;
  },
  text: function(element){
    element = $(element);
    /*
    Return a node's inner text only, not the HTML.
    IE uses one method (innerText) and all other browsers use a different one (textContent)
    Also checks for a node or empty node, since it *is* possible to have an empty node
    */
    return (element ? (element.innerText ? element.innerText : element.textContent) : '');
  },
  radioClass: function(element, cls){
    element
      .addClassName(cls)
      .siblings()
        .invoke('removeClassName', cls);
  },
  showIf: function(element, condition){
    element[condition ? 'show' : 'hide']();
  },
  toHTML: function(element) {
    // Taken from prototype mailing list
    // This is so you can take an element and pass it somewhere in string form.

    if (typeof element=='string') { element = $(element); } // IE needs that check with XML
    return Try.these(
      function() {
        var xmlSerializer = new XMLSerializer();
        return  element.nodeType == 4 ? element.nodeValue :
  xmlSerializer.serializeToString(element);
      },
      function() {
        return element.xml || element.outerHTML || $(element).clone().wrap().up().innerHTML;
      }
    ) || '';
  }
});

Object.extend(Form.Element, {
  clearDefaultText: function(element, defaultText){
    element = $(element);

    if ($F(element) == defaultText){
      element.removeClassName('init');
      element.value = '';
    }
    return element;
  }
});

Form.Element.enable = Form.Element.enable.wrap(function(){
  var args = $A(arguments), proceed = args.shift();
  var element = proceed.apply(this, args);

  element.removeClassName('disabled');

  if (element.getAttribute('type') == 'image' && element.hasAttribute('key')) {
    // this is a special button that's already been instantiated as a ImageButton object
    element.removeClassName('image_button_disabled');
    ButtonManager.alterStateOfButton(element.getAttribute('key'), 'normal');
  } else {
    if (element.getAttribute('type') == 'image'){
      element.removeClassName('image_button_disabled');

      if( element.getAttribute('data-image-url') ) {
        element.src = element.getAttribute('data-image-url');
      }
      else {
        element.src = element.src.replace('_hover', '').replace('_disabled', '');
      }
    }
  }
  return element;
});

Form.Element.disable = Form.Element.disable.wrap(function(){
  var args = $A(arguments), proceed = args.shift();
  var element = proceed.apply(this, args);

  element.addClassName('disabled');

  if (element.getAttribute('type') == 'image' && element.hasAttribute('key')) {
    // this is a special button that's already been instantiated as a ImageButton object
    element.addClassName('image_button_disabled');
    ButtonManager.alterStateOfButton(element.getAttribute('key'), 'disabled');
  } else {
    if (element.getAttribute('type') == 'image') {
      element.addClassName('image_button_disabled');

      if( element.getAttribute('data-image-disabled-url') ) {
        element.src = element.getAttribute('data-image-disabled-url');
      }
      else {
        element.src = element.src.replace('_hover', '').replace('_disabled', '');
        element.src = element.src.replace(/(-[a-z0-9]*)?\.gif/, '_disabled.gif');
      }
    }
  }
  return element;
});

var SortableTable = Class.create({
  initialize:function(table, manager, options) {
    this.table = $(table);
    this.thead = this.table.getElementsByTagName('thead')[0];
    this.tbody = this.table.getElementsByTagName('tbody')[0];
    this.options = Object.extend({
      clickable:       false,
      striped:         true,
      evenStripeClass: "stripe0",
      oddStripeClass:  "stripe1"
    }, options || {});

    this.sort_columns = $A(this.thead.getElementsByTagName('td')).collect(function(elem, index) {
      elem.sort_index = index;
      elem.ascending  = elem.className.include('sorted');

      if (Browser.IE6){
        Element.observe( elem, 'mouseover', function(e){ Event.findElement( e, 'td').addClassName( 'hover' ); } );
        Element.observe( elem, 'mouseout', function(e){ Event.findElement( e, 'td').removeClassName( 'hover' ); } );
      }
      Event.observe(elem, "click", this.sort_column.bindAsEventListener(this));
      return {
        sort_function: manager.sort_function(elem),
        node: elem
      };
    }.bind(this));
    this.current_sort_col = this.sort_columns[0].node;

    var trs = null;
    trs = this.cacheRows();

    if (this.options.clickable) {
      this.tbody.className = "clickable";
      // use event delegation to cut down on looping
      Event.observe(this.tbody, 'click', this.clickRowManager.bindAsEventListener(this));
    }

    if (Browser.IE6){
      // use event delegation to cut down on looping
      this.table.observe('mouseover', this.addHoverManager);
      this.table.observe('mouseout',  this.removeHoverManager);
    }

  },

  // cache all of the rows of the table (initialization primarily)
  cacheRows: function(){
    var trs   = [];
    this.rows = [];
    // raw loop for speed
    var rows = this.tbody.getElementsByTagName('tr');
    for (var i = 0, row; row == rows[i]; i++) {
      trs.push(row);
      var tds = row.getElementsByTagName('td'), cells = [];

      for (var j = 0, cell; cell == tds[j]; j++){
        var sf = null;
        var sort_col = null;

        sort_col = this.sort_columns[j];
        sf = sort_col.sort_function(cell);
        cells.push(sf);
      }

      this.rows.push({ sort_values: cells, node: row });
    }
    return trs;
  },

  // cache a single row.
  cacheRow: function(element, recache) {
    var cells = $A(element.getElementsByTagName("td")).collect(function(cell, index) {
      return this.sort_columns[index].sort_function(cell);
    }.bind(this));

    // look for the row in the cached rows
    found = false;
    this.rows.each( function( row ) {
      // if found, replace the sort_values and the element
      if( row.node == element){
        found = true;
        row.sort_values = cells;
      }
    }.bind(this));

    // If the row wasn't found, then it's new and we need to add it.
    // and also add listeners for clicks.
    if( !found ) {
      this.rows[this.rows.length] = {
        sort_values:cells,
        node:element
      };

      if (this.options.clickable) {
        Event.observe(element, 'click', this.clickRow.bindAsEventListener(this));
      }
      if (Browser.IE6){
        Event.observe(element, 'mouseover', this.addHoverManager);
        Event.observe(element, 'mouseout', this.removeHoverManager);
      }
    }
  },
  removeRow:function(row_to_remove){
    element = $(row_to_remove);
    element_to_select = element.next();

    var cached_row = null;
    this.rows.each( function(row){
      if( row.node == element ){
        cached_row = row;
      }
    }.bind(this));
    this.rows = this.rows.without( cached_row );
    Element.remove(element);
    // if the element was clicked, then select another row
    if( !element_to_select && this.rows.size() > 0){
      element_to_select = this.rows.first().node;
    }

    if( Element.hasClassName(element,'clicked') ){
      this.options.clickHandler( element_to_select );
    }
  },

  clickRow:function(event) {
    var clicked_element = Event.element(event);
    if(this.options.clickHandler && !clicked_element.tagName.toLowerCase().match(/input|a/)) {
      this.options.clickHandler(Event.findElement(event, 'tr'));
    }
  },
  selectRow:function(element) {
    this.options.clickHandler( $(element) );
  },

  clickRowManager: function(e) {
    var tr = e.findElement( 'tr'), element = e.element(), opt = this.options;
    if (!tr || !element) { return; }
    if (opt.clickHandler && !$w('INPUT A TBODY').include(element.tagName.toUpperCase())) { opt.clickHandler(tr); }
  },

  addHoverManager: function(e) {
    var element = e.findElement( 'tr');
    if (element && element.className && !element.className.include('hover')) { Element.addClassName(element, 'hover'); }
  },
  removeHoverManager: function(e) {
    var element = e.findElement( 'tr');
    if (element && element.className && element.className.include('hover')) { Element.removeClassName(element, 'hover'); }
  },
  headerMouseOver: function(e){
    var cell = e.findElement( 'td' );
    cell.addClassName( 'hover' );
  },
  headerMouseOut: function(e){
    var cell = e.findElement( 'td' );
    cell.removeClassName( 'hover' );
  },

  // Called when someone actually clicks on a column header
  sort_column:function(event) {
    var col = event.element();
    this.setSortDirection(col);
    this.do_sort(col);
  },

  // Method which actually performs the sort on a given column.
  do_sort:function( col ) {
    var result = this.rows.sortBy(function(row) {
      return row.sort_values[col.sort_index];
    });
    if( Element.hasClassName(col, "desc") ){
      result = result.reverse();
    }
    this.drawSortResult(result);
    this.current_sort_col = col;
  },

  // Refresh the sort without changing anything (call after a new row is added to the table)
  refresh_sort:function() {
    this.do_sort(this.current_sort_col);
  },

  setSortDirection:function(sorted_column) {
    sorted_column = sorted_column || this.current_sort_col;
    // using traditional loops b/c they're faster
    for (var i = 0, cell; i < this.sort_columns.length; i++) {
      cell = this.sort_columns[i].node;
      Element.extend(cell).removeClassName('sorted').removeClassName('asc').removeClassName('desc');
    }

    if (this.current_sort_col && this.current_sort_col !== sorted_column) {
      // don't toggle the sort direction -- just set the new column
      sorted_column.addClassName("sorted " + (sorted_column.ascending ? "asc" : "desc"));
    } else {
      sorted_column.addClassName("sorted " + (sorted_column.ascending ? "desc" : "asc"));
      sorted_column.ascending = !sorted_column.ascending;
    }
  },

  drawSortResult: function(result) {
    var opt = this.options, row, even;
    // using traditional loops b/c they're faster
    for (var index = 0, len = result.length; index < len; index++) {
      row = result[index].node;
      if (opt.striped) {
        even = (index % 2) === 0;
        if (even && Element.hasClassName(row, opt.oddStripeClass)) {
          row.className = row.className.replace(opt.oddStripeClass, opt.evenStripeClass);
        } else if (!even && Element.hasClassName(row, opt.evenStripeClass)) {
          row.className = row.className.replace(opt.evenStripeClass, opt.oddStripeClass);
        }
      }
      this.tbody.appendChild(row);
    }
  },

  destroy: function(){
    $A(this.thead.getElementsByTagName('td')).each(function(elem, index) {
      if ( Browser.IE6 ){
        Element.stopObserving( elem, 'mouseover', function(e){ e.findElement( 'td').addClassName( 'hover' ); } );
        Element.stopObserving( elem, 'mouseout', function(e){ e.findElement( 'td').removeClassName( 'hover' ); } );
      }
      Event.stopObserving(elem, "click", this.sort_column.bindAsEventListener(this));
    }.bind( this ));
    this.sort_columns = null;

    this.rows.each( function( element ){
      if (this.options.clickable) {
        Event.stopObserving(element, 'click', this.clickRow.bindAsEventListener(this));
      }
      if (Browser.IE6){
        Event.stopObserving(element, 'mouseover', this.addHoverManager);
        Event.stopObserving(element, 'mouseout', this.removeHoverManager);
      }
    }.bind( this ));

    if (this.options.clickable) {
      Event.stopObserving(this.tbody, 'click', this.clickRowManager.bindAsEventListener(this));
    }

    if (Browser.IE6){
      // use event delegation to cut down on looping
      this.table.stopObserving('mouseover', this.addHoverManager);
      this.table.stopObserving('mouseout',  this.removeHoverManager);
    }

    this.table = null;
    this.thead = null;
    this.tbody = null;
    this.rows = null;
  },
  isOrphaned: function(){
    return this.table.parentNode ? false : true;
  }
});

var SortableTableManager = {
  initialize: function(){
    document.observe('ajax:completed', this.ajaxOnComplete.bindAsEventListener(this));
    this._attachFresh();
  },
  register_sortables: function(){ this._attachFresh(); },
  ajaxOnComplete: function(){
    SortableTableManager._removeOrphaned();
    SortableTableManager._attachFresh();
  },
  _removeOrphaned: function(){
    SortableTableManager.registered_sortables.each(function(pair){
      if (pair.value.isOrphaned()){
        pair.value.destroy();
        SortableTableManager.registered_sortables.unset(pair.key);
      }
    });
  },
  _attachFresh: function(){
    if (!SortableTableManager.registered_tables) { SortableTableManager.registered_tables = []; }
    if (!SortableTableManager.registered_sortables) { SortableTableManager.registered_sortables = $H(); }

    $$('table.sortable').each(function(element) {
      if (!SortableTableManager.registered_tables.include(element)) {
        SortableTableManager.register_sortable(element);
        SortableTableManager.registered_tables.push(element);
      }
    }.bind(SortableTableManager));
  },
  register_sortable: function(element) {
    var options = {};
    var click_handler = element.className.match(/clickable:(.*) {0,1}.*/);
    if (click_handler) {
      options = {
        clickable: true,
        clickHandler: this.click_functions[click_handler[1]]
      };
    }
    SortableTableManager.registered_sortables.set(element, new SortableTable(element, this, options));
  },
  sort_function: function(element) {
    // We are expecting the className of the passed element to include a hint in the format
    // sort:(strategy). If we can't find the sort_function, assume string
    var className = null;
      className =  element.className.match(/sort:(\w*) {0,1}\w*/);
      className = className ? className[1] : "string";
      return this.sort_functions[className] || this.sort_functions.stringSort;
  },
  sort_functions: {
    stringSort: function(element) {
      return element.innerHTML.stripTags().toLowerCase();
    },

    versionSort: function(element) {
      var value = element.title || ""; // compare against the literal value
      if (value === "")  { return -1; }     // empty strings get sorted at the end

      // catch values like "v3.6.3" or "V 3.6.3"
      if ((/^\s*v\s*\d/i).test(value)) {
        value = value.substring(1, value.length);
      } else if (!(/^\d/).test(value)) {
        return 0;
      }

      // split it into tokens (["3", "6", "3"])
      var tokens = value.split('.').slice(0, 4);
      // pad it (["3", "6", "3", "00000"])
      while (tokens.length < 4) {
        tokens.push('00000');
      }
      tokens = tokens.map(function(token) {
        if (token.length > 5) {
          token = token.substring(0, 5);
        }

        // pad each token (["00003", "00006", "00003", "00000"])
        if (token.length < 5) {
          token = ('0').times(5 - token.length) + token;
        }
        return token;
      });

      // join it and convert it to a number (3000060000300000)
      return parseInt(tokens.join(''), 10);
    },

    full_name: function(element) {
      var sort_value = element.innerHTML.stripTags().toLowerCase();
      return sort_value.replace(/^(.*) (.*)$/, "$2 $1");
    },
    bytes: function(element) {
      var sort_value = element.innerHTML.stripTags().toLowerCase();
      var result = /^(.*) (k|m|g)B/i.exec(sort_value);
      if (result) {
        return parseFloat(result[1]) * (result[2] == "m" ? (1024 * 1024) : (result[2] == "g" ? (1024 * 1024 * 1024) : 1024));
      } else {
        return 0;
      }
    },
    numeric: function(element) {
      var sort_value = element.innerHTML.stripTags().toLowerCase();
      var result = parseFloat(sort_value.gsub(/\$/, '')); /* Strip out dollar sign for currency */
      // NaN values should return -1 so that they can be distinguished from 0
      return isNaN(result) ? -1 : result;
    },
    date: function(element) {
      if (element.getAttribute("millis")) {
        return new Date(parseInt(element.getAttribute("millis"), 10));
      }
      var sort_value = element.innerHTML;
      var date = sort_value.match(/(\d+)\/(\d+)\/(\d+) @ (\d+):(\d+)([ap]m)/);
      if(date){
        /* finder_date_time format */
        var hour = parseInt(date[4], 10);
        if(date[6] == 'pm'){hour += 12;}
        if(hour == 12 || hour == 24){hour -= 12;}
        return Date.UTC(date[3], date[1], date[2], hour, date[5], 0);
      }else{
        return Date.parse(sort_value.stripTags());
      }
    },
    ip_address: function(element) {
      var sort_value = element.innerHTML.stripTags();
      var result = sort_value.match(/(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/);
      if (result !== null) {
        result = result.slice(1).collect(function(elem, idx) {
          switch(elem.length) {
            case 1:
              return "00" + elem;
            case 2:
              return "0" + elem;
            default:
              return elem;
          }
        });
        return result.join(".");
      } else {
        return sort_value;
      }
    }
  },
  click_functions: {}
};

Event.register(SortableTableManager);

var DynamicScriptInclude = {
  load: function( source, nocache ){
    if ( !nocache ) { nocache = true; }
    this._remove( source );
    this._require( source, nocache );
  },
  _remove: function( source ){
    // find our special script and rip it out of the page
    $$( 'script[src]' ).each( function( s ){
      if ( s.src.indexOf( source ) > -1 ) { s.parentNode.removeChild( s ); }
    });
  },
  _require: function( source, nocache ){
    var js = document.createElement( 'script' );
    js.setAttribute( 'language', 'javascript' );
    js.setAttribute( 'type', 'text/javascript' );
    // append a querystring value that is always changing so this script is never cached
    source = ( source.match( /\?/ ) ? source + '&' : source + '?' ) + ( nocache ? 'nocache=' + new Date().getTime() + '&' : '' );
    js.setAttribute( 'src', source );
    $$( 'head' ).first().appendChild( js );
  }
};

Ajax.Responders.register({
  onCreate: function(request){
    document.fire('ajax:started', request); // fire a custom event when an ajax request is started
  },
  onComplete: function(request){
    document.fire('ajax:completed', request); // fire a custom event when an ajax request is completed for observers
  }
});
//  Date#strftime: http://hacks.bluesmoon.info/strftime/index.html
//  Copyright (c) 2008, Philip S Tellis <philip@bluesmoon.info>
//  All rights reserved.
//  This code is distributed under the terms of the BSD licence
//  
//  Redistribution and use of this software in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
// 
//    * Redistributions of source code must retain the above copyright notice, this list of conditions
//      and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of
//      conditions and the following disclaimer in the documentation and/or other materials provided
//      with the distribution.
//    * The names of the contributors to this file may not be used to endorse or promote products
//      derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
Date.ext={};Date.ext.util={};Date.ext.util.xPad=function(x,pad,r){if(typeof (r)=="undefined"){r=10}for(;parseInt(x,10)<r&&r>1;r/=10){x=pad.toString()+x}return x.toString()};Date.prototype.locale="en-GB";if(document.getElementsByTagName("html")&&document.getElementsByTagName("html")[0].lang){Date.prototype.locale=document.getElementsByTagName("html")[0].lang}Date.ext.locales={};Date.ext.locales.en={a:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],A:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],b:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],B:["January","February","March","April","May","June","July","August","September","October","November","December"],c:"%a %d %b %Y %T %Z",p:["AM","PM"],P:["am","pm"],x:"%d/%m/%y",X:"%T"};Date.ext.locales["en-US"]=Date.ext.locales.en;Date.ext.locales["en-US"].c="%a %d %b %Y %r %Z";Date.ext.locales["en-US"].x="%D";Date.ext.locales["en-US"].X="%r";Date.ext.locales["en-GB"]=Date.ext.locales.en;Date.ext.locales["en-AU"]=Date.ext.locales["en-GB"];Date.ext.formats={a:function(d){return Date.ext.locales[d.locale].a[d.getDay()]},A:function(d){return Date.ext.locales[d.locale].A[d.getDay()]},b:function(d){return Date.ext.locales[d.locale].b[d.getMonth()]},B:function(d){return Date.ext.locales[d.locale].B[d.getMonth()]},c:"toLocaleString",C:function(d){return Date.ext.util.xPad(parseInt(d.getFullYear()/100,10),0)},d:["getDate","0"],e:["getDate"," "],g:function(d){return Date.ext.util.xPad(parseInt(Date.ext.util.G(d)/100,10),0)},G:function(d){var y=d.getFullYear();var V=parseInt(Date.ext.formats.V(d),10);var W=parseInt(Date.ext.formats.W(d),10);if(W>V){y++}else{if(W===0&&V>=52){y--}}return y},H:["getHours","0"],I:function(d){var I=d.getHours()%12;return Date.ext.util.xPad(I===0?12:I,0)},j:function(d){var ms=d-new Date(""+d.getFullYear()+"/1/1 GMT");ms+=d.getTimezoneOffset()*60000;var doy=parseInt(ms/60000/60/24,10)+1;return Date.ext.util.xPad(doy,0,100)},m:function(d){return Date.ext.util.xPad(d.getMonth()+1,0)},M:["getMinutes","0"],p:function(d){return Date.ext.locales[d.locale].p[d.getHours()>=12?1:0]},P:function(d){return Date.ext.locales[d.locale].P[d.getHours()>=12?1:0]},S:["getSeconds","0"],u:function(d){var dow=d.getDay();return dow===0?7:dow},U:function(d){var doy=parseInt(Date.ext.formats.j(d),10);var rdow=6-d.getDay();var woy=parseInt((doy+rdow)/7,10);return Date.ext.util.xPad(woy,0)},V:function(d){var woy=parseInt(Date.ext.formats.W(d),10);var dow1_1=(new Date(""+d.getFullYear()+"/1/1")).getDay();var idow=woy+(dow1_1>4||dow1_1<=1?0:1);if(idow==53&&(new Date(""+d.getFullYear()+"/12/31")).getDay()<4){idow=1}else{if(idow===0){idow=Date.ext.formats.V(new Date(""+(d.getFullYear()-1)+"/12/31"))}}return Date.ext.util.xPad(idow,0)},w:"getDay",W:function(d){var doy=parseInt(Date.ext.formats.j(d),10);var rdow=7-Date.ext.formats.u(d);var woy=parseInt((doy+rdow)/7,10);return Date.ext.util.xPad(woy,0,10)},y:function(d){return Date.ext.util.xPad(d.getFullYear()%100,0)},Y:"getFullYear",z:function(d){var o=d.getTimezoneOffset();var H=Date.ext.util.xPad(parseInt(Math.abs(o/60),10),0);var M=Date.ext.util.xPad(o%60,0);return(o>0?"-":"+")+H+M},Z:function(d){return d.toString().replace(/^.*\(([^)]+)\)$/,"$1")},"%":function(d){return"%"}};Date.ext.aggregates={c:"locale",D:"%m/%d/%y",h:"%b",n:"\n",r:"%I:%M:%S %p",R:"%H:%M",t:"\t",T:"%H:%M:%S",x:"locale",X:"locale"};Date.ext.aggregates.z=Date.ext.formats.z(new Date());Date.ext.aggregates.Z=Date.ext.formats.Z(new Date());Date.ext.unsupported={};Date.prototype.strftime=function(fmt){if(!(this.locale in Date.ext.locales)){if(this.locale.replace(/-[a-zA-Z]+$/,"") in Date.ext.locales){this.locale=this.locale.replace(/-[a-zA-Z]+$/,"")}else{this.locale="en-GB"}}var d=this;while(fmt.match(/%[cDhnrRtTxXzZ]/)){fmt=fmt.replace(/%([cDhnrRtTxXzZ])/g,function(m0,m1){var f=Date.ext.aggregates[m1];return(f=="locale"?Date.ext.locales[d.locale][m1]:f)})}var str=fmt.replace(/%([aAbBCdegGHIjmMpPSuUVwWyY%])/g,function(m0,m1){var f=Date.ext.formats[m1];if(typeof (f)=="string"){return d[f]()}else{if(typeof (f)=="function"){return f.call(d,d)}else{if(typeof (f)=="object"&&typeof (f[0])=="string"){return Date.ext.util.xPad(d[f[0]](),f[1])}else{return m1}}}});d=null;return str};
// https://github.com/mstum/TimeSpan.js
"use strict";(function(){var a=window.TimeSpan=function(g,i,h,j,k){var l="1.2",d=1e3,c=6e4,e=3.6e6,f=8.64e7,a=0,b=function(a){return !isNaN(parseFloat(a))&&isFinite(a)};if(b(k))a+=k*f;if(b(j))a+=j*e;if(b(h))a+=h*c;if(b(i))a+=i*d;if(b(g))a+=g;this.addMilliseconds=function(c){if(!b(c))return;a+=c};this.addSeconds=function(c){if(!b(c))return;a+=c*d};this.addMinutes=function(d){if(!b(d))return;a+=d*c};this.addHours=function(c){if(!b(c))return;a+=c*e};this.addDays=function(c){if(!b(c))return;a+=c*f};this.subtractMilliseconds=function(c){if(!b(c))return;a-=c};this.subtractSeconds=function(c){if(!b(c))return;a-=c*d};this.subtractMinutes=function(d){if(!b(d))return;a-=d*c};this.subtractHours=function(c){if(!b(c))return;a-=c*e};this.subtractDays=function(c){if(!b(c))return;a-=c*f};this.isTimeSpan=true;this.add=function(b){if(!b.isTimeSpan)return;a+=b.totalMilliseconds()};this.subtract=function(b){if(!b.isTimeSpan)return;a-=b.totalMilliseconds()};this.equals=function(b){if(!b.isTimeSpan)return;return a===b.totalMilliseconds()};this.totalMilliseconds=function(c){var b=a;if(c===true)b=Math.floor(b);return b};this.totalSeconds=function(c){var b=a/d;if(c===true)b=Math.floor(b);return b};this.totalMinutes=function(d){var b=a/c;if(d===true)b=Math.floor(b);return b};this.totalHours=function(c){var b=a/e;if(c===true)b=Math.floor(b);return b};this.totalDays=function(c){var b=a/f;if(c===true)b=Math.floor(b);return b};this.milliseconds=function(){return a%1e3};this.seconds=function(){return Math.floor(a/d)%60};this.minutes=function(){return Math.floor(a/c)%60};this.hours=function(){return Math.floor(a/e)%24};this.days=function(){return Math.floor(a/f)};this.getVersion=function(){return l}};a.FromSeconds=function(b){return new a(0,b,0,0,0)};a.FromMinutes=function(b){return new a(0,0,b,0,0)};a.FromHours=function(b){return new a(0,0,0,b,0)};a.FromDays=function(b){return new a(0,0,0,0,b)};a.FromDates=function(e,d,c){var b=d.valueOf()-e.valueOf();if(c===true)b=Math.abs(b);return new a(b,0,0,0,0)}})()

TimeSpan.prototype.prettyPrintTime = function(showSeconds){
	var str = "";
	var unit = "";
	if(this.days() > 0){
		unit = (this.days() > 1) ? " days " : " day ";
		str += this.days() + unit;
	}
	unit = (this.hours() > 1) ? " hours " : " hour ";
	str += this.hours() + unit;
	unit = (this.minutes() > 1) ? " mins" : " min";
	str += this.minutes() + unit;
	if(showSeconds){
		unit = (this.seconds() > 1) ? " secs" : " sec";
		str += " " + this.seconds() + unit;
	}
	return str;
}

TimeSpan.prototype.prettyPrintAbbrTime = function(showSeconds){
	var str = "";
	if(this.days() > 0){
		var dys = (this.days() > 1) ? " days " : " day ";
		str += this.days() + dys;
	}
	str += this.formatValue(this.hours()) + ":";
	str += this.formatValue(this.minutes());
	if(showSeconds){
		str += ":" + this.formatValue(this.seconds());
	}
	return str;
}

TimeSpan.prototype.printTime = function(showSeconds){
	var str = "";
	if(this.days() > 0){
		str += this.days() + ":";
	}
	str += this.formatValue(this.hours()) + ":";
	str += this.formatValue(this.minutes());
	if(showSeconds){
		str += ":" + this.formatValue(this.seconds());
	}
	return str;
}

TimeSpan.prototype.formatValue = function(val){
	if(val < 10){
		return "0" + val;
	} else {
		return val;
	}
}
;
// -----------------------------------------------------------------------------------
//
//	Lightbox v2.04
//	by Lokesh Dhakar - http://www.lokeshdhakar.com
//	Last Modification: 2/9/08
//
//	For more information, visit:
//	http://lokeshdhakar.com/projects/lightbox2/
//
//	Licensed under the Creative Commons Attribution 2.5 License - http://creativecommons.org/licenses/by/2.5/
//  	- Free for use in both personal and commercial projects
//		- Attribution requires leaving author name, author link, and the license info intact.
//	
//  Thanks: Scott Upton(uptonic.com), Peter-Paul Koch(quirksmode.com), and Thomas Fuchs(mir.aculo.us) for ideas, libs, and snippets.
//  		Artemy Tregubenko (arty.name) for cleanup and help in updating to latest ver of proto-aculous.
//
// -----------------------------------------------------------------------------------
/*

    Table of Contents
    -----------------
    Configuration

    Lightbox Class Declaration
    - initialize()
    - updateImageList()
    - start()
    - changeImage()
    - resizeImageContainer()
    - showImage()
    - updateDetails()
    - updateNav()
    - enableKeyboardNav()
    - disableKeyboardNav()
    - keyboardAction()
    - preloadNeighborImages()
    - end()
    
    Function Calls
    - document.observe()
   
*/
// -----------------------------------------------------------------------------------

//
//  Configurationl
//
LightboxOptions = Object.extend({
    fileLoadingImage:        '//static.spiceworks.com/assets/community/lightbox/loading-329cf294d8d48d231cf9e07fd60e3ae6.gif',
    fileBottomNavCloseImage: '//static.spiceworks.com/assets/community/lightbox/closelabel-05a28e38fe9755501dff6be09b0249e4.gif',

    overlayOpacity: 0.5,   // controls transparency of shadow overlay

    animate: true,         // toggles resizing animations
    resizeSpeed: 10,        // controls the speed of the image resizing animations (1=slowest and 10=fastest)

    borderSize: 10,         //if you adjust the padding in the CSS, you will need to update this variable

	// When grouping images this is used to write: Image # of #.
	// Change it for non-english localization
	labelImage: "Image",
	labelOf: "of"
}, window.LightboxOptions || {});

// -----------------------------------------------------------------------------------

var Lightbox = Class.create({
    imageArray: [],
    activeImage: undefined,
    
    // initialize()
    // Constructor runs on completion of the DOM loading. Calls updateImageList and then
    // the function inserts html at the bottom of the page which is used to display the shadow 
    // overlay and the image container.
    //
    initialize: function() {    
        
        this.updateImageList();
        
        this.keyboardAction = this.keyboardAction.bindAsEventListener(this);

        if (LightboxOptions.resizeSpeed > 10) LightboxOptions.resizeSpeed = 10;
        if (LightboxOptions.resizeSpeed < 1)  LightboxOptions.resizeSpeed = 1;

	    this.resizeDuration = LightboxOptions.animate ? ((11 - LightboxOptions.resizeSpeed) * 0.15) : 0;
	    this.overlayDuration = LightboxOptions.animate ? 0.2 : 0;  // shadow fade in/out duration

        // When Lightbox starts it will resize itself from 250 by 250 to the current image dimension.
        // If animations are turned off, it will be hidden as to prevent a flicker of a
        // white 250 by 250 box.
        var size = (LightboxOptions.animate ? 250 : 1) + 'px';
        

        // Code inserts html at the bottom of the page that looks similar to this:
        //
        //  <div id="overlay"></div>
        //  <div id="lightbox">
        //      <div id="outerImageContainer">
        //          <div id="imageContainer">
        //              <img id="lightboxImage">
        //              <div style="" id="hoverNav">
        //                  <a href="#" id="prevLink"></a>
        //                  <a href="#" id="nextLink"></a>
        //              </div>
        //              <div id="loading">
        //                  <a href="#" id="loadingLink">
        //                      <img src="images/loading.gif">
        //                  </a>
        //              </div>
        //          </div>
        //      </div>
        //      <div id="imageDataContainer">
        //          <div id="imageData">
        //              <div id="imageDetails">
        //                  <span id="caption"></span>
        //                  <span id="numberDisplay"></span>
        //              </div>
        //              <div id="bottomNav">
        //                  <a href="#" id="bottomNavClose">
        //                      <img src="images/close.gif">
        //                  </a>
        //              </div>
        //          </div>
        //      </div>
        //  </div>


        var objBody = $$('body')[0];

		objBody.appendChild(Builder.node('div',{id:'overlay'}));
	
        objBody.appendChild(Builder.node('div',{id:'lightbox'}, [
            Builder.node('div',{id:'outerImageContainer'}, 
                Builder.node('div',{id:'imageContainer'}, [
                    Builder.node('img',{id:'lightboxImage'}), 
                    Builder.node('div',{id:'hoverNav'}, [
                        Builder.node('a',{id:'prevLink', href: '#' }),
                        Builder.node('a',{id:'nextLink', href: '#' })
                    ]),
                    Builder.node('div',{id:'loading'}, 
                        Builder.node('a',{id:'loadingLink', href: '#' }, 
                            Builder.node('img', {src: LightboxOptions.fileLoadingImage})
                        )
                    )
                ])
            ),
            Builder.node('div', {id:'imageDataContainer'},
                Builder.node('div',{id:'imageData'}, [
                    Builder.node('div',{id:'imageDetails'}, [
                        Builder.node('span',{id:'caption'}),
                        Builder.node('span',{id:'numberDisplay'})
                    ]),
                    Builder.node('div',{id:'bottomNav'},
                        Builder.node('a',{id:'bottomNavClose', href: '#' },
                            Builder.node('img', { src: LightboxOptions.fileBottomNavCloseImage })
                        )
                    )
                ])
            )
        ]));


		$('overlay').hide().observe('click', (function() { this.end(); }).bind(this));
		$('lightbox').hide().observe('click', (function(event) { if (event.element().id == 'lightbox') this.end(); }).bind(this));
		$('outerImageContainer').setStyle({ width: size, height: size });
		$('prevLink').observe('click', (function(event) { event.stop(); this.changeImage(this.activeImage - 1); }).bindAsEventListener(this));
		$('nextLink').observe('click', (function(event) { event.stop(); this.changeImage(this.activeImage + 1); }).bindAsEventListener(this));
		$('loadingLink').observe('click', (function(event) { event.stop(); this.end(); }).bind(this));
		$('bottomNavClose').observe('click', (function(event) { event.stop(); this.end(); }).bind(this));

        var th = this;
        (function(){
            var ids = 
                'overlay lightbox outerImageContainer imageContainer lightboxImage hoverNav prevLink nextLink loading loadingLink ' + 
                'imageDataContainer imageData imageDetails caption numberDisplay bottomNav bottomNavClose';   
            $w(ids).each(function(id){ th[id] = $(id); });
        }).defer();
    },

    //
    // updateImageList()
    // Loops through anchor tags looking for 'lightbox' references and applies onclick
    // events to appropriate links. You can rerun after dynamically adding images w/ajax.
    //
    updateImageList: function() {   
        this.updateImageList = Prototype.emptyFunction;

        document.observe('click', (function(event){
            var target = event.findElement('a[rel^=lightbox]') || event.findElement('area[rel^=lightbox]');
            if (target) {
                event.stop();
                this.start(target);
            }
        }).bind(this));
    },
    
    //
    //  start()
    //  Display overlay and lightbox. If image is part of a set, add siblings to imageArray.
    //
    start: function(imageLink) {    

        $$('select', 'object', 'embed').each(function(node){ node.style.visibility = 'hidden' });

        // stretch overlay to fill page and fade in
        var arrayPageSize = this.getPageSize();
        $('overlay').setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' });

        new Effect.Appear(this.overlay, { duration: this.overlayDuration, from: 0.0, to: LightboxOptions.overlayOpacity });

        this.imageArray = [];
        var imageNum = 0;       

        if ((imageLink.rel == 'lightbox')){
            // if image is NOT part of a set, add single image to imageArray
            this.imageArray.push([imageLink.href, imageLink.title]);         
        } else {
            // if image is part of a set..
            this.imageArray = 
                $$(imageLink.tagName + '[href][rel="' + imageLink.rel + '"]').
                collect(function(anchor){ return [anchor.href, anchor.title]; }).
                uniq();
            
            while (this.imageArray[imageNum][0] != imageLink.href) { imageNum++; }
        }

        // calculate top and left offset for the lightbox 
        var arrayPageScroll = document.viewport.getScrollOffsets();
        var lightboxTop = arrayPageScroll[1] + (document.viewport.getHeight() / 10);
        var lightboxLeft = arrayPageScroll[0];
        this.lightbox.setStyle({ top: lightboxTop + 'px', left: lightboxLeft + 'px' }).show();
        
        this.changeImage(imageNum);
    },

    //
    //  changeImage()
    //  Hide most elements and preload image in preparation for resizing image container.
    //
    changeImage: function(imageNum) {   
        
        this.activeImage = imageNum; // update global var

        // hide elements during transition
        if (LightboxOptions.animate) this.loading.show();
        this.lightboxImage.hide();
        this.hoverNav.hide();
        this.prevLink.hide();
        this.nextLink.hide();
		// HACK: Opera9 does not currently support scriptaculous opacity and appear fx
        this.imageDataContainer.setStyle({opacity: .0001});
        this.numberDisplay.hide();      
        
        var imgPreloader = new Image();
        
        // once image is preloaded, resize image container


        imgPreloader.onload = (function(){
            this.lightboxImage.src = this.imageArray[this.activeImage][0];
            this.resizeImageContainer(imgPreloader.width, imgPreloader.height);
        }).bind(this);
        imgPreloader.src = this.imageArray[this.activeImage][0];
    },

    //
    //  resizeImageContainer()
    //
    resizeImageContainer: function(imgWidth, imgHeight) {

        // get current width and height
        var widthCurrent  = this.outerImageContainer.getWidth();
        var heightCurrent = this.outerImageContainer.getHeight();

        // get new width and height
        var widthNew  = (imgWidth  + LightboxOptions.borderSize * 2);
        var heightNew = (imgHeight + LightboxOptions.borderSize * 2);

        // scalars based on change from old to new
        var xScale = (widthNew  / widthCurrent)  * 100;
        var yScale = (heightNew / heightCurrent) * 100;

        // calculate size difference between new and old image, and resize if necessary
        var wDiff = widthCurrent - widthNew;
        var hDiff = heightCurrent - heightNew;

        if (hDiff != 0) new Effect.Scale(this.outerImageContainer, yScale, {scaleX: false, duration: this.resizeDuration, queue: 'front'}); 
        if (wDiff != 0) new Effect.Scale(this.outerImageContainer, xScale, {scaleY: false, duration: this.resizeDuration, delay: this.resizeDuration}); 

        // if new and old image are same size and no scaling transition is necessary, 
        // do a quick pause to prevent image flicker.
        var timeout = 0;
        if ((hDiff == 0) && (wDiff == 0)){
            timeout = 100;
            if (Prototype.Browser.IE) timeout = 250;   
        }

        (function(){
            this.prevLink.setStyle({ height: imgHeight + 'px' });
            this.nextLink.setStyle({ height: imgHeight + 'px' });
            this.imageDataContainer.setStyle({ width: widthNew + 'px' });

            this.showImage();
        }).bind(this).delay(timeout / 1000);
    },
    
    //
    //  showImage()
    //  Display image and begin preloading neighbors.
    //
    showImage: function(){
        this.loading.hide();
        new Effect.Appear(this.lightboxImage, { 
            duration: this.resizeDuration, 
            queue: 'end', 
            afterFinish: (function(){ this.updateDetails(); }).bind(this) 
        });
        this.preloadNeighborImages();
    },

    //
    //  updateDetails()
    //  Display caption, image number, and bottom nav.
    //
    updateDetails: function() {
    
        // if caption is not null
        if (this.imageArray[this.activeImage][1] != ""){
            this.caption.update(this.imageArray[this.activeImage][1]).show();
        }
        
        // if image is part of set display 'Image x of x' 
        if (this.imageArray.length > 1){
            this.numberDisplay.update( LightboxOptions.labelImage + ' ' + (this.activeImage + 1) + ' ' + LightboxOptions.labelOf + '  ' + this.imageArray.length).show();
        }

        new Effect.Parallel(
            [ 
                new Effect.SlideDown(this.imageDataContainer, { sync: true, duration: this.resizeDuration, from: 0.0, to: 1.0 }), 
                new Effect.Appear(this.imageDataContainer, { sync: true, duration: this.resizeDuration }) 
            ], 
            { 
                duration: this.resizeDuration, 
                afterFinish: (function() {
	                // update overlay size and update nav
	                var arrayPageSize = this.getPageSize();
	                this.overlay.setStyle({ height: arrayPageSize[1] + 'px' });
	                this.updateNav();
                }).bind(this)
            } 
        );
    },

    //
    //  updateNav()
    //  Display appropriate previous and next hover navigation.
    //
    updateNav: function() {

        this.hoverNav.show();               

        // if not first image in set, display prev image button
        if (this.activeImage > 0) this.prevLink.show();

        // if not last image in set, display next image button
        if (this.activeImage < (this.imageArray.length - 1)) this.nextLink.show();
        
        this.enableKeyboardNav();
    },

    //
    //  enableKeyboardNav()
    //
    enableKeyboardNav: function() {
        document.observe('keydown', this.keyboardAction); 
    },

    //
    //  disableKeyboardNav()
    //
    disableKeyboardNav: function() {
        document.stopObserving('keydown', this.keyboardAction); 
    },

    //
    //  keyboardAction()
    //
    keyboardAction: function(event) {
        var keycode = event.keyCode;

        var escapeKey;
        if (event.DOM_VK_ESCAPE) {  // mozilla
            escapeKey = event.DOM_VK_ESCAPE;
        } else { // ie
            escapeKey = 27;
        }

        var key = String.fromCharCode(keycode).toLowerCase();
        
        if (key.match(/x|o|c/) || (keycode == escapeKey)){ // close lightbox
            this.end();
        } else if ((key == 'p') || (keycode == 37)){ // display previous image
            if (this.activeImage != 0){
                this.disableKeyboardNav();
                this.changeImage(this.activeImage - 1);
            }
        } else if ((key == 'n') || (keycode == 39)){ // display next image
            if (this.activeImage != (this.imageArray.length - 1)){
                this.disableKeyboardNav();
                this.changeImage(this.activeImage + 1);
            }
        }
    },

    //
    //  preloadNeighborImages()
    //  Preload previous and next images.
    //
    preloadNeighborImages: function(){
        var preloadNextImage, preloadPrevImage;
        if (this.imageArray.length > this.activeImage + 1){
            preloadNextImage = new Image();
            preloadNextImage.src = this.imageArray[this.activeImage + 1][0];
        }
        if (this.activeImage > 0){
            preloadPrevImage = new Image();
            preloadPrevImage.src = this.imageArray[this.activeImage - 1][0];
        }
    
    },

    //
    //  end()
    //
    end: function() {
        this.disableKeyboardNav();
        this.lightbox.hide();
        new Effect.Fade(this.overlay, { duration: this.overlayDuration });
        $$('select', 'object', 'embed').each(function(node){ node.style.visibility = 'visible' });
    },

    //
    //  getPageSize()
    //
    getPageSize: function() {
	        
	     var xScroll, yScroll;
		
		if (window.innerHeight && window.scrollMaxY) {	
			xScroll = window.innerWidth + window.scrollMaxX;
			yScroll = window.innerHeight + window.scrollMaxY;
		} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
			xScroll = document.body.scrollWidth;
			yScroll = document.body.scrollHeight;
		} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
			xScroll = document.body.offsetWidth;
			yScroll = document.body.offsetHeight;
		}
		
		var windowWidth, windowHeight;
		
		if (self.innerHeight) {	// all except Explorer
			if(document.documentElement.clientWidth){
				windowWidth = document.documentElement.clientWidth; 
			} else {
				windowWidth = self.innerWidth;
			}
			windowHeight = self.innerHeight;
		} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
		} else if (document.body) { // other Explorers
			windowWidth = document.body.clientWidth;
			windowHeight = document.body.clientHeight;
		}	
		
		// for small pages with total height less then height of the viewport
		if(yScroll < windowHeight){
			pageHeight = windowHeight;
		} else { 
			pageHeight = yScroll;
		}
	
		// for small pages with total width less then width of the viewport
		if(xScroll < windowWidth){	
			pageWidth = xScroll;		
		} else {
			pageWidth = windowWidth;
		}

		return [pageWidth,pageHeight];
	}
});

document.observe('dom:loaded', function () { new Lightbox(); });
var GoogleAnalytics = (function(){
  var track = function(){
    if(window._gaq){
      // turn arguments into an array, then flatten
      window._gaq.push(jQuery.map(jQuery.makeArray(arguments), function(n) {
        return n;
      }));
    }
  };

  return {
    setGroup:function(name){
      track('_setCustomVar', 1, 'Group', name, 3);
    },
    setUserType:function(userClass){
      track('_setCustomVar', 2, 'User type', userClass, 2);
    },
    setAppVersion:function(appVersion){
      track('_setCustomVar', 3, 'App version', appVersion, 2);
    },
    setPepperLevel:function(pepperLevel){
      track('_setCustomVar', 4, 'Pepper Level', pepperLevel, 2);
    },
    setHomePageType:function(homePageType){
      track('_setCustomVar', 5, 'Home Page Type', homePageType, 3);
    },
    trackPageview: function(page) {
      if(window._gaq) {
        window._gaq.push(['_trackPageview', page]);
      }
    },
    trackEvent:_.bind(track, {}, '_trackEvent')
  };
})();
/**************
 * Global Namespace for all spiceworks stuff
 * THIS FILE SHOULD BE LOADED FIRST SINCE WE LOAD IN ALPHA ORDER (ignoring .js)
 */

var SPICEWORKS = {};

if (document.location.toString().match(/logEvents/)) {
  SPICEWORKS.logEvents = true;
}

// JSLINT - The following statement will allow this file to pass the jslint tests by adding a couple of global variables
/*global Element, $, $$, Event, GMap2, Ajax */

// Create a closure, passing in the global namespace (SPICEWORKS) to a local variable (spiceworks)
(function (spiceworks) {

  // Spiceworks Events
  // Register for events that might be occuring
  // Passes through to the browser event code (prototype) for now, but by change in the future
  spiceworks.observe = function (event, func) {
    Event.observe(document, 'spiceworks:' + event, func);
  };

  spiceworks.stopObserving = function (event, func) {
    Event.stopObserving(document, 'spiceworks:' + event, func);
  };

  // catch the loaded event so we'll know that we're ready to go.
  spiceworks.isReady = false;

  // Fire an event within the spiceworks infrastructure.
  // the event name is currently attacted to the DOM.
  // "spiceworks:" will be prepended to all events
  // immediate will force the event to fire even if the page is not "ready" (dom fully loaded).
  // By default, events will be queued up until the document is fully loaded
  // there is (currently) no guarentee on the order that events will be fired once added (FF and IE are different)
  spiceworks.fire = function (event, memo) {
    memo = memo || {};

    if (event == 'ready') {
      spiceworks.isReady = true;
    }

    // if the page is not ready, then try again once the page is ready.
    if (spiceworks.isReady || memo.immediate) {

      if (spiceworks.logEvents){
        console.log(' [Fire] ' + event + '  ' + Object.toJSON(memo));
      }
      document.fire('spiceworks:' + event, memo);
    } else {
      if (spiceworks.logEvents){
        console.log('[Delay] ' + event + '  ' + Object.toJSON(memo));
      }
      spiceworks.ready(function () { spiceworks.fire(event, memo); });
    }
  };

  // This is called once all plugins are given the chance to load.  Use this if you depend on something in another plugin.
  // If this app is already loaded, then the function will be called immediately (unless onLoadOnly is passed as true).
  spiceworks.ready = function (func, loadOnly) {
    if (spiceworks.isReady && !loadOnly) {
      func(); // app already initialized, so let's just call the method.
    } else {
      spiceworks.observe('ready', func);
    }
  };

  // Helper function to define spiceworks observer functions
  spiceworks.ready_func = function(event) {
    return function( callback ) {
      spiceworks.observe(event, callback);
    };
  };

  // Create an object which derives from another object.
  // See: http://javascript.crockford.com/prototypal.html
  if (typeof Object.create !== 'function') {
      Object.create = function (o) {
          function F() {}
          F.prototype = o;
          return new F();
      };
  }

  // == SPICEWORKS.config ==
  // placeholder for configuration options  // see _script_includes.html.erb for more info on how this gets setup.
  spiceworks.config = {};

  Event.observe(document, 'dom:loaded', function (e) {
    spiceworks.fire('ready');
  });

})(SPICEWORKS);

// Moved from app.js so some SPICEWORKS objects can use it.

var Cookie = {
  get: function( name ){
    var nameEQ = escape(name) + "=", ca = document.cookie.split(';');
    for (var i = 0, c; i < ca.length; i++) {
      c = ca[i];
      while (c.charAt(0) == ' ') { c = c.substring(1, c.length); }
      if (c.indexOf(nameEQ) === 0) { return c.substring(nameEQ.length, c.length); }
    }
    return null;
  },
  set: function( name, value, options ){
    options = (options || {});
    if ( options.expiresInOneYear ){
      var today = new Date();
      today.setFullYear(today.getFullYear()+1, today.getMonth, today.getDay());
      options.expires = today;
    }
    var curCookie = escape(name) + "=" + escape(value) +
      ((options.expires) ? "; expires=" + options.expires.toGMTString() : "") +
      ((options.path)    ? "; path="    + options.path : "") +
      ((options.domain)  ? "; domain="  + options.domain : "") +
      ((options.secure)  ? "; secure" : "");
    document.cookie = curCookie;
  },
  removeCookie: function ( key, options ) {
    options = (options || {});
    var date = new Date();
    date.setTime(date.getTime()-(1*24*60*60*1000));
    options.expires = date;
    this.set(key, '', options);
  },
  hasCookie: function( name ){
    return document.cookie.indexOf( escape(name) ) > -1;
  },
  checkSupport: function(){
    return this.hasCookie('compatibility_test');
  }
};

(function (spiceworks) {

  // == App Namespace ==
  spiceworks.app = function () {
    var that, userMethods;

    that = {
      linkTo: function(path, options){
          return new Element('a', Object.extend({ 'href': path }, options || {}));
      },
      ready: function (func) {
        spiceworks.observe('app:ready', func);
      },

      isShowing: function () {
        return $(document.body).hasClassName('spiceworks_application');
      },

      setUser: function (user) {
        that.user = user;
      }
    };
    return that;
  }();

})(SPICEWORKS);
(function (spiceworks) {

  // == SPICEWORKS.app.navigation ==
  // define new tools (i.e. pages) that will be shown when the user clicks on them.

  spiceworks.app.navigation = function () {
    var items = [],
        menuItems = [],
        that;

    that = {
      addItem: function (item) {
        items.push(item);
      },

      // Show the specified tool
      showItem: function (name) {
        var content, item;
        item = items.find(function (item) {
          return (item.name === name);
        });

        content = $('content');
        content.innerHTML = '';

        item.update(content);
        document.title = 'Spiceworks - ' + item.label;
      },

      getItems: function () {
        return items;
      },

      addMenuItem: function (spec) {
        menuItems.push(spec);
      },

      addMenuItems: function (spec) {
        that.addMenuItem(spec);
      },

      updateNavMenus: function () {
        items.each(function(i) {
          addItemToToolsMenu(i);
        });
      },

      addSubMenu: function(menuItem, spec) {
        if (!$(menuItem)) { return; }

        var self = {};
        var menuLoaded, loadTimeout, menu, container;
        var loader = new Element('a', {href: '#', 'class':'loader', 'onclick': 'return false;'});

        $(menuItem).insert(loader);
        $(menuItem).addClassName('submenu');

        function onOver() {
          loadTimeout = window.setTimeout(function() {
            if (self.loaded) {
              // Only show it on hover, don't hide it.
              $(menuItem).addClassName("submenu-open");
            }
            else {
              $(menuItem).addClassName("submenu-open");

              loadMenu();
            }
          }, 300);
        }
        function onOut() {
          window.clearTimeout(loadTimeout);
        }
        function onMouseClick() {
          window.clearTimeout(loadTimeout);
          if (self.loaded) {
            $(menuItem).toggleClassName("submenu-open");
          }
          else {
            loadMenu();
          }
        }
        function loadMenu() {
          spec.onLoad(self);
        }

        self.buildMenu = function(items) {
          container = new Element('div', {'class': 'submenu'});
          menu = new Element('ul', {'class': 'submenu'});
          items.each(function(item) {
            menu.insert(new Element('li').insert(item));
          });

          container.insert(menu);
          $(menuItem).insert(container);
          $(menuItem).addClassName("submenu-open");
          self.loaded = true;
        };

        loader.observe("mouseover", onOver);
        loader.observe("mouseout", onOut);
        loader.observe("click", onMouseClick);
      }
    };

    // Attach the menu items once the app is ready.
    // This is also done in _customizable_sections.html.erb
    // It's fine to call this twice, it figures out what to do.
    spiceworks.app.ready(that.updateNavMenus);

    return that;
  }();

})(SPICEWORKS);
(function (spiceworks) {

  // == SPICEWORKS.community ==
  // Namespace for several APIs to pull down community content as JSON
  spiceworks.community = function () {
    var that;
    function fireCallback(callback, data){
      if(Object.isFunction(callback)){
        callback(data);
      } else {
        window[callback](data);
      }
    }

    that = {
      loadJSON: function(path, params, callback, identifier){
        var request = new Ajax.Request(path, {
          method: 'get',
          parameters: params,
          onSuccess: function(transport) {
            fireCallback(callback, transport.responseJSON);
          },
          onFailure: function(transport){
            fireCallback(callback, {'error':true});
          },
          onException: function(transport, exception){
            fireCallback(callback, {'error':true});
            throw exception;
          }
        });
      },
      url: function(path){
        return path;
      },
      linkTo: function(path, source, campaign){
        return new Element('a', { 'href': path });
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.products ==
  // Get product information and community content by sending up model and manufacturer
  spiceworks.community.products = function () {
    var that;
    that = {
      getProductData: function(params, callback){
        spiceworks.community.loadJSON('/api/products/product_data.json', params, callback);
      },
      getRecentRatings: function(params, callback, identifier){
        if(identifier){
          identifier += '_getRecentRatings';
        }
        spiceworks.community.loadJSON('/api/products/recent_ratings.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.forums ==
  // Get discussions from forums
  spiceworks.community.forums = function () {
    var that;
    that = {
      find: function(id, params, callback, identifier){
        if(identifier){
          identifier += '_community.forums.find/' + id;
        }
        spiceworks.community.loadJSON('/api/forums/' + id + '.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.itNews ==
  // Get the latest links posted to the Shared Links sections
  spiceworks.community.itNews = function () {
    var that;
    that = {
      find: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.itNews.find';
        }
        spiceworks.community.loadJSON('/api/it_news.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.groups ==
  // Get discussions, how-tos, spicelists, etc. from groups
  // id may be an integer or a case-insensitive name
  spiceworks.community.groups = function () {
    var that;
    that = {
      find: function(id, params, callback, identifier){
        if(identifier){
          identifier += '_community.groups.find/' + id;
        }
        spiceworks.community.loadJSON('/api/groups/' + id + '.json', params, callback, identifier);
      },
      my: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.groups.my';
        }
        spiceworks.community.loadJSON('/api/groups/user.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.plugins ==
  // Get information about plugins that enhance your Spiceworks application
  spiceworks.community.plugins = function () {
    var that;
    that = {
      find: function(guid, params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.find/' + guid;
        }
        spiceworks.community.loadJSON('/api/plugins/show/' + guid + '.json', params, callback, identifier);
      },
      recent: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.recent';
        }
        spiceworks.community.loadJSON('/api/plugins/recent.json', params, callback, identifier);
      },
      topRated: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.topRated';
        }
        spiceworks.community.loadJSON('/api/plugins/top_rated.json', params, callback, identifier);
      },
      topDownloaded: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.topDownloaded';
        }
        spiceworks.community.loadJSON('/api/plugins/top_downloaded.json', params, callback, identifier);
      },
      featured: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.featured';
        }
        spiceworks.community.loadJSON('/api/plugins/featured.json', params, callback, identifier);
      },
      my: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.plugins.my';
        }
        spiceworks.community.loadJSON('/api/plugins/user.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.languagePacks ==
  // Get information about language packs for translating the Spiceworks interface.
  spiceworks.community.languagePacks = function () {
    var that;
    that = {
      find: function(guid, params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.find/' + guid;
        }
        spiceworks.community.loadJSON('/api/language_packs/show/' + guid + '.json', params, callback, identifier);
      },
      recent: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.recent';
        }
        spiceworks.community.loadJSON('/api/language_packs/recent.json', params, callback, identifier);
      },
      topRated: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.topRated';
        }
        spiceworks.community.loadJSON('/api/language_packs/top_rated.json', params, callback, identifier);
      },
      topDownloaded: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.topDownloaded';
        }
        spiceworks.community.loadJSON('/api/language_packs/top_downloaded.json', params, callback, identifier);
      },
      featured: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.featured';
        }
        spiceworks.community.loadJSON('/api/language_packs/featured.json', params, callback, identifier);
      },
      my: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.languagePacks.my';
        }
        spiceworks.community.loadJSON('/api/language_packs/user.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.messages ==
  // Retrieve information about a user's private messages from the community.
  spiceworks.community.messages = function () {
    var that;
    that = {
      inbox: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.messages.inbox';
        }
        spiceworks.community.loadJSON('/api/messages/inbox.json', params, callback, identifier);
      },
      unreadCount: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.messages.unreadCount';
        }
        spiceworks.community.loadJSON('/api/messages/unread_count.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.reports ==
  // Get information about shared reports from the Spiceworks Community.
  spiceworks.community.reports = function () {
    var that;
    that = {
      find: function(id, params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.find/' + id;
        }
        spiceworks.community.loadJSON('/api/reports/show/' + id + '.json', params, callback, identifier);
      },
      recent: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.recent';
        }
        spiceworks.community.loadJSON('/api/reports/recent.json', params, callback, identifier);
      },
      topRated: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.topRated';
        }
        spiceworks.community.loadJSON('/api/reports/top_rated.json', params, callback, identifier);
      },
      topDownloaded: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.topDownloaded';
        }
        spiceworks.community.loadJSON('/api/reports/top_downloaded.json', params, callback, identifier);
      },
      featured: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.featured';
        }
        spiceworks.community.loadJSON('/api/reports/featured.json', params, callback, identifier);
      },
      my: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.my';
        }
        spiceworks.community.loadJSON('/api/reports/user.json', params, callback, identifier);
      },
      // type should be one of: device, ticket, software, it_service, sql
      type: function(type, params, callback, identifier){
        if(identifier){
          identifier += '_community.reports.type/' + type;
        }
        spiceworks.community.loadJSON('/api/reports/type/' + type + '.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.search ==
  // Use the community's search engine to find community content
  spiceworks.community.search = function (query, params, callback, identifier) {
    params.query = query;
    if(identifier){
      identifier += '_community.search';
    }
    spiceworks.community.loadJSON('/api/search.json', params, callback, identifier);
  };

  // == SPICEWORKS.community.activity ==
  // Get a personalized live activity stream from the Spiceworks Community.
  spiceworks.community.activity = function () {
    var that;
    that = {
      user: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.activity.user';
        }
        spiceworks.community.loadJSON('/api/activity/user.json', params, callback, identifier);
      },
      userTimestamps: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.activity.userTimestamps';
        }
        spiceworks.community.loadJSON('/api/activity/user_timestamps.json', params, callback, identifier);
      },
      recentlyViewed: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.activity.userTimestamps';
        }
        spiceworks.community.loadJSON('/api/activity/recently_viewed.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.navigation ==
  // Get a list of community destination pages, organized into groups
  spiceworks.community.navigation = function () {
    var that;
    that = {
      overview: function(params, callback, identifier){
        if(identifier){
          identifier += '_community.navigation.overview';
        }
        spiceworks.community.loadJSON('/api/navigation/overview.json', params, callback, identifier);
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.quotes ==
  // Manage requesting quotes from various areas in the navigation
  spiceworks.community.quotes = function() {
    var that;
    that = {
      createRFQ : function(path, source){
        jQuery('<form action="' + path + '" method="post" id="createRFQForm"><input type="hidden" name="source" value="'+ source +'" class="hidden"></form>').appendTo('body');
        jQuery('#createRFQForm').trigger('submit');
      }
    };
    return that;
  }();

  // == SPICEWORKS.community.dashboard ==
  // Code to support Community dashboard pages, including the vendor dashboard page
  spiceworks.community.dashboard = function () {
    // Internal (private) code

    // Public interface
    return {
      // getProductData: function(params, callback){
      //   spiceworks.community.loadJSON('/api/products/product_data.json', params, callback);
      // },
      // getRecentRatings: function(params, callback, identifier){
      //   if(identifier){
      //     identifier += '_getRecentRatings';
      //   }
      //   spiceworks.community.loadJSON('/api/products/recent_ratings.json', params, callback, identifier);
      // }
    };
  }();

})(SPICEWORKS);
(function (spiceworks) {

  spiceworks.products = {};

  // Include an external script
  // EX:
  //   SPICEWORKS.utils.include('http://myserver/my.js');

  var STORE_URL = "https://shop.spiceworks.com/";

  spiceworks.products.cart = {};
  spiceworks.products.catalog = {};

  spiceworks.products.cart.lastUpdated = Cookie.get('cart-updated-time');

  function updateTimestamp() {
    var time = new Date().getTime();
    Cookie.set('cart-updated-time', time);
    spiceworks.products.cart.lastUpdated = time;
  }

  spiceworks.products.cart.get = function(callback) {
     SPICEWORKS.utils.jsonp('https://shop.spiceworks.com/api/cart.json', {timestamp: spiceworks.products.cart.lastUpdated }, callback, 'get-shopping-cart');
  };

  spiceworks.products.cart.add = function(variant, qty, callback) {
    SPICEWORKS.utils.jsonp('https://shop.spiceworks.com/api/cart.json', {'add': variant, 'qty': qty},  function(response) {
      if (callback) {
        callback(response);
      }
      updateTimestamp();
      SPICEWORKS.fire("cart:refresh");
    });
  };

  spiceworks.products.cart.remove = function(variant, callback) {
    SPICEWORKS.utils.jsonp('https://shop.spiceworks.com/api/cart.json', {'delete': variant},  function(response) {
      if (callback) {
        callback(response);
      }
      updateTimestamp();
      SPICEWORKS.fire("cart:refresh");
    });
  };

  spiceworks.products.cart.update = function(variant, qty, callback) {
     SPICEWORKS.utils.jsonp('https://shop.spiceworks.com/api/cart.json', {'update': variant, 'qty': qty},  function(response) {
       if (callback) {
         callback(response);
       }
       updateTimestamp();
       SPICEWORKS.fire("cart:refresh");
     });
  };

  spiceworks.products.catalog.find = function(criteria, callback) {
    SPICEWORKS.utils.jsonp('https://shop.spiceworks.com/api/catalog.json', criteria, callback);
  };

})(SPICEWORKS);
(function (spiceworks) {
  // prepare SUI in case it's not initialized
  if (typeof SUI === 'undefined') {
    SPICEWORKS.ui = {};
    window.SUI = SPICEWORKS.ui;
  }

  /*
   * Ex Usage:
   *  SUI.sideMenu(destElement, {
   *    items:[
   *      '<a href="http://foo.com">Foo</a>',
   *      {label: 'Bar', itemName:'bar', href:'http://bar.com'},
   *      {separator: true, itemName: 'sep'},
   *      {label: 'Baz', itemName:'baz', onclick: function () { alert('baz'); } }
   *    ]
   *  })
   */
  spiceworks.ui.sideMenu = function (itemElem, spec) {
    if (!itemElem) { return; }
    var items,
        keepOpen = false,
        menuTimeout = null,
        openerTimeout = null,
        showMenuTimeout = null,
        target = $(spec.target || itemElem);
        sideMenu = null;

    if (Browser.ie6 && !spec.shown) {
      spec.openerUsesCss = false;
    }

    // == START HELPER FUNCTIONS
    function addItem(itemSpec) {
      if (!itemSpec) {
        return; // itemSpec is null, so do nothing!
      }

      var menuItem;
      var icon = (spec.icons === false ? '' : 'icon ');

      //if it's just a string, then render the link without checking anything else.
      if (typeof itemSpec == 'string') {
        itemElem.menu.insert("<li>" + itemSpec + "</li>");
        return;
      }

      // Renamed className to itemName... keep support for plugin writers if possible.
      if(itemSpec.className && !itemSpec.itemName){
        itemSpec.itemName = itemSpec.className;
      }

      if (!itemSpec.itemName) {
        throw 'Menu item specification must include itemName.';
      }

      if (!itemElem.menu.down('.' + itemSpec.itemName)) {

        if (itemSpec.separator) {
          itemElem.menu.insert(new Element('li').insert(new Element('div', {'class':'separator ' + icon + itemSpec.itemName}).update('&nbsp;')));
        }
        else if (itemSpec.rawLink) {
          itemElem.menu.insert("<li>" + itemSpec.rawLink + "</li>");
        } else {
          menuItem = new Element('a', {href:itemSpec.href || '#', 'class': icon + itemSpec.itemName, 'target': (itemSpec.target || '_top')}).update(itemSpec.label);
          if (itemSpec.onclick) {
            Event.observe( menuItem, 'click', function (e) {
              Event.stop(e);
              hideMenuAndOpener();
              itemSpec.onclick( spec.itemElemOrig || itemElem );
            });
          }
          // conditional separator
          if ( itemSpec.separator_up && itemElem.menu.childElements().length ) {
            itemElem.menu.insert(new Element('li').insert(new Element('div', {'class':'separator ' + icon + itemSpec.itemName + " separator_up"}).update('&nbsp;')));
          }
          itemElem.menu.insert(new Element('li').update(menuItem));
        }
      }
    }

    function showOpener() {
      if (!spec.openerUsesCss) {
        if (!itemElem.hasClassName('editing') && !itemElem.down('input')){
          itemElem.opener.style.display='block';
        }else{
          hideOpener();
        }
      }
    }
    function hideOpener() {
      itemElem.opener.removeClassName('on');
      if (!spec.openerUsesCss) {
        itemElem.opener.style.display='none';
      }
    }
    function hideMenu() {
      itemElem.opener.removeClassName('on');
      itemElem.pivotable.hide();
      itemElem.opener.style.zIndex='';
      itemElem.style.zIndex='';
      itemElem.pivotable.style.zIndex='';
      var dl = itemElem.up('dl,li,div');
      if(dl){
        dl.style.zIndex='';
      }
    }

    function showMenu() {
      if(!itemElem.pivotable.visible()) {
        itemElem.pivotable.show();
        itemElem.pivotable.clonePosition(itemElem.opener, {
          setHeight:false,
          setWidth:false,
          offsetTop: (itemElem.opener.offsetHeight - 2),
          offsetLeft: -(itemElem.pivotable.offsetWidth - itemElem.opener.offsetWidth - 6)
        });

        //itemElem.pivotable.style.right= spec.openerText ? '-6px' : '-1px';

        itemElem.style.zIndex=500;
        itemElem.opener.style.zIndex=301;
        itemElem.pivotable.style.zIndex=300;
        itemElem.opener.addClassName('on');
        var dl = itemElem.up('dl,li,div');
        if (dl) {
          dl.style.zIndex=500;
        }
      }
    }

    function hideMenuAndOpener() {
      hideMenu();
      hideOpener();
    }

    function itemOver(event) {
      Event.stop(event);
      clearTimeout(openerTimeout);
      clearTimeout(showMenuTimeout);
      openerTimeout = setTimeout( showOpener, 100);
    }
    function itemOut(event) {
      Event.stop(event);
      clearTimeout(openerTimeout);
      openerTimeout = setTimeout( hideMenuAndOpener, 100);
    }

    function openerOver(event) {
      Event.stop(event);
      clearTimeout(menuTimeout);
      clearTimeout(openerTimeout);
      showMenuTimeout = setTimeout(showMenu, 200);
    }
    function openerOut(event) {
      Event.stop(event);
      clearTimeout(menuTimeout);
      clearTimeout(openerTimeout);
      clearTimeout(showMenuTimeout);
      menuTimeout = setTimeout( hideMenu, 100);
    }

    function menuOver(event) {
      Event.stop(event);
      clearTimeout(openerTimeout);
      clearTimeout(menuTimeout);
    }

    function menuOut(event) {
      Event.stop(event);
      clearTimeout(menuTimeout);
      menuTimeout = setTimeout(hideMenu, 100);
      openerTimeout = setTimeout(hideOpener, 100);
    }
    // == END HELPER FUNCTIONS

    // == BUILD OUT MENU AND ADD MENU ITEMS
    // Build the menu ONLY if needed.
    if (!itemElem.menu) {
      itemElem.wrap = new Element('div', {'class':'sw-menu-wrap'});
      itemElem.insert({top:itemElem.wrap});
      itemElem.pivotable = new Element('div', {style: 'display:none; zoom:1; width:' + (spec.width || '130px'), 'class':'pivotable ' + spec.pivotableClass});
      itemElem.menu = new Element('ul', {'class':'nav_menu'});
      itemElem.pivotable.insert(itemElem.menu);
      itemElem.opener = new Element('a',{'class': 'edit sw-menu-opener', 'style':'cursor:pointer'});
      // optionally, an opener can be text based instead of an arrow.
      if(spec.openerText) {
        itemElem.opener.addClassName('sw-menu-opener-text');
        itemElem.opener.update(spec.openerText);
      }

      // itemElem.keepOpen = false;

      // insert the menu helper
      itemElem.wrap.insert({top: itemElem.opener});
      hideOpener();

      itemElem.wrap.insert({bottom: itemElem.pivotable});

      if (!spec.openerUsesCss) {
        Event.observe(target, 'mouseover', itemOver);
        Event.observe(target, 'mouseout', itemOut);
      }

      Event.observe(itemElem.opener, 'mouseover', openerOver);
      Event.observe(itemElem.opener, 'mouseout', openerOut);

      Event.observe(itemElem.pivotable, 'mouseover', menuOver);
      Event.observe(itemElem.pivotable, 'mouseout', menuOut);
    }

    // Add the new item(s) to the menu.
    // determine if multiple items have been passed in or not.
    if (spec.items) {
      items = spec.items;
    } else {
      items = [spec];
    }

    items.each(addItem);

    // This is the actual side menu object.  We can add things to it using .addItem({})
    sideMenu = {
      hide: hideMenu,
      show: showMenu,
      addItem: addItem
    };

    return sideMenu;
  };

  spiceworks.ui.attachOpener = function (opener, menu, options) {
    var hideTimeout = null;
    opener = $(opener);
    menu = $(menu);
    options = Object.extend( {}, options );

    function show() {
      menu.show();
      opener.addClassName('active');
      if (options.onShow) { options.onShow(); }
    }
    function hide() {
      menu.hide();
      opener.removeClassName('active');
      if (options.onHide) { options.onHide(); }
    }

    function openerOver() {
      clearTimeout(hideTimeout);
      show();
    }
    function openerOut() {
      hideTimeout = setTimeout(function () {
        hide();
      },100);
    }
    function menuOver() {
      clearTimeout(hideTimeout);
      if (!menu.visible()) {
        show();
      }
    }
    function menuOut() {
      hideTimeout = setTimeout(function () {
        hide();
      },100);
    }

    opener.observe('mouseover', openerOver);
    opener.observe('mouseout', openerOut);
    menu.observe('mouseover', menuOver);
    menu.observe('mouseout', menuOut);
  };

  // name: 'ok', 'medium/delete', 'medium/cancel', etc...
  // callback: function callback for this button
  spiceworks.ui.button = function(name, callback) {
    var button = new Element('img', {'src': '//static.spiceworks.com/assets/forms/buttons/' + name + '.gif'});
    button.observe('mouseover', function (event) {
      Event.stop(event);
      button.src = '//static.spiceworks.com/assets/forms/buttons/' + name + '_hover.gif';
    });
    button.observe('mouseout', function (event) {
      Event.stop(event);
      button.src = '//static.spiceworks.com/assets/forms/buttons/' + name + '.gif';
    });
    button.observe('click', callback);

    return button;
  };

  // spec = {title: '', body:'', style:{}}
  spiceworks.ui.popup = function (spec) {
    var popup = {},
        height,
        docBody;

    docBody = $(document.body);

    height = [docBody.getHeight(), 'px'].join('');

    popup.darkbox = new Element('div', {'class':'darkbox'});
    popup.darkbox.setStyle({'height': height});
    docBody.insert(popup.darkbox);

    popup.lightbox = new Element('div', {'class':'lightbox'});
    popup.lightbox.setStyle({'height':height});
    docBody.insert(popup.lightbox);

    popup.content = new Element('div', {'class':'content', 'id':spec.id});
    if (spec.class_name) {
      popup.content.addClassName(spec.class_name);
    }
    popup.lightbox.insert(popup.content);

    popup.title = new Element('h1');
    popup.content.insert(popup.title);

    popup.body = new Element('div');
    popup.content.insert(popup.body);

    // Helpers
    popup.setTitle = function (title) {
      popup.title.update(title);
    };

    popup.setStyle = function(options) {
      for (var _val in options) {
        jQuery('#'+popup.content.id).css(_val, options[_val]);
      }
    };

    popup.setBody = function (body) {
      popup.body.update(body);
    };

    popup.close = function (blind) {
      var effect;
      if(popup.darkbox) {
        if (!blind) {
          if (popup.darkbox.parentNode) {
            popup.darkbox.remove();
          }
          if (popup.lightbox.parentNode) {
            popup.lightbox.remove();
          }
        }else{
          effect = new Effect.BlindUp(popup.darkbox);
          effect = new Effect.BlindUp(popup.lightbox);
          setTimeout( function () {
            popup.darkbox.remove();
            popup.lightbox.remove();
          }, 2000);

        }
      }
    };

    // Initialize if needed
    if (spec.title) {
      popup.setTitle(spec.title);
    }
    if (spec.body) {
      popup.setBody(spec.body);
    }

    return popup;
  };

  spiceworks.ui.clearfix = "<div style='clear:both'></div>";

  // Create a toolbar in the specified element
  spiceworks.ui.toolbar = function(element,spec) {
    var actions = {},
        toolbar,
        toolbarRight;

    toolbar = new Element('div', {'class':'sui-toolbar', 'style':'display:none'}); // hidden by default
    element.insert(toolbar);

    // Add an action to the toolbar.
    function addToolbarAction(actionSpec) {
      toolbar.show();
      var href = actionSpec.href || '#',
          onclick = actionSpec.href ? '' : 'return false;';
      actionSpec.action = new Element('a', {'href': href, onclick: onclick, 'class':'sui-toolbar-action ' + (actionSpec.className || '')}).update(actionSpec.label);
      toolbar.insert(actionSpec.action);

      if (actionSpec.onclick) {
        Event.observe( actionSpec.action, 'click', function () {
          performAction(actionSpec.id);
        });
      }

      actions[actionSpec.id] = actionSpec;
    }

    function performAction(actionId) {
      actions[actionId].onclick(actionId);
    }

    // toolbarRight
    spec.actions = spec.actions || [];
    spec.actions.each(addToolbarAction);

    return {
      actions:actions,
      element:toolbar,
      performAction:performAction
    };
  };

  // Encapsulation of the concept of a filter bar.  Requires a "content" area to scan
  // element is the parent to add the bar to
  // spec requires one object: {content: 'some_element_or_id'}
  spiceworks.ui.filterbar = function(element, spec) {
    var filters = {},
        content,
        filterbar,
        filterObject;

    element = $(element);
    content = $(spec.content);

    filterbar = new Element('div', {'class':'sui-filterbar'});
    element.insert(filterbar);

    function setObject(object) {
      // figure out filters!
      filterbar.update('');
      filters = {};
      tempFilters = {};

      if (!content) {
        filterbar.hide();
        return;
      }

      addFilter('all', true);

      content.select('.filterable').each(function (filterable) {
        filterable.className.split(' ').each(function (className) {
          if (className.indexOf('filter-') === 0 && !tempFilters[className.substring(7)]) {
            tempFilters[className.substring(7)] = true;
          }
        });
      });

      Object.keys(tempFilters).sort().each(function (filtername) {
        addFilter(filtername);
      });

      if (Object.keys(filters).size() == 1) {
        filterbar.hide();
      } else {
        filterbar.show();
      }
    }

    function addFilter(filtername, active) {
      if (!filters[filtername]) {
        var filter = new Element('a', {'href': '#', onclick: 'return false;', 'class':'sui-filter ' + (active ? 'active' : '')}).update(filtername);
        filterbar.insert(filter);
        filters[filtername] = filter;
        Event.observe(filter, 'click', function (event) {
          Event.stop(event);
          setFilter(filtername);
        });
      }
    }

    function setFilter(filtername) {
      var filter = filters[filtername];
      filterbar.select('.sui-filter').each( function (filter) {
        filter.removeClassName('active');
      });
      filter.addClassName('active');

      if (filtername === 'all') {
        content.select('.filterable').each(Element.show);
      } else {
        content.select('.filterable').each(Element.hide);
        content.select('.filterable.filter-' + filtername).each(Element.show);
      }
    }

    filterObject = {
      setObject: setObject,
      element: filterbar,
      addFilter: addFilter,
      setFilter: setFilter
    };

    spiceworks.ui.filterbars.push(filterObject);

    return filterObject;
  };

  spiceworks.ui.filterbars = [];

  spiceworks.ui.refreshAllFilterbars = function () {
    spiceworks.ui.filterbars.each( function (filterbar) {
      filterbar.setFilter("all");
      filterbar.setObject();
    });
  };

  // Button bar
  spiceworks.ui.togglebar = function(element, spec) {
    var buttons = {}, content, loadingMsg;

    element = $(element);
    content = $(spec.content);

    loadingMsg = Object.extend({ message: 'Loading&hellip;', matchHeight: true, 'class': 'loading' }, spec.loadingMessage || {});

    function setObject(object) {
      element.select('.sui-toggle').each(function (button) {
        Event.observe(button, 'click', function (event) {
          setButton(button);
        });
      });
    }

    function clearButtons(section) {
      if (!section) { section = element; }

      section.select('.sui-toggle').each(function (button) {
        button.removeClassName("active");
      });
    }

    function setButton(button) {
      clearButtons(button.up());
      if (content) {
        LoadingMessage.set(content, loadingMsg.message, loadingMsg);
      }
      button.addClassName('active');
    }

    return {
      setObject: setObject,
      element: element,
      setButton: setButton,
      clearButtons: clearButtons
    };
  };

  spiceworks.ui.choicePill = function(element, spec) {
    var wrapper,
        hiddenInput,
        choiceElems,
        first = true;

    element = $(element);
    spec.options = spec.options || {};

    // remove the element with this id if it already exists...
    // if (spec.options.id || $(spec.options.id)) {
    //   $(spec.options.id).up('.sui-choice-pill').remove();
    // }

    choiceElems = [];

    wrapper = new Element('span', {'class':'sui-choice-pill'});
    hiddenInput = new Element('input', {'type':'hidden', 'name':spec.name, 'value':spec.value, 'id':spec.options.id || ''});
    wrapper.insert(hiddenInput);
    element.insert(wrapper);

    spec.choices.each( function (choice) {
      var name, value, choiceElem;
      name = choice[1];
      value = choice[0];
      options = choice[2] || {};
      choiceElem = new Element('a', {'class':'sui-pill ' + options['class'], 'href': '#', onclick: 'return false;', 'id': options.id});
      if (first) {
        choiceElem.addClassName('sui-pill-first');
        first=false;
      }
      choiceElem.setAttribute('pillvalue', value);
      choiceElem.update(name);
      choiceElem.observe('click', function (event) {
        selectChoice(choiceElem);
      });
      choiceElems.push(choiceElem);
      wrapper.insert(choiceElem);

      if(value == spec.value){
        selectChoice(choiceElem);
      }
    });

    function selectChoice(choiceElem) {
      choiceElems.each( function(otherChoiceElem) {
        otherChoiceElem.removeClassName('sui-pill-selected');
      });
      choiceElem.addClassName('sui-pill-selected');
      hiddenInput.value = choiceElem.getAttribute('pillvalue');
      hiddenInput.fire('choice-pill:clicked');
    }
  };

  spiceworks.ui.SimpleMenu = (function(){
      // all of the menu class definition is encapsulated in this closure

      // private, class variable
      var store = [];

      var origSpec = {
        alignment: 'right',
        offsetLeft: 0,
        offsetTop: 0,
        activateOn: 'mouseover',
        activatorZIndex: 500,
        alignToActivator: 'bottom',
        menuZIndex:1450,
        closeButton: [],
        activateDelay: 200,
        deactivateDelay: 100,
        absolutize: false, // Remove the menu from the normal flow of the document and prepend to the body
        afterHide: function(menu) {},
        afterShow: function(menu) {},
        update: function(menu) {},
        autoAdjustable: false // offsets are negatived
      };

      // constructor
      var SimpleMenu = function(activator, menu, spec){

        // change me to an actual error throw
        if ((!menu) || (!activator)) { return; }

        this.menuTimeout = null;
        this.showMenuTimeout = null;
        this.stuckOpen = null; // do i need this yet?
        this.id = menu.id;

        this.activator = $(activator);
        this.menu = $(menu);
        Object.extend(this, origSpec);
        Object.extend(this, spec);

        var simpleMenu = this;

        // instance event handlers
        Object.extend(this, {
          activatorOver: function(event) {
            clearTimeout(simpleMenu.showMenuTimeout);
            simpleMenu.showMenuTimeout = setTimeout(jQuery.proxy(simpleMenu, 'showMenu'), simpleMenu.activateDelay);
          },
          activatorOut: function(event) {
            clearTimeout(simpleMenu.showMenuTimeout);
            simpleMenu.showMenuTimeout = setTimeout(jQuery.proxy(simpleMenu, 'hideMenu'), simpleMenu.deactivateDelay);
          },
          menuOver: function(event) {
            clearTimeout(simpleMenu.showMenuTimeout);
            clearTimeout(simpleMenu.menuTimeout);
          },
          menuOut: function(event) {
            clearTimeout(simpleMenu.menuTimeout);
            simpleMenu.menuTimeout = setTimeout(jQuery.proxy(simpleMenu, 'hideMenu'), simpleMenu.deactivateDelay);
          },
          menuClicked: function(event) {
            var el = event.element();
            if (simpleMenu.menu.select(simpleMenu.closeButton).include(el)) {
              simpleMenu.hideMenu();
            }
          },
          toggleMenuVisibility: function(event) {
            event.stop();
            simpleMenu.menu.visible() ? simpleMenu.hideMenu() : simpleMenu.showMenu();
          }
        });

        this.attachHandlers();

        store.push(this);
      };

      // instance methods
      SimpleMenu.prototype = {
        align: function() {
          var offsetLeft = jQuery.determine(this.offsetLeft),
              offsetTop = jQuery.determine(this.offsetTop),
              vpSize = document.viewport.getDimensions(),
              vpScrolled = document.viewport.getScrollOffsets(),
              aPosition = this.activator.cumulativeOffset(),
              aSize = {height: this.activator.getHeight(), width: this.activator.getWidth()},
              mSize = {height: this.menu.getHeight(), width: this.menu.getWidth()},
              aligned = this.alignment,
              vAligned = 'bottom';

          var enoughTopRoom = function(){
            var availableSpace = vpSize.height + vpScrolled.top;
            // add 23 to the height for the bottom status bar
            var bottomMostMenuPixel = aPosition.top + mSize.height + offsetTop + 23;
            return bottomMostMenuPixel <= availableSpace;
          };

          var enoughRightRoom = function(){
            var availableSpace = vpSize.width + vpScrolled.left;
            var rightMostMenuPixel = aPosition.left + mSize.width + offsetLeft;
            return rightMostMenuPixel <= availableSpace;
          };

          var alignRight = function(){
            offsetLeft = -(mSize.width - aSize.width) + offsetLeft;
            aligned = 'right';
          };

          var alignLeft = function(){
            aligned = 'left';
          };

          var vAlignTop = function(){
            offsetTop = -mSize.height + offsetTop;
            vAligned = 'top';
          };

          var vAlignBottom = function(){
            offsetTop = aSize.height + offsetTop;
            vAligned = 'bottom';
          };

          // horizontal alignment
          if (this.alignment == 'left') {
            if (this.autoAdjustable && !enoughRightRoom()) {
              offsetLeft = -offsetLeft;
              alignRight();
            }
          } else if (this.alignment == "center") {
            // no autoAdjust for centered items
            var menuMiddle = (mSize.width / 2);
            var activatorMiddle = (aSize.width / 2);
            offsetLeft = activatorMiddle - menuMiddle;
          } else {
            // no autoAdjust for right-aligned items
            alignRight();
          }

          // vertical alignment
          // not yet doing vertical viewport adjustment because of variable height popups
          //  if (this.autoAdjustable && !enoughTopRoom()) {
          //    offsetTop = -offsetTop;
          //    vAlignTop();
          //  } else {
          //    vAlignBottom();
          //  }
          vAlignBottom();

          // position it
          this.menu.clonePosition(this.activator, {
            setHeight:false,
            setWidth:false,
            offsetTop: offsetTop,
            offsetLeft: offsetLeft
          });

          // remove classes
          ['center', 'top', 'right', 'bottom', 'left'].each(function(location){
            ['menu-align-', 'menu-valign-', 'menu-at-the-'].each(function(classType){
              this.menu.removeClassName(classType+location);
            }.bind(this));
          }.bind(this));

          // add appropriate positioned classes
          this.menu
            .addClassName("menu-align-" + aligned)
            .addClassName("menu-valign-" + vAligned)
            .addClassName("menu-at-the-" + this.alignToActivator);

          return this;
        },
        unload: function() {
          Event.stopObserving(this.activator);
          Event.stopObserving(this.menu);
          SPICEWORKS.stopObserving("simplemenu:show", this.menuShownEvent);

          this.menu.select(this.closeButton).each(function(button) {
            button.stopObserving('click', this.hideMenu);
          });
        },
        setActivator: function(newActivator) {
          this.activator.simpleMenu = null;
          this.removeHandlers();

          this.activator = newActivator;
          Object.extend(this.activator, {simplemenu: this});
          this.attachHandlers();
        },
        destroy: function()
        {
          this.unload();
          $(this.menu).remove();
        },
        hideMenu: function() {
          if (this.stuckOpen) { return; }

          this.menu.hide();

          this.activator.style.zIndex=1;
          this.activator.removeClassName("active");

          if (this.activateOn == "click") { this.activator.blur(); } // or IE7 will freak
          SPICEWORKS.fire("simplemenu:hide", {id: this.id});
          this.afterHide();
        },
        showMenu: function() {
          this.update();
          SPICEWORKS.fire("simplemenu:show", {id: this.id});

          if (this.absolutize) {
            this.placeMenuInBody();
          }

          this.menu.show();

          if ((this.activator.getStyle('position') != "absolute")) {
            this.activator.style.position = "relative";
          }

          // we need to show the menu before aligning it so that offsetWidth is valid
          this.align();
          this.activator.style.zIndex = this.activatorZIndex;
          this.menu.style.zIndex = this.menuZIndex;

          this.activator.addClassName("active");
          this.activator.blur();
          this.afterShow();
        },
        placeMenuInBody: function() {
          if (!this.menu.hasClassName("attached_to_body")) {
            $(document.body).insert({
              bottom: this.menu
            });
            var dimensions = this.menu.getDimensions();
            this.menu.addClassName('attached_to_body').absolutize();
            this.menu.style.width = dimensions.width+'px';
            this.menu.style.height = dimensions.height+'px';
          }
        },
        setMenu: function(newMenu){
          var oldMenu = this.menu;
          this.removeHandlers();
          this.menu = newMenu;
          oldMenu.remove();
          this.attachHandlers();
          return this.menu;
        },
        stick: function() {
          this.stuckOpen = true;
          this.showMenu();
        },
        unstick: function() {
          this.stuckOpen = false;
        },
        attachHandlers: function() {
          if (Modernizr.touch || this.activateOn == "click") {
            this.activator.observe('click', this.toggleMenuVisibility);
            this.menu.observe('click', this.menuClicked);
          } else if (this.activateOn == "mouseover") {
            this.activator.observe('mouseover', this.activatorOver);
            this.activator.observe('mouseout', this.activatorOut);
            this.menu.observe('mouseover', this.menuOver);
            this.menu.observe('mouseout', this.menuOut);
            this.menu.observe('click', this.menuClicked);
          }
        },
        removeHandlers: function(){
          Event.stopObserving(this.activator);
          Event.stopObserving(this.menu);
        }
      };

      // public class methods
      SimpleMenu.all = function(){
        return store;
      };

      SimpleMenu.menuShownEvent = function(event) {
        // This could be from any menu
        jQuery.each(SimpleMenu.all(), function(){
          if (this.id != event.memo.id) { this.hideMenu(); }
        });
      };
      SPICEWORKS.observe("simplemenu:show", SimpleMenu.menuShownEvent);

      // return the entire public class
      return SimpleMenu;
  })();

  // Build out the statusBarPopup from the spec passed...
  spiceworks.ui.statusBarPopup = function(statusBarItem, spec) {
    // adds a generic popup on a given icon in the status bar
    // Elements
    var alertBox, actionBox, panel, refreshLink, panelContent, header, footer, filterbar, filters, link, hideTimer, notifier, notifyTimer, close;

    var self = {};
    var data = {};
    // Flags and Data
    var initialized, totalCount, lastSeen, lastUpdated;
    /*
      item:
      title:

      callbacks:
        onShow: function(self)
        onCountUpdate: function(self, oldCount, newCount)
    */

    function togglePanel(event) {
      if (!initialized) { initializePopup(); }

      event.element().blur();
      event.element().up().blur();

      if (isOpen()) {
        hidePanel();
      }
      else {
        showPanel();
      }
      event.stop();
    }

    function initializePopup() {
      // Create Elements
      panel = new Element('div', {'class':'popup ' + (spec.name ? spec.name : ""), 'style':'display:none'});
      close = new Element('a', {'class': 'close', 'href': '#', onclick: 'return false;' }).update("close");
      header = new Element('h5', {'class':'header'}).update(spec.title).insert(close);
      filterbar = new Element('div', {'class': 'content-filterbar'});
      panelContent = new Element('div', {'class':'content'});
      footer = new Element('div', {'class': 'footer'});
      refreshLink = (new Element('a', {'href': '#', onclick: 'return false;', 'class': 'refreshLink'}).update("Refresh"));
      refreshLink.observe('click', refresh);
      alertBox = new Element('div', {'class': 'alertBox', 'style': 'display:none'});
      actionBox = new Element('div', {'class': 'actionBox', 'style': 'display:none'});

      // Inserts elements in the correct order, clearing out anything else
      resetLayout("Loading&hellip;");

      statusBarItem.insert(panel);

      // Register Events
      Event.observe((document.onresize ? document : window), "resize", adjustHeight);
      SPICEWORKS.observe("statusbar:popup:opened", hidePanel);
      close.observe('click', hidePanel);
      initialized = true;
    }

    function safeResetLayout(message) {
      if (initialized) {
        resetLayout(message);
      }
    }

    function resetLayout(message) {
      panel.insert(header);
      panel.insert(filterbar);
      panel.insert(panelContent);
      panel.insert(actionBox);
      panel.insert(alertBox);
      panel.insert(footer);

      if (message) { setPanelMessage(message); }
      alertBox.hide();
      actionBox.hide();
      footer.hide();
      adjustHeight();
    }

    // Indicator Notification

    function notify(text) {
      if (!statusBarItem.down('div.notifier')) {
        notifier = new Element('div', {'class':'notifier', style: 'display:none;'});
        notifier.insert(new Element('div'));
        notifier.down('div').insert(new Element('p', {'class':'content'}));
        notifier.down('div').insert(new Element('p', {'class':'bottom'}));

        statusBarItem.insert(notifier);
      }

      if (!panel || !panel.visible()) {
        statusBarItem.down('div.notifier p.content').update(text);
        showNotifier();

        if (notifyTimer) { clearTimeout(notifyTimer); }
        notifyTimer = window.setTimeout(function() { hideNotifier(); }, 3000);
      }
    }

    function hideNotifier() {
      if (notifier) {
        notifier.fade({duration:0.5});
      }
    }

    function showNotifier() {
      if (notifier) {
        notifier.appear({duration:0.5});
      }
    }

    function adjustHeight(lock) {
      var borderHeight = panel.getHeight() + 100 - panelContent.getHeight();
      if (((panelContent.scrollHeight + borderHeight) > document.viewport.getHeight()))  {
        panelContent.setStyle("overflow-y:scroll; overflow-x:hidden; height:" + (document.viewport.getHeight() - borderHeight) + "px");
      }
      else if (lock) {
        panelContent.setStyle("height:" + panelContent.getHeight() + "px");
      }
      else {
        panelContent.setAttribute("style", " ");
      }
    }

    function setPanelMessage(message) {
      panelContent.update(new Element('div', {'class': 'message'}).update(message));
    }

    function setAlertMessage(message) {
      alertBox.update(message);
      alertBox.show();
      adjustHeight();
    }

    function setActionBox(content) {
      actionBox.update(content);
      actionBox.show();
      adjustHeight();
    }

    function hideActionBox() {
      actionBox.hide();
      adjustHeight();
    }

    function setPanel(message) {
      panelContent.update(new Element('div', {'class': 'message'}).update(message));
    }

    function setFooter(content) {
      footer.update(content);
      footer.show();
    }

    function hidePanel() {
      self.count = totalCount;

      if (spec.beforeHide) { spec.beforeHide(self); }

      statusBarItem.removeClassName('selected');
      statusBarItem.removeClassName('open');
      panel.hide();

      if (spec.afterHide) { spec.afterHide(self); }
    }

    function showPanel() {
      self.count = totalCount;
      if (spec.beforeShow) { spec.beforeShow(self); }

      SPICEWORKS.fire("statusbar:popup:opened", self);
      statusBarItem.addClassName('open');
      hideNotifier();
      panel.show();
      statusBarItem.addClassName('selected');
      self.lastSeen = lastSeen;

      try {
        if (spec.onShow) { spec.onShow(self); }
      }
      finally {
        adjustHeight();
        if (spec.afterShow) { spec.afterShow(self); }
      }
    }

    function refresh() {
      resetLayout("Refreshing Data&hellip;");
      showPanel();
    }

    function updateCanvas(content) {
      if (Object.isArray(content)) {
        panelContent.update("");
        content.each(function(element) {
          panelContent.insert(element);
        });
      }
      else {
        panelContent.update(content);
      }

      adjustHeight();
      buildFilters();
    }

    function buildFilters() {
      if (panelContent.down('ul li.filterable')) {
        filterbar.show();
        filterbar.update("");
        filters = SUI.filterbar(panel.down('div.content-filterbar'),{content: panelContent.down('ul') });
        filters.setObject();
      }
      adjustHeight(true);
    }

    function incrementCount(increment) {
      setCount((totalCount || 0) + (increment || 0));
    }

    function setCountWithoutCallback(newCount) {
      setCount(newCount, true);
    }

    function setCount(newCount, skipCallback) {
      statusBarItem.down('a span').update(newCount);
      if ((spec.onCountUpdate) && (newCount != totalCount) && (!skipCallback)) { spec.onCountUpdate(self, totalCount, newCount); }
      totalCount = newCount;

      if (spec.hideCountOnZero && spec.hideCountOnZero === true && newCount === 0) { statusBarItem.down('a span').hide(); }
      else { statusBarItem.down('a span').show(); }

      if (spec.hideIndicatorOnZero && spec.hideIndicatorOnZero === true && newCount === 0) { statusBarItem.hide(); }
      else { statusBarItem.show(); }
    }

    function isOpen() {
      return (panel && panel.visible());
    }

    function setFlag(flag) {
      statusBarItem.addClassName(flag);
    }

    function clearFlag(flag) {
      statusBarItem.removeClassName(flag);
    }

    function elements(name) {
      var obj = {
        indicatorLink: statusBarItem,
        indicator: statusBarLink,
        panel: panel,
        canvas: panelContent,
        header: header,
        footer: footer,
        refreshLink: refreshLink,
        alertBox: alertBox,
        actionBox: actionBox
      };

      if (name) { return obj[name]; }
      else { return obj; }
    }

    function setData(name, value) {
      data[name] = value;

      return value;
    }
    function getData(name) {
      return data[name];
    }

    function clearData(name) {
      delete data[name];
    }

    function getCount() {
      return totalCount;
    }

    self.setData = setData;
    self.getData = getData;
    self.clearData = clearData;
    self.getCount = getCount;
    self.setCount=setCount;
    self.setCountWithoutCallback = setCountWithoutCallback;
    self.isOpen = isOpen;
    self.hidePanel=hidePanel;
    self.showPanel= showPanel;
    self.resetLayout = safeResetLayout; // IE has a bug that if this is called before initialize in a callback, the header gets lost
    self.setPanelMessage=setPanelMessage;
    self.setAlertMessage=setAlertMessage;
    self.setFooter=setFooter;
    self.setActionBox = setActionBox;
    self.hideActionBox = hideActionBox;
    self.update=updateCanvas;
    self.builders=SUI.builders.statusBarPopup;
    self.formatters=SUI.formatters.statusBarPopup;
    self.notify=notify;
    self.incrementCount=incrementCount;
    self.setFlag = setFlag;
    self.clearFlag = clearFlag;
    self.elements=elements;

    /* Basic Initialization */
    /* We don't create the panel content until we get click.  This stuff is just for the indicators */

    statusBarItem = $(statusBarItem);
    statusBarLink = statusBarItem.down('a');
    statusBarLink.observe('click', togglePanel);
    statusBarLink.setAttribute('title', spec.title);

    totalCount = spec.count || 0;
    setCount(totalCount);

    // Add methods to the object
    if (spec.afterInitialize) { spec.afterInitialize(self); }

    return self;
  };

  spiceworks.ui.elements =  {
    primary: {
      area: function() { return $("primary"); },
      header: function() {  return $("content").down("div.sui-header"); },
      breadcrumbs: function() { return $$("#content > div.sui-header .crumbs"); },
      toolbar: function() { return $("primary").down("div.sui-toolbar"); }
    },
    secondary: {
      area: function() { return $("secondary"); },
      header: function() {  return $("secondary").down("div.sui-header"); },
      breadcrumbs: function() {  return $$("#secondary div.sui-header span.crumb"); },
      toolbar: function() { return $("secondary").down("div.sui-toolbar"); },
      tabbedBox: function() { return $("secondary").down("div.sui-tabbed-box"); }
    }
  };

  // This is used by the tabbed_player helper in layout helper
  // spec requires defaultSize: {width: int, height: int} to calculate aspect ratio for resizing
  // pass in autoResize to resize on page resize and on tab change
  spiceworks.ui.tabbedplayer = function(playerContainer, videoContainer, spec) {
    var tabs, video, videoHeight, containerHeight, videoWidth, playerContent, aspectRatio;

    function setObject(object) {
      setVideo(tabs.down("li.active a") || tabs.down("li a"));
    }

    function setHeight() {
      if (!videoContainer) { return; }

      videoHeight = ($(videoContainer).up(".video_column").getWidth() / aspectRatio);
      if (spec.defaultSize.height > videoHeight) { videoHeight = spec.defaultSize.height; }
      $(videoContainer).setAttribute('height', videoHeight);
      playerContent.setStyle('height: ' +  videoHeight + 'px');
    }

    function setVideo(videoLink) {
      if (autoResize) { setHeight(); }

      var link = videoLink.getAttribute('href');
      videoLink.up("li").siblings().invoke("removeClassName", "active");
      videoLink.up("li").addClassName("active");

      $(videoContainer).setStyle({width: videoWidth, height:videoHeight});

      swfobject.embedSWF(link, videoContainer, videoWidth, videoHeight, "9.0.0", "/flash/expressinstall.swf", {}, {wmode: 'opaque', allowfullscreen: 'true'});
    }

    function unload() {
      tabs.select("li > a").invoke("stopObserving");
      Event.stopObserving((document.onresize ? document : window), "resize", setHeight);
    }

    spec.defaultSize = spec.defaultSize || { width: 400, height:267 };
    spec.unloadOn = spec.unloadOn || ['app:ui:secondary:unload', 'app:ui:tab:unload'];

    autoResize = spec.autoResize || false;
    aspectRatio = spec.defaultSize.width / spec.defaultSize.height;

    playerContainer = $(playerContainer);
    playerContent = playerContainer.down('div');

    tabs = playerContainer.down("ul");

    tabs.select("li > a").each(function(a) {
      a.observe("click", function(e) { setVideo(a); });
    });

    if (autoResize) {
      videoWidth = "100%";
      Event.observe((document.onresize ? document : window), "resize", setHeight);
    }
    else {
      videoWidth = spec.width || spec.defaultSize.width;
      videoHeight = spec.height || spec.defaultSize.height;
    }

    SPICEWORKS.utils.unloader(SPICEWORKS, spec.unloadOn, unload);

    playerObject = {
      setObject: setObject,
      setVideo: setVideo,
      playerContainer: playerContainer,
      videoContainer: videoContainer
    };

    return playerObject;
  };

  // Builds a secondary content box and returns the element ready to be inserted in the DOM
  // SPICEWORKS.ui.secondary.build({
  //    parent: 'some-element-id-to-append-to',
  //    heading:'My Secondary Box',
  //    tabs:[{visible:'Tab 1'}, {visible:'Tab 2', active:true}, {visible:'Tab 4'}],
  //    sheet:'<h3>this is my content</h3><p>content</p>',
  //    sideSections:[{title:'Side Section Title', items:[{classes:'item-class-one item class-two', visible:'some text and/or html'}]}]
  //  })
  spiceworks.ui.secondary = (function(){
    function build(options){
      options = Object.extend({
        parent:null,
        twoColumn:true,
        heading:'',
        tabs:[],
        sheet:'',
        sideSections:[]
      }, options || {});

      var secondary = new Element('div', {'class':'sui-secondary'});
      var header = new Element('div', {'class':'sui-header'}).update('<h2>' + options.heading + '</h2>');
      var innerClasses = $A(['inner']);
      if (options.twoColumn) { innerClasses.push('two-column'); }
      var inner = new Element('div', {'class':innerClasses.compact().join(' ')});

      if (options.twoColumn && options.sideSections){
        var side = new Element('div', {'class':'sui-overview'});
        options.sideSections.each(function(section){
          var sectionElement = new Element('div', {'class':'section'});
          sectionElement.insert("<h3>" + section.title + "</h3>");
          var list = new Element('ul', {'class':'properties content'});
          list.update(section.items.collect(function(item){
            return '<li class="' + item.classes + '">' + item.visible + '</li>';
          }).join("\n"));
          sectionElement.insert(list);
          side.insert(sectionElement);
        });
        inner.insert(side);
      }

      var tabs = new Element('div', {'class':'sui-tabs'}), list = new Element('ul');
      list.update(options.tabs.collect(function(item){
        item.classes = (item.classes || '') + (item.active ? ' active' : '');
        return '<li class="' + item.classes + '" id="' + item.id + '">' + item.visible + '</li>';
      }).join("\n"));
      tabs.update(list);
      tabs.insert('<div class="sui-tab-more" style="display:none;">&raquo;</div>');

      var sheet = new Element('div', {'class':'sui-sheet'}).update(options.sheet);
      var tabbedBox = new Element('div', {'class':'sui-tabbed-box-inner'}).insert(tabs).insert(sheet);
      var contentInner = new Element('div', {'class':'left drop-shadow sui-tabbed-box'}).update(tabbedBox);
      inner.insert(contentInner);
      secondary.insert(header).insert(inner);

      if (options.parent){
        var parent = $(options.parent);
        if (parent.down('div.sui-secondary')) { parent.down('div.sui-secondary').remove(); }
        parent.insert(secondary);
      }

      return secondary;
    }

    return {
      build:build
    };
  })();

  spiceworks.ui.tabbedbox = function(tabbedBox, spec) {
    tabbedBox = $(tabbedBox);

    var ul = tabbedBox.down("div.sui-tabs ul"),
    firstTab = tabbedBox.down("div.sui-tabs ul li"),
    moreActivator = tabbedBox.down("div.sui-tabs div.sui-tab-more"),
    sheet = tabbedBox.down('div.sui-sheet'),
    state = {}, o = {}, li, simpleMenu, showMore, events = $A();

    spec = Object.extend({
      requestClass: 'secondary/tab',
      uriKey: 'tab',
      updateURI: true,
      unloadOn: 'app:ui:secondary:unload'
    }, spec || {});

    spec = Object.extend({
      afterSelect: function(s) {
        if (s.activeTabName !== null) { // if this is null, the page will jump to the top in IE
          o[spec.uriKey] = s.activeTabName;
          Application.updateState(o, {updateUri: spec.updateURI});
        }
      }
    }, spec);

    function tabSelected(event) {
      li = event.findElement("li");
      if (!li) { return; }

      selectTab(li);
      event.element().blur();
    }

    function selectTab(li, callback) {
      li = $(li);
      if (!li) { return; }

      SPICEWORKS.fire('app:ui:tab:unload');
      ul.select('li.active').invoke("removeClassName", "active");
      li.addClassName("active");
      var link = li.down('a');
      if (link && link.getAttribute('click_url')) {
        loadContent(li.down('a').getAttribute('click_url'), callback);
      }

      updateActiveState(li);
      spec.afterSelect(state);

      SPICEWORKS.fire('app:ui:tab:selected', object);
    }

    function loadContent(url, callback) {
      LoadingMessage.set(sheet, "Loading &hellip;");

      var request = new Ajax.Request(url, {
        asynchronous:true,
        evalScripts: true,
        parameters:{requestClass: spec.requestClass},
        method: 'get',
        onFailure:function(request){
          StatusMessage.set(sheet, "Unable to load tab, please try again");
        },
        onComplete: function(request){
          if (callback) { callback(request); }
        }
      });
    }

    function updateActiveState(li) {
      if (!$(li)) { return; }

      state.activeTab = li;
      state.activeTabName = (li.getAttribute("id") || "").split("_tab")[0];
    }

    function unload() {
      Event.stopObserving(ul);
      $(moreMenuContent).select("li").invoke("stopObserving");
      simpleMenu.unload();

      SPICEWORKS.stopObserving("app:ui:secondary:unload", unload);
      Event.stopObserving((document.onresize ? document : window), "resize", updateMoreVisibility);
    }

    function updateMoreVisibility(){
      showMore = false;
      tabbedBox.select("div.sui-tabs ul li").reverse().each(function(tab) {
        if (Math.abs(firstTab.cumulativeOffset().top - tab.cumulativeOffset().top) > 5) {
          showMore = true;
          throw $break;
        }
      });
      moreActivator[showMore ? 'show' : 'hide']();
    }

    SPICEWORKS.utils.unloader(SPICEWORKS, spec.unloadOn, unload);
    Event.observe((document.onresize ? document : window), "resize", updateMoreVisibility);
    Event.observe(ul, "click", tabSelected);

    // Initialize internal state registry, and passed the currently selected tab to Application.
    // We need this on load since ocassionally we request the tab when submitting forms, etc
    updateActiveState(tabbedBox.down("div.sui-tabs > ul > li.active"));
    if (state.activeTabName !== null) {
      o[spec.uriKey] = state.activeTabName;
      // Don't update the URL on load, as IE freaks out and refreshes on anchor param changes, sometimes.
      Application.updateState(o, {updateUri: false});
    }

    // If the anchor param in the url is different the currently loaded tab, jump to it
    if (Application.getUriAnchorParams().get(spec.uriKey) != state.activeTabName) {
       selectTab(Application.getUriAnchorParams().get(spec.uriKey) + "_tab");
    }

    // Set up more menu
    updateMoreVisibility();

    var moreMenuContent = new Element('ul', {'class': 'menu'});
    tabbedBox.select("div.sui-tabs ul li a").each( function(a) {
      var li = new Element('li').update(a.clone().update(a.innerHTML));
      li.observe('click', function() { selectTab(a.up()); } );
      moreMenuContent.insert(li);
    });

    var contentID = "tab_more_content_" + (Math.floor(Math.random()*1000+1)).toString();
    $(tabbedBox).insert(new Element('div', {id: contentID, 'class': 'tab-more-menu simple-menu', style: 'display:none;'} ).update(moreMenuContent));

    simpleMenu = new SUI.SimpleMenu(moreActivator.down('a'), contentID, {alignment: 'right', update: function(content) {
      var items = $(content).select("ul.menu li");
      if (moreActivator) {
        items.invoke("show");
        items.invoke("removeClassName", "active");
        tabbedBox.select("div.sui-tabs ul li").each(function(tab, index) {
          if (tab.hasClassName('active')) { items[index].addClassName('active'); }
          items[index][(Math.abs(firstTab.cumulativeOffset().top - tab.cumulativeOffset().top) > 5) ?  'show' : 'hide']();
        });
      }
    }});

    Object.extend(tabbedBox, {
      selectTab: selectTab,
      state: state
    });

    var object = {
      tabbedBox: tabbedBox,
      selectTab: selectTab,
      moreMenu: simpleMenu,
      state: state,
      unload: unload
    };

    return object;
  };

  spiceworks.ui.menuSet = function(container, spec){
    container = $(container);
    spec = Object.extend({
      items:$A(),
      activator:'<a href="#" class="menu-set-activator"><em>menu</em></a>',
      menuTag:'li',
      onclick: Prototype.emptyFunction,
      onshow: Prototype.emptyFunction,
      placementSelector: null,
      itemSelector:'tr',
      beforeInsertion:'',
      position:'bottom',
      template:null
    }, spec || {});

    if (!spec.template) {
      spec.template = new Template('<div id="#{id}" class="menu-set" style="display:none"><ul>#{items}</ul></div>');
    }

    var menu = {
      id:container.id + '-menu-set',
      items:spec.items.collect(function(item){
        return '<' + spec.menuTag + '>' + item + '</' + spec.menuTag + '>';
      }).join("\n")
    };

    container.insert({before:spec.template.evaluate(menu)}); // insert the menu just before the container node so that z-indexing and stuff works nicely
    var relatedMenu = $(menu.id);

    var insertion = {};
    insertion[spec.position] = spec.beforeInsertion + spec.activator;
    container.select(spec.placementSelector).each(function(insertionPoint){
      insertionPoint.insert(insertion);
    });

    SPICEWORKS.observe('table-row:added', function(event){
      var row = $(event.memo);
      if (row.up('table').id == container.down('table').id){
        // new row added to the table we are concerned with
        row.down(spec.placementSelector).insert(insertion);
      }
    });

    function showMenu(activator){
      clearHideTimeout();
      container.select('.menu-set-shown').invoke('removeClassName', 'menu-set-shown');
      activator.up(spec.itemSelector).addClassName('menu-set-shown');
      spec.onshow(activator, relatedMenu);
      relatedMenu.show();

      var offsetTop = activator.offsetHeight - 1;
      if (Prototype.Browser.IE) { offsetTop = offsetTop - 2; }
      if (Browser.ie7) { offsetTop = (offsetTop - 3) + container.scrollTop; }

      relatedMenu.clonePosition(activator, {
        setHeight:false,
        setWidth:false,
        offsetTop: offsetTop,
        offsetLeft: -(relatedMenu.offsetWidth - activator.offsetWidth)
      });
    }
    function beginHide(){
      hideTimeout = setTimeout(function(){ hideMenu(); }, 250);
    }
    function hideMenu(){
      container.select('.menu-set-shown').invoke('removeClassName', 'menu-set-shown');
      relatedMenu.hide();
    }
    var hideTimeout;
    function clearHideTimeout(){
      if (!hideTimeout) { return; }
      clearTimeout(hideTimeout);
      hideTimeout = null;
    }

    container.observe('mouseover', function(event){
      var element = event.element();
      if (element.hasClassName('menu-set-activator') || element.up('a.menu-set-activator')) {
        showMenu(element);
      }
    });
    container.observe('mouseout', function(event){
      var element = event.element();
      if (element.hasClassName('menu-set-activator') || element.up('a.menu-set-activator')) {
        beginHide();
      }
    });
    relatedMenu.observe('mouseover', function(event){ clearHideTimeout(); });
    relatedMenu.observe('mouseout', function(event){ beginHide(); });
    relatedMenu.observe('click', function(event){
      event.memo = container.down('tr.menu-set-shown');
      spec.onclick(event);
      beginHide();
    });
  };

  spiceworks.ui.truncate = function(text, length, minDifference) {
    var container, full, brief, link, id;

    if (!length) { length = 300; }
    if (!minDifference) { minDifference = 100; }
    if (!text) { return text; }

    if ((text.length - length) > minDifference) {
      id = new Date().getTime();
      container = new Element('span');

      full = new Element('span', {'class': 'full', 'id': "full_text_for_#{id}".interpolate({id: id})});
      full.update(text);
      brief = new Element('span', {'class': 'brief', 'id': "brief_text_for_#{id}".interpolate({id: id})});
      brief.update(text.truncate(length));
      link = new Element('a', {
        'class': 'more',
        'href': '#',
        'onclick': "TextHelper.showFullText('#{id}'); return false;".interpolate({id: id})
      }).update("More");

      full.hide();
      container.insert(full);
      brief.insert(link);
      container.insert(brief);

      return container.innerHTML;
    }
    else {
      return text;
    }
  };

  spiceworks.ui.createSelect = function(options) {
    var select = new Element('select');
    options.each(function(o) {
      select.insert(new Element('option', {'value':o.value}).update(o.label));
    });
    return select;
  };

  spiceworks.ui.builders = {};
  spiceworks.ui.builders.statusBarPopup = {};

  spiceworks.ui.formatters = {};
  spiceworks.ui.formatters.statusBarPopup = {};

  spiceworks.ui.formatters.statusBarPopup.date = function(date) {
    return moment(date).fromNow();
  };

  spiceworks.ui.builders.statusBarPopup.list = function(data, options) {
    //[{message: "foo", icon: "/path/to/icon", type: "type" }]
    var ul, li, span, img, when, actions, classes, bottom, filter, formattedDate, dismiss;

    if (!options) { options = {}; }
    ul = new Element('ul', {'class': 'sui-status-list'});

    filter = data.any(function(d) { return !!d.filter; });
    data.each(function(row) {
      classes = [row.type];

      if (filter) { classes.push('filterable'); }
      if (row.unseen) { classes.push('unseen'); }
      if (row.filter) { classes.push("filter-#{filter}".interpolate({filter:row.filter})); }

      li = new Element('li', {'class': classes.join(" "), 'id':(row.id ? row.id : "")});
      if(row.icon) {
        li.insert(new Element('img', {src: row.icon}));
      }
      li.insert(new Element('h4', {'class':'title'}).update(row.title));

      if (row.subtitle) { li.insert(new Element('h5', {'class':'subtitle'}).update(row.subtitle));  }
      if (row.message) { li.insert(new Element('div', {'class':'message'}).update(row.message)); }

      bottom = new Element('p', {'class':'bottom'});
      li.insert(bottom);
      if (row.when) {
        when = row.when;
        span = new Element('span', {'class':'date', 'title': row.date }).update(when);
        bottom.insert(span);
      }

      if (row.action) {
        actions = new Element('span', {'class':'actions'});
        bottom.insert(actions);
        if (Object.isArray(row.action)) {
          row.action.each(function(action) { actions.insert(action); });
        } else {
          actions.insert(row.action);
        }
      }

      if (row.url) {
        li.setAttribute('click_url', row.url);
        li.addClassName('clickable');
      }

      if (row.dismissable) {
        li.addClassName('dismissable');
        li.insert(new Element('a', {'class':'sui-list-dismiss', 'href': '#', onclick: 'return false;', title: row.dismissable.title}).update("Dismiss"));
      }

      if (row.selectable) {
        li.insert({top:new Element('input', {type:'checkbox', name:row.selectable.name, value:row.selectable.value})});
        li.addClassName('selectable');
      }

      ul.insert(li);
    });

    ul.observe('click', function(event) {
      var url, e = event.element();
      if (e.tagName == "A") {
        if (e.hasClassName('sui-list-dismiss') && options.onDismiss) {
          options.onDismiss(e.up("li"));
        }
        else {
          return;
        }
      }
      else if (e.tagName.toLowerCase() == "input" && e.type.toLowerCase() == "checkbox") {
        if (e.checked) {
          e.up('li').addClassName('selected');
          if (options.onCheck) { options.onCheck(e.up('li')); }
        }
        else {
          e.up('li').removeClassName('selected');
          if (options.onUncheck) { options.onUncheck(e.up('li')); }
        }
      }
      else {
        if (e.tagName != "LI") {
          e = e.up('li');
        }

        url = e.getAttribute('click_url');
        if (url) {
          event.stop();
          window.location = url;
        }

      }
    });

    return ul;
  };

  spiceworks.ui.builders.statusBarPopup.navigationLinks = function(data, options) {
    var sectionList = new Element('ul', {'class':'sui-status-navigation-links'});

    options = Object.extend({
      'sectionWidth': 150, // pixels
      'sectionPadding': 10 // pixels
    }, options || {});

    var sectionCount = data.sections.size();

    sectionList.style.width = (sectionCount * (options.sectionWidth + 2 * options.sectionPadding)) + 'px';

    data.sections.each(function(section){
      var sectionListItem = new Element('li');
      sectionListItem.style.width = options.sectionWidth + 'px';
      sectionListItem.style.padding = options.sectionPadding + 'px';

      var sectionHeader = new Element('h6').insert( section.name.escapeHTML() );
      if(section.icons && section.icons['20px'] && section.icons['20px'].path ){
        sectionHeader.style.backgroundImage = "url(" + section.icons['20px'].path + ")";
        sectionHeader.style.paddingLeft = '28px';
      }
      sectionListItem.insert(sectionHeader);

      var linkList = section.links.inject(new Element('ul', {'class':'section'}), function(memo, link, index){
        return memo.insert(
          new Element('li').update(
            SPICEWORKS.community.linkTo(link.path).update(
              link.text.escapeHTML()
            )
          )
        );
      });
      sectionListItem.insert(linkList);

      sectionList.insert(sectionListItem);
    });

    return sectionList;
  };

  spiceworks.ui.community = (function(){
    function buildPanel(spec){
      spec = Object.extend({
        help:true,
        mainHeading:'',
        classes:'',
        helpHeading:'',
        helpItems:$A()
      }, spec || {});
      var panel = new Element('div', {'class':spec.classes + ' community-panel'});
      var main = new Element('div', {'class':'main'});
      var help = new Element('div', {'class':'help'});
      main.insert('<h3 class="section-header"><span>' + spec.mainHeading + '</span></h3>');

      help.insert('<h3 class="section-header"><span>' + spec.helpHeading + '</span></h3>');
      var helpList = new Element('ul');
      helpList.insert(spec.helpItems.collect(function(item, index){
        return '<li class="item-' + (index % 2 === 0 ? 'even' : 'odd') + ' ' + item.classes +'">' + item.visible + '</li>';
      }).join("\n"));
      help.insert(helpList);

      panel.insert(main);
      panel.insert(help);

      return panel;
    }

    return {
      buildPanel: buildPanel
    };
  })();

  /*
    If you're calling this from javascript, or have pretty simple content to put in, use:
    SUI.modalPopup.build(options)

    For rendering content on the server (using rails helpers modal_popup_*)
    SUI.modalPopup.set(content, options)

    options:
      DEFAULTS MARKED WITH ( )

      allowClose: true (false)    default is false
      size:'small' ('medium') 'full'
      positioning: ('fixed') 'scroll'
      effect: 'bounce', (none)

      name: // will add a class to the container
      id: // will add an id to the container
      buttons: // build out buttons with an array of hashes in order of appearance (left to right),
                  i.e. [{name:'Cancel', callback:'cancel'}, {name:'OK', callback: function(container) { // do some stuff }}]
        button options:
        name: // title of button
        callback: // javascript to run when clicked. 'cancel' is a special keyword that will cause the modal to close when clicked
        secondary: // will make the button a link

      buttonSize: 'small' ('medium') 'large'
  */
  spiceworks.ui.modalPopup = (function() {
    var spec, modalWrap, darkbox, footer, lightbox, contentContainer, contentInner, removeTimer;

    function exists() {
      return $("modal_container");
    }

    function setup() {
      var existing = exists();
      if (existing) { existing.remove(); }

      modalWrap = new Element("div", {'id':'modal_container'});
      darkbox = new Element("div", {'id': 'modal_darkbox', 'class': 'darkbox'});
      lightbox = new Element("div", {'id': 'modal_lightbox', 'class': 'lightbox'});

      contentContainer = new Element("div", {'class': 'modal-popup'});
      contentInner = new Element("div", {'class': "modal-inner"});

      contentContainer.insert(contentInner);
      lightbox.insert(contentContainer);
      modalWrap.insert(darkbox);
      modalWrap.insert(lightbox);
    }

    function adjustPosition() {
      if ((spec.positioning == 'scroll') || (spec.size == 'full')) { // default is fixed
        contentContainer.setStyle('top:' + ($(window).scrollY + 15 + "px;"));
      }
    }

    function show() {
      window.clearTimeout(removeTimer);
      contentContainer.addClassName("no-transition");

      adjustPosition();

      $(document.body).insert({bottom: modalWrap});
      contentContainer.removeClassName('no-transition');
      contentContainer.addClassName('transition');

      contentContainer.observe('click', function(event) {
        if (event.element().hasClassName('close-modal') || event.element().up('.close-modal')) {
          remove();
        }
      });

      SPICEWORKS.fire('app:modal:created', spec.id);
    }

    function hide(event) {
      if (event && event.memo && event.memo.id) {
        if (event.memo.id == contentContainer.getAttribute('id')) {
          remove();
        }
      }
      else {
        remove();
      }
    }

    function remove(){
      modalWrap.hide();

      removeTimer = window.setTimeout(function() {
        modalWrap.remove();
      }, 1000); // give the popup a second to fire off any ajax requests if needed before yanking it from the document

      SPICEWORKS.fire('app:modal:removed', spec.id);
    }

    function buildDefaults(specs) {
      // Note: spec is global so the show method can have access to it
      spec = Object.extend({size: 'medium', buttonSize: 'medium', allowClose: false, buttons: []}, specs);
      if (spec.allowClose) {
        var close = new Element('a', {'class':'close'}).update("close");
        close.observe('click', hide);
        contentInner.insert(close);
        contentContainer.addClassName("with-close");

        document.observe('keydown', function(e) {
          if (e && e.keyCode == Event.KEY_ESC) { hide(); }
        });
      }
      if (spec.style) {
        modalWrap.addClassName(spec.style);
      }

      if ((spec.positioning == 'scroll') || (spec.size == 'full')) { // default is fixed
        contentContainer.up().addClassName('scroll');
        contentContainer.setStyle('top:' + ($(window).scrollY + 15 + "px;"));
      }

      if (spec.effect) {
        contentContainer.addClassName(spec.effect);
      }

      if (spec.id) {
        contentContainer.setAttribute('id', spec.id);
      }

      contentContainer.addClassName(spec.size);
      contentContainer.addClassName(spec.name);

      SPICEWORKS.observe('app:ui:modal-popup:close', hide);
    }

    function buildTemplate(specs) {
      // Note: spec is global so the show method can have access to it
      spec = Object.extend({size: 'medium', buttonSize: 'medium', allowClose: false, buttons: []}, specs);

      if (spec.title) {
        contentInner.insert(new Element('div', {'class': 'header'}).update(new Element('h1').update(spec.title)));
      }

      contentInner.insert(new Element('div', {'class':'popup-body'}).update(spec.content));

      if (spec.buttons) {
        var buttons, callback;
        footer = new Element('div', {'class':'footer'});
        var rightSide = new Element('div', {'class': 'right'});

        spec.buttons.each(function(buttonSpec) {
          if (buttonSpec.callback == "cancel") {
            callback = hide;
          }
          else {
            callback = function() {
              buttonSpec.callback(contentContainer, {show: show, hide: hide});
            };
          }

          if (buttonSpec.secondary) {
            button = new Element('a', {'href':SUI.voidLink}).update(buttonSpec.name);
            button.observe('click', callback);
            if (buttonSpec.callback == 'cancel') { button.addClassName('cancel'); }
          }
          else {
            button = spiceworks.ui.button(buttonSpec.name, callback).addClassName(spec.buttonSize);
            button.addClassName('dark');
          }

          // if this modal has more than one button, make the first button the primary one
          if (spec.buttons.size() > 1 && spec.buttons.first() == buttonSpec) {
            button.addClassName('primary');
          }

          if (buttonSpec.left) {
            footer.insert(button);
          }
          else {
            rightSide.insert({bottom: button});
          }
        });
        footer.insert(rightSide);

        if (spec.buttons.length > 0) {
          contentInner.insert({bottom: footer});
        }
      }
    }

    return {
      exists: function() {
        return exists();
      },
      build: function(options) { // You provide the keys, and this will build the content
        setup();
        buildTemplate(Object.extend({
          size: 'medium', buttonSize: 'medium'
        }, options));

        buildDefaults(options);

        return {
          container: contentContainer,
          footer: footer,
          show: show,
          hide: hide
        };
      },
      set: function(content, options) { // Use set when you're creating the content yourself. Use this when you're using rails helpers to generate content

        setup();
        if (typeof content == "object") {
          // helps to set default title and stuff
          buildTemplate(Object.extend({
            size: 'medium', buttonSize: 'medium'
          }, content));
        }
        buildDefaults(options);
        if (typeof content != "object") {
          // probably a string
          contentInner.insert(content);
        }
        return {
          container: contentContainer,
          show: show,
          hide: hide
        };
      }
    };
  })();

})(SPICEWORKS);
/**
  * A collection of specific charts built on top of D3.
  *
  * @requires jQuery
  * @requires d3
  * @requires SVGWeb (for IE support)
  */


(function (spiceworks) {

  spiceworks.ui.d3 = (function(){

    /* -----------------------------------------------------------
     * Private
       =========================================================== */

     /**
      * Builds and displays an area chart.
      *
      * @function
      * @name SPICEWORKS.ui.d3.areaChart
      * @param {data} The data that will be rendered on the chart. TODO: document the format?
      * @param {elem} DOM element that the chart will be rendered inside.
      * @param {width} [Optional] Width in pixels
      * @param {height} [Optional] Height in pixels
      * @returns {null}
      */
      function areaChart(data, elem, width, height, fillStyle, lineStyle) {
        // var w = width || 400,
        //     h = height || 200,
        //     fill = fillStyle || "rgba(31,119,180,0.6)",
        //     line = lineStyle || "rgba(31,119,180,1)",
        //     max = pv.max(data, function(d){ return d.value; }),
        //     segments = data.length -1,
        //     first = data[0].label,
        //     last = data[segments].label,
        //     x = pv.Scale.linear( pv.Format.date(first),  pv.Format.date(last) ).range(0, w),
        //     y = pv.Scale.linear().domain(0, max * 1.1).range(0, h);
        //
        // elem = elem || "body";
        // var vis = new pv.Panel()
        //    .canvas(elem)
        //    .width(w)
        //    .height(h)
        //    .bottom(20)
        //    .left(0)
        //    .right(0)
        //    .top(5)
        //    .strokeStyle("#ccc");
        //
        // // X Axis
        // vis.add(pv.Rule)
        //   .data(data)
        //   .left(function(d) { return this.index * (w / segments); })
        //   .strokeStyle("rgba(200, 200, 200, .4)")
        // .anchor("bottom").add(pv.Label)
        //   .textAlign(function(d) {
        //     if (this.index === 0) {
        //       return "left";
        //     } else if (this.index == segments) {
        //       return "right";
        //     } else {
        //       return "center";
        //     }
        //   })
        //   .text(function(d) { return d.label; });
        //
        // // Charted data
        // vis.add(pv.Area)
        //   .data(data)
        //   .left(function(d) { return this.index * (w / segments); })
        //   .bottom(0)
        //   .height(function(d) { return y(d.value); })
        //   .fillStyle(fill)
        // .anchor("top")
        //   .add(pv.Line)
        //   .strokeStyle(line)
        //   .lineWidth(3);
        //
        // // Y Axis
        // vis.add(pv.Rule)
        //   .data(y.ticks())
        //   .bottom(y)
        //   .strokeStyle("rgba(200, 200, 200, .4)")
        //   .visible(function(d) {
        //     // Hide the first label and any that
        //     // aren't whole numbers
        //     if (this.index === 0) { return false; }
        //     return (d % 1) === 0;
        //   })
        // .anchor("left").add(pv.Label)
        //   .textStyle("rgba(120, 120, 120, .8)")
        //   .textAlign("left")
        //   .textBaseline("top")
        //   .text(function(d) { return d; });
        //
        // vis.render();
      }

      /**
       * Builds and displays a grouped bar chart.
       *
       * @function
       * @name SPICEWORKS.ui.d3.groupedBarChart
       * @param {data} The data that will be rendered on the chart.
       *   TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @param {options} [Optional] Options that determine the behavior of the chart
       * @returns {null}
       */
      function groupedBarChart(data, elem, width, height, options) {
        var color = d3.interpolateRgb("#aad", "#556");

        chartData = data.data;

        var p = 20,
            w = width || 600,
            h = (height || 200) - 0.5 - p,
            // x = d3.scale.linear().range([0, w]),
            // y = d3.scale.linear().range([0, h - 40]);
            // mx = m,
            stack_size = chartData.length,
            mx = chartData[0].length,
            my = d3.max(chartData, function(d) {
              return d3.max(d, function(d) {
                return d.y0 + d.y;
              });
            }),
            mz = d3.max(chartData, function(d) {
              return d3.max(d, function(d) {
                return d.y;
              });
            }),
            x = function(d) { return d.x * w / mx; },
            y0 = function(d) { return h - d.y0 * h / my; },
            y1 = function(d) { return h - (d.y + d.y0) * h / my; },
            y2 = function(d) { return d.y * h / mz; }; // or `my` to not rescale

        var vis = d3.select(elem)
          .append("svg:svg")
            .attr("width", w)
            .attr("height", h + p);

        var layers = vis.selectAll("g.layer")
            .data(chartData)
          .enter().append("svg:g")
            .style("fill", function(d, i) { return color(i / (stack_size - 1)); })
            .attr("class", "layer");

        var bars = layers.selectAll("g.bar")
            .data(function(d) { return d; })
          .enter().append("svg:g")
            .attr("class", "bar")
            .attr("transform", function(d) { return "translate(" + x(d) + ",0)"; });

        bars.append("svg:rect")
            .attr("width", x({x: 0.9}))
            .attr("x", 0)
            .attr("y", h)
            .attr("height", 0)
          .transition()
            .delay(function(d, i) { return i * 10; })
            .attr("y", y1)
            .attr("height", function(d) { return y0(d) - y1(d); });

        var labels = vis.selectAll("text.label")
            .data(chartData[0])
          .enter().append("svg:text")
            .attr("class", "label")
            .attr("x", x)
            .attr("y", h + 6)
            .attr("dx", x({x: 0.45}))
            .attr("dy", ".71em")
            .attr("text-anchor", "right")
            .text(function(d, i) { return data.labels[i]; });

        vis.append("svg:line")
            .attr("x1", 0)
            .attr("x2", w - x({x: 0.1}))
            .attr("y1", h)
            .attr("y2", h);

      }

      /**
       * Builds and displays a stacked bar chart.
       *
       * @function
       * @name SPICEWORKS.ui.d3.stackedBarChart
       * @param {data} The data that will be rendered on the chart.
       *   TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @param {options} [Optional] Options that determine the behavior of the chart
       * @returns {null}
       */
      function stackedBarChart(data, elem, width, height, options) {

      }

      /**
       * Builds and displays a pie chart.
       *
       * @function
       * @name SPICEWORKS.ui.d3.pieChart
       * @param {data} The data that will be rendered on the chart.
       *   TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @param {options} [Optional] Options that determine the behavior of the chart
       * @returns {null}
       */
      function pieChart(data, elem, width, height, options) {
        var w = width || 200,
            h = height || 200,
            r = Math.min(w, h) / 2,
            color = d3.scale.category20(),
            donut = d3.layout.pie().value(function(d) { return d.value; }).sort(d3.descending),
            arc = d3.svg.arc().innerRadius(r * 0).outerRadius(r);

        // Populate defaults (do we need a d3.extend?)
        options = jQuery.extend({
          showLabels: true
        }, options || {});

        var vis = d3.select(elem)
          .append("svg:svg")
            .data([data])
            .attr("width", w)
            .attr("height", h);

        var arcs = vis.selectAll("g.arc")
            .data(donut)
          .enter().append("svg:g")
            .attr("class", "arc")
            .attr("transform", "translate(" + r + "," + r + ")");

        arcs.append("svg:path")
            .attr("fill", function(d, i) { return color(i); })
            .attr("d", arc);

        if (options.showLabels) {
          arcs.append("svg:text")
              .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
              .attr("dy", ".35em")
              .attr("text-anchor", "middle")
              .attr("display", function(d) { return d.value > 0.15 ? null : "none"; })
              .text(function(d, i) {
                return data[i].label;
              });
        }
      }

      /**
       * Builds and displays a map showing data distribution across the US.
       *
       * @function
       * @name SPICEWORKS.ui.d3.usDistributionMap
       * @param {dataUrl} The URL from which data will be fetched that will be rendered on the chart.
       *   TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @param {options} [Optional] Options that determine the behavior of the chart
       * @returns {null}
       */
      function usDistributionMap(dataUrl, elem, width, height, options) {
        var data,
            follower_data,
            stateDataUrl = "/assets/d3/data/us-states.json",
            blues = ['247,251,255', '222,235,247', '198,219,239', '158,202,225',
                     '107,174,214', '66,146,198', '33,113,181', '8,81,156', '8,48,107'];

        // TODO: Make scale and translation relative parameters
        var path = d3.geo.path().projection(d3.geo.albersUsa().scale(500).translate([340,150]));

        var svg = d3.select(elem)
          .append("svg:svg")
          .attr("width", width)
          .attr("height", height);

        var states = svg.append("svg:g")
            .attr("id", "states")
            .attr("style", "stroke: #666666; stroke-width: .25px;");

        // Load raw state data
        d3.json(stateDataUrl, function(json) {
          data = json.features;

          // Load and merge counts
          d3.json(dataUrl, function(json) {
            follower_data = json;

            var domain_values = d3.values(follower_data);
            domain_values.push(0);
            var color = d3.scale.quantile()
              .domain(domain_values)
              .range(blues);

            states.selectAll("path")
                .data(data)
              .enter().append("svg:path")
                .attr("id", function(d) { return d.id; })
                .attr("d", path)
                .attr("style", function(d) {
                  return "fill: rgb(" + color(follower_data[d.id] || 0) + ")";
                })
              .append("svg:title")
                .text(function(d) { return STATE_NAMES[d.id] + " (" + (follower_data[d.id] || 0) + ")"; });
          });

        });
      }

      /**
       * Builds and displays a map showing data distribution across the world.
       *
       * @function
       * @name SPICEWORKS.ui.d3.worldDistributionMap
       * @param {dataUrl} The URL from which data will be fetched that will be rendered on the chart.
       *   TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @param {options} [Optional] Options that determine the behavior of the chart
       * @returns {null}
       */
      function worldDistributionMap(dataUrl, elem, width, height, options) {
        var data,
            follower_data,
            countryDataUrl = "/assets/d3/data/world-countries.json",
            blues = ["rgb(255,238,230)", "rgb(254,221,204)", "rgb(254,204,179)",
                     "rgb(253,187,153)", "rgb(253,171,128)", "rgb(253,154,102)",
                     "rgb(252,137,76)", "rgb(252,120,51)", "rgb(251,103,26)"];

        var opts = jQuery.extend(options, {
          scale: 600,
          translate: [300,175]
        });

        var xy = d3.geo.mercator().scale(opts.scale).translate(opts.translate),
            path = d3.geo.path().projection(xy);

        var tooltip = d3.select(elem).append("div").attr("class", "maptooltip").style("visibility", "hidden");
        tooltip.append("div").attr("class", "name").text("name");
        tooltip.append("div").attr("class", "count").text("count");

        var countries = d3.select(elem)
          .append("svg:svg")
            .attr("width", width)
            .attr("height", height)
            .append("svg:g")
              .attr("id", "countries");

        countries.append("svg:rect")
          .attr("width", width)
          .attr("height", height)
          .attr("style", "fill: rgb(255,255,255);")
          .on("mouseover", function(d, i){
            tooltip.select(".name").text("");
            tooltip.select(".count").text("");
            return tooltip.style("visibility", "hidden");
          })
          .on("click", function() { d3.event.stopPropagation(); return false; });

        var equator = d3.select("svg")
          .append("svg:line")
            .attr("x1", "0%")
            .attr("x2", "100%");

        d3.json(countryDataUrl, function(collection) {
          data = collection.features;

          d3.json(dataUrl, function(json) {
            if (json === null) {
              jQuery(elem).prepend("<div style='margin-top: 150px; color: #666; font-style: italic; text-align: center;'>No data to display</div>");
              return;
            }

            follower_data = json;

            var domain_values = d3.values(follower_data);
            domain_values = _.uniq(domain_values);
            var color = d3.scale.quantile()
              .domain(domain_values)
              .range(blues);

            // Build a legend (HTML)
            // Styles are in application.css
            var legend = d3.select(elem)
              .append("div")
                .attr("class", "maplegend");

            var marker = legend.selectAll("div.marker")
                .data(color.range())
              .enter().append("div")
                .attr("class", "marker");

            marker.append("div")
              .attr("class", "swatch")
              .attr("style", function(d, i) {
                return "background: " + d + ";";
              });

            marker.append("div")
              .attr("class", "label")
              .text(function(d, i) {
                return legend_text(color, i);
              });

            // Display the countries with follower counts
            countries
              .selectAll("path")
                .data(data)
              .enter().append("svg:path")
                .attr("d", path)
                .attr("data-name", function(d) { return d.properties.name; })
                .attr("data-count", function(d) { return follower_data[d.properties.name] || 0; })
                .attr("style", function(d) {
                  return "stroke: #AAAAAA; stroke-width: .125px; fill: " + color(follower_data[d.properties.name] || 0, 0.5) + "";
                })
                .on("mouseover", function(d, i){
                  var e = d3.event;
                  e.stopPropagation();

                  tooltip.select(".name").text( d.properties.name );
                  tooltip.select(".count").text( (follower_data[d.properties.name] || 0) + " Followers");
                  return tooltip.style("visibility", "visible");
                })
                .on("mousemove", function(d, i){
                  var e = d3.event;
                  e.stopPropagation();

                  // For   Webkit       Firefox     IE
                  var x = (e.offsetX || e.layerX || e.clientX) - 50;
                  var y = (e.offsetY || e.layerY || e.clientY) - 30;
                  return tooltip.style("top", y + "px").style("left", x + "px").style("visibility", "visible");
                });
          });
        });

        function legend_text(color, idx) {
          var start = (idx === 0) ? color.domain().min() : color.quantiles()[idx - 1];
          var end = (idx == color.quantiles().length) ? color.domain().max() : color.quantiles()[idx];
          return start + " - " + end;
        }
      }

      /* ---------------------------------------
       * Internal (for testing)
       * --------------------------------------- */
      /* Inspired by Lee Byron's test data generator. */
      function stream_layers(n, m, o) {
        if (arguments.length < 3) { o = 0; }
        function bump(a) {
          var x = 1 / (0.1 + Math.random()),
              y = 2 * Math.random() - 0.5,
              z = 10 / (0.1 + Math.random());
          for (var i = 0; i < m; i++) {
            var w = (i / m - y) * z;
            a[i] += x * Math.exp(-w * w);
          }
        }
        return d3.range(n).map(function() {
            var a = [], i;
            for (i = 0; i < m; i++) {
              a[i] = o + o * Math.random();
            }
            for (i = 0; i < 5; i++) {
              bump(a);
            }
            return a.map(stream_index);
          });
      }

      /* Another layer generator using gamma distributions. */
      function stream_waves(n, m) {
        return d3.range(n).map(function(i) {
          return d3.range(m).map(function(j) {
              var x = 20 * j / m - i / 3;
              return 2 * x * Math.exp(-0.5 * x);
            }).map(stream_index);
          });
      }

      function stream_index(d, i) {
        return {x: i, y: Math.max(0, d)};
      }

      var STATE_NAMES = {
        'AL': 'Alabama',
        'AK': 'Alaska',
        'AS': 'America Samoa',
        'AZ': 'Arizona',
        'AR': 'Arkansas',
        'CA': 'California',
        'CO': 'Colorado',
        'CT': 'Connecticut',
        'DE': 'Delaware',
        'DC': 'District of Columbia',
        'FM': 'Micronesia1',
        'FL': 'Florida',
        'GA': 'Georgia',
        'GU': 'Guam',
        'HI': 'Hawaii',
        'ID': 'Idaho',
        'IL': 'Illinois',
        'IN': 'Indiana',
        'IA': 'Iowa',
        'KS': 'Kansas',
        'KY': 'Kentucky',
        'LA': 'Louisiana',
        'ME': 'Maine',
        'MH': 'Islands1',
        'MD': 'Maryland',
        'MA': 'Massachusetts',
        'MI': 'Michigan',
        'MN': 'Minnesota',
        'MS': 'Mississippi',
        'MO': 'Missouri',
        'MT': 'Montana',
        'NE': 'Nebraska',
        'NV': 'Nevada',
        'NH': 'New Hampshire',
        'NJ': 'New Jersey',
        'NM': 'New Mexico',
        'NY': 'New York',
        'NC': 'North Carolina',
        'ND': 'North Dakota',
        'OH': 'Ohio',
        'OK': 'Oklahoma',
        'OR': 'Oregon',
        'PW': 'Palau',
        'PA': 'Pennsylvania',
        'PR': 'Puerto Rico',
        'RI': 'Rhode Island',
        'SC': 'South Carolina',
        'SD': 'South Dakota',
        'TN': 'Tennessee',
        'TX': 'Texas',
        'UT': 'Utah',
        'VT': 'Vermont',
        'VI': 'Virgin Island',
        'VA': 'Virginia',
        'WA': 'Washington',
        'WV': 'West Virginia',
        'WI': 'Wisconsin',
        'WY': 'Wyoming'
      };

    /* -----------------------------------------------------------
     * Public
       =========================================================== */
    return {
      areaChart: areaChart,
      groupedBarChart: groupedBarChart,
      pieChart: pieChart,
      usDistributionMap: usDistributionMap,
      worldDistributionMap: worldDistributionMap
    };

  })();
})(SPICEWORKS);
/**
  * A collection of specific charts built on top of Protovis.
  *
  * @requires Prototype
  * @requires Protovis
  * @requires SVGWeb (for IE support)
  */


(function (spiceworks) {

  spiceworks.ui.protovis = (function(){

    /* -----------------------------------------------------------
     * Private
       =========================================================== */

     /**
      * Builds and displays an area chart.
      *
      * @function
      * @name SPICEWORKS.ui.protovis.areaChart
      * @param {data} The data that will be rendered on the chart. TODO: document the format?
      * @param {elem} DOM element that the chart will be rendered inside.
      * @param {width} [Optional] Width in pixels
      * @param {height} [Optional] Height in pixels
      * @returns {null}
      */
      function areaChart(data, elem, width, height, fillStyle, lineStyle) {
        var w = width || 400,
            h = height || 200,
            fill = fillStyle || "rgba(31,119,180,.6)",
            line = lineStyle || "rgba(31,119,180,1)",
            max = pv.max(data, function(d){ return d.value; }),
            segments = data.length -1,
            first = data[0].label,
            last = data[segments].label,
            x = pv.Scale.linear( pv.Format.date(first),  pv.Format.date(last) ).range(0, w),
            y = pv.Scale.linear().domain(0, max * 1.1).range(0, h);

        elem = elem || "body";
        var vis = new pv.Panel()
           .canvas(elem)
           .width(w)
           .height(h)
           .bottom(20)
           .left(0)
           .right(0)
           .top(5)
           .strokeStyle("#ccc");

        // X Axis
        vis.add(pv.Rule)
          .data(data)
          .left(function(d) { return this.index * (w / segments); })
          .strokeStyle("rgba(200, 200, 200, .4)")
        .anchor("bottom").add(pv.Label)
          .textAlign(function(d) {
            if (this.index === 0) {
              return "left";
            } else if (this.index == segments) {
              return "right";
            } else {
              return "center";
            }
          })
          .text(function(d) { return d.label; });

        // Charted data
        vis.add(pv.Area)
          .data(data)
          .left(function(d) { return this.index * (w / segments); })
          .bottom(0)
          .height(function(d) { return y(d.value); })
          .fillStyle(fill)
        .anchor("top")
          .add(pv.Line)
          .strokeStyle(line)
          .lineWidth(3);

        // Y Axis
        vis.add(pv.Rule)
          .data(y.ticks())
          .bottom(y)
          .strokeStyle("rgba(200, 200, 200, .4)")
          .visible(function(d) {
            // Hide the first label and any that
            // aren't whole numbers
            if (this.index === 0) { return false; }
            return (d % 1) === 0;
          })
        .anchor("left").add(pv.Label)
          .textStyle("rgba(120, 120, 120, .8)")
          .textAlign("left")
          .textBaseline("top")
          .text(function(d) { return d; });

        vis.render();
      }

      /**
       * Builds and displays a pie chart.
       *
       * @function
       * @name SPICEWORKS.ui.protovis.areaChart
       * @param {data} The data that will be rendered on the chart. TODO: document the format?
       * @param {elem} DOM element that the chart will be rendered inside.
       * @param {width} [Optional] Width in pixels
       * @param {height} [Optional] Height in pixels
       * @returns {null}
       */
      function pieChart(data, elem, width, height) {
        var w = width || 200,
            h = height || 200,
            r = w / 2,
            max = pv.sum(data, function(d){ return d.value; }),
            a = pv.Scale.linear(0, max).range(0, 2 * Math.PI);

        var vis = new pv.Panel()
            .canvas(elem)
            .width(w)
            .height(h);

        vis.add(pv.Wedge)
            .data(data)
            .outerRadius(r)
            .angle(function(d) { return a(d.value); })
            .title(function(d) { return d.value; })
          .add(pv.Wedge) // invisible wedge to offset label
            .visible(function(d) { return d.value > 0.15; })
            .innerRadius(0.25 * r)
            .outerRadius(0.75 * r)
            .fillStyle(null)
          .anchor("center").add(pv.Label)
            .textAngle(0)
            .text(function(d) { return d.label; });

        vis.render();

      }

    /* -----------------------------------------------------------
     * Public
       =========================================================== */
    return {
      areaChart: areaChart,
      pieChart: pieChart
    };

  })();
})(SPICEWORKS);
/**
  * A collection of specific charts built on top of Highcharts.
  *
  * @requires Highcharts
  */


(function (spiceworks) {

  spiceworks.ui.highcharts = (function(){

    /* -----------------------------------------------------------
     * Private
       =========================================================== */

     var colors = ["#FF6904", "#808080", "#B3B3B3", "#DEDEDE"];

     /**
      * Builds and displays a market share pie chart.
      *
      * @function
      * @name SPICEWORKS.ui.highcharts.marketShareChart
      * @param {data} The data that will be rendered on the chart. TODO: document the format?
      * @param {elem} DOM element that the chart will be rendered inside.
      * @returns {null}
      */
      function marketShareChart(data, renderElem) {

        new Highcharts.Chart({
          chart: {
            renderTo: renderElem,
            type: 'pie',
            spacingTop: 5,
            spacingRight: 5,
            spacingBottom: 5,
            spacingLeft: 5
          },
          plotOptions: {
            pie: {
              dataLabels: false
            }
          },
          title: { text: '' },
          tooltip: {
            formatter: function() {
              return '<b>' + formatLabel(this.point.name) + '</b><br/>' + this.point.value + '%';
            },
            positioner: function (labelWidth, labelHeight, point) {
              return { x: (55 - labelWidth/2), y: (55 - labelHeight/2) };
            },
            style: {
              fontWeight: 'normal',
              fontSize: '11px'
            }
          },
          series: [{
            name: 'Market Share',
            data: formatForHighcharts(data),
            size: '100%',
            innerSize: '60%'
          }]
        });
      }

      function formatForHighcharts(data) {
        var idx = 0;
        return _.collect(data, function(datum) {
          return _.extend({name: datum.label, y: parseFloat(datum.value), color: colors[idx++]}, datum);
        });
      }

      // There's a rails helper in market_share_helper.rb that needs
      // to be kept in sync with this code
      function formatLabel(name) {
        labels = {
          "3com": "3Com",
          "d_link": "D-Link",
          "hp": "HP",
          "ibm": "IBM",
          "mcafee_virusscan": "McAfee Virusscan",
          "on site": "On&nbsp;Site",
          "sonicwall": "SonicWALL",
          "vmware": "VMware",
          "watchguard": "WatchGuard"
        };
        label = labels[name] || _.titleize(name);
        return label.replace(" ", "<br>").replace("Office2", "Office 2").replace("&nbsp;", " ");
      }

    /* -----------------------------------------------------------
     * Public
       =========================================================== */
    return {
      marketShareChart: marketShareChart
    };

  })();
})(SPICEWORKS);
(function (spiceworks) {

  // == SPICEWORKS.utils ==
  // A namespace for things that don't fit anywhere else currently.  These are mostly related to integration
  // with external services and the like.
  spiceworks.utils = {};

  // Include an external script
  // EX:
  //   SPICEWORKS.utils.include('http://myserver/my.js');
  spiceworks.utils.include = function (script_filename, callback) {
    var head = document.getElementsByTagName('head')[0],
        script = document.createElement('script');

    script.type = 'text/javascript';
    script.src = script_filename;

    if (callback){
      var done = false;
      script.onload = script.onreadystatechange = function(){
        if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {
          done = true;
          callback();

          // Handle memory leak in IE
          script.onload = script.onreadystatechange = null;
          script.parentNode.removeChild(script);
        }
      };
    }

    head.appendChild(script);
  };

  // Load external JSONP and pass it into a supplied callback function.
  // Any query parameters should be passed in as a Javascript object.
  // EX:
  //   SPICEWORKS.utils.jsonp('http://example.com/foo.js', {'foo':'bar'}, function(response){
  //   });
  spiceworks.utils.jsonpCallbacks = {}; // Container for callback functions
  spiceworks.utils.jsonp = function(url, params, callback, identifier) {
    if(!identifier){
      identifier = Math.floor(Math.random()*10000000);
    }
    spiceworks.utils.jsonpCallbacks[identifier] = callback;
    url = url + '?' + Object.toQueryString(Object.extend(params, {
      'callback':'SPICEWORKS.utils.jsonpCallbacks[' + identifier.toJSON() + ']'
    }));
    spiceworks.utils.include(url, function(){
      delete spiceworks.utils.jsonpCallbacks[identifier];
    });
  };

  // Quickly add some style to the document.  Any valid Stylesheet style string works here.
  // EX:  SPICEWORKS.utils.addStyle("body { background-color: red }");
  spiceworks.utils.addStyle = function (cssText) {
    var styleNode = document.createElement('style');
    styleNode.setAttribute("type", "text/css");
    if (styleNode.styleSheet) { // workaround for IE
      styleNode.styleSheet.cssText = cssText;
    } else if (Prototype.Browser.WebKit) {
      styleNode.innerText = cssText;
    } else { // DOM
      styleNode.update(cssText);
    }
    $$('head').first().appendChild(styleNode);
  };

  spiceworks.utils.includeStyle = function (cssUrl) {
    // <link href="/stylesheets/print.css?1251735325" media="print" rel="stylesheet" type="text/css">
    var styleNode = document.createElement('link');
    styleNode.setAttribute("type", "text/css");
    styleNode.setAttribute("href", cssUrl);
    styleNode.setAttribute("rel", "stylesheet");
    $$('head').first().appendChild(styleNode);
  };

  // == SPICEWORKS.utils.google ==
  // Namespace for all sorts of nice google goodies
  // Users will need to set their own "key" by setting
  //    SPICEWORKS.utils.google.key = 'mykey';
  spiceworks.utils.google = function () {
    var googleLoaded = false,
        google = null,
        that;

    that = {
      key: 'ABQIAAAAXU7eNwZ9M4Sc9cn16StyDBRFChKT55K5FMfS9iKz1mkixBESPBSb4vJEgLxDzIfGJkiGB3x3myIrcQ',

      withGoogle: function (callback) {
        if (!googleLoaded) {
          spiceworks.utils.include("http://www.google.com/jsapi?key=" + that.key, function () {
            google = window.google; // google is global, just grab for now.
            googleLoaded = true;

            callback(google);
          });
        } else {
          callback(google);
        }
      },

      withMaps: function (callback) {
        that.withGoogle(function (google) {
          google.load('maps', '2.x', {callback: function () {
            callback(GMap2);
          }});
        });
      },

      withVisualizations: function (packages, callback) {
        that.withGoogle(function (google) {
          google.load("visualization", "1", {packages: packages, callback: function () {
            callback(google.visualization);
          }});
        });
      }
    };

    return that;
  }();

  // SPICEWORKS.utils.focusTimer(10, false, callback) #=> calls function every 10 seconds when window is focused
  // SPICEWORKS.utils.focusTimer(10, 20, callback) #=> calls function every 10 seconds when window is focused, every 20 when window is not focused

  // Will also fire callback immediately when window is focused if focusinterval has passed since the last time callback was called
  spiceworks.utils.focusTimer = function(focusInterval, blurInterval, callback) {
    focusInterval = focusInterval * 1000;
    if (blurInterval) { blurInterval = blurInterval * 1000; }

    var blurredAt, lastCalledAt, timer, delay, focused, timeSince;

    function doCallback() {
      lastCalledAt = new Date();
      callback();
      clearTimeout(timer);
      delay = focused ? focusInterval : blurInterval;
      if (delay) { // blurInterval might be false
        timer = window.setTimeout(doCallback, delay);
      }
    }

    function delayCallback(delay) {
      timer = window.setTimeout(doCallback, delay);
    }

    function registerBlur() {
      focused = false;
      blurredAt = new Date();
      clearTimeout(timer);
      if (blurInterval) {
        delayCallback(blurInterval);
      }
    }

    function registerFocus() {
      focused = true;
      clearTimeout(timer);

      timeSince = 0;
      if (lastCalledAt) { timeSince = (new Date().getTime()) - lastCalledAt.getTime(); }

      if (timeSince >= focusInterval) {
        doCallback();
      }
      else {
        delay = focusInterval - timeSince;
        delayCallback(delay);
      }
    }

    function unload() {
      clearTimeout(timer);
      Event.stopObserving(window, 'blur', registerBlur);
      Event.stopObserving(window, 'focus', registerFocus);
      Event.stopObserving(document, 'focusout', registerBlur);
      Event.stopObserving(document, 'focusin', registerFocus);
    }

    if (Prototype.Browser.IE) {
      /* IE's window blur and window focus events are flaky to say the least */
      Event.observe(document, 'focusout', registerBlur);
      Event.observe(document, 'focusin', registerFocus);
    }
    else {
      Event.observe(window, 'blur', registerBlur);
      Event.observe(window, 'focus', registerFocus);
    }

    focused = true;
    delay = focused ? focusInterval : blurInterval;
    timer = window.setTimeout(doCallback, delay);

    return {
      callback: callback,
      unload: unload
    };
  };

  spiceworks.utils.unloader = function(object, events, callback) {
    if (!events) { return; }
    if (!object) { object = document; }

    events = $A([events]).flatten();
    events.each(function(eventName) {
      var unload = function(){
        callback();
        object.stopObserving(eventName, unload);
      };

      object.observe(eventName, unload);
    });
  };

  window.p$ = spiceworks.utils.p$ = function(jQueryObj) {
    return $(jQueryObj.get(0));
  };

  spiceworks.utils.form = (function(){
    var initKeypressRemoteFormSubmit = function(formId){
      initKeypressFormSubmit(formId, $(formId).onsubmit);
    };

    var initKeypressFormSubmit = function(formId, submitFn) {
      Event.observe(formId, 'keydown', function(element) {
        if (element.keyCode == 13) {
          if (submitFn && submitFn.constructor === Function) {
            submitFn.call($(formId));
          } else {
            $(formId).submit();
          }
        }
      });
    };

    return {
      initKeypressRemoteFormSubmit: initKeypressRemoteFormSubmit,
      initKeypressFormSubmit: initKeypressFormSubmit
    };
  })();

})(SPICEWORKS);
//  Fetches and a recommendation instance and displays it on the page.
//  Usage: SPICEWORKS.recommendations(5)  #=> displays RecommendationInstance id 5
//  A custom render function can be passed in to display the recommendation in a different location.
(function(spiceworks, $) {
  spiceworks.recommendations = function(id, render) {
      var msg, data;

      function dismiss() {
        $.ajax('/api/recommendations/dismiss', {type: 'POST', data: {id: id} });
      }
      function log(event, options) {
        options = Object.extend({
          type: 'POST',
          data: {id: id, event: event},
          async: true
        }, options || {} );
        $.ajax('/api/recommendations/log', options);
      }
      function launchPopup() {
        SUI.modalPopup.build({
          title: "<span class='spicetip-header'>SpiceTip</span>",
          content: "<div class='popup-container' style='height: 160px'></div>",
          allowClose: true,
          name: "recommendation",
          size: ""
        }).show();
        $('div.modal-popup div.popup-body').css({ padding: 0, overflow: 'visible', position: 'relative' });
        $('.popup-body').append($('<div class="sui-status-overlay">').css({
          position: "absolute",
          top: 0, right: 0, bottom: 0, left: 0,
          background: "white url(//static.spiceworks.com/assets/app/deliveries/recommendations/loading-pepper-bc5a910010fc4acbdfbab78bc951c3b2.gif) center 58px no-repeat"
        }));

        // fetch popup data from server
        $.ajax({
          url: "/app/recommendations/show",
          data: {recommendationInstanceId: id, results: data, ehash: Application.ehash, uuid: Application.uuid},
          success: function(response) {
            // inject HTML
            $('.popup-container').html(response)
              .animate({ height: $('.recommendation-popup').outerHeight() }, 600,
                function() { jQuery(this).css("height", "auto"); });
            $('.sui-status-overlay').fadeOut(600);

            // register click handlers
            $('.pref-button').click(function(event) {
              callbacks.log($(this).data("logAction"));
            });
            $('.pref-button[data-log-action="dislike"]').click(function(event) {
              callbacks.dismiss();
            });
            $('.action-button').not('.dropdown').click(function(event) {
              var $btn = $(this);
              callbacks.log('action-' + $btn.data("logAction"), {async: false});
            });
            $('.dropdown-menu a').click(function(event) {
              event.preventDefault();
              var $target = $(event.target);
              var $btn = $(this).parent('.dropdown-menu').siblings('.action-button');
              callbacks.log('action-' + $btn.data("logAction"), {complete: function() {
                window.location = $target.attr('href');
              }});
            });
          }
        });
      }

      if (!render) {
        render = function(message, data, callbacks) {
          var recommendationHTML =
            $('<span>', {'id': 'recommendation-notification', 'class': 'one-liner'})
              .css({display: "none"})
              .html($('<span>', {'id': 'recommendations'}).html(message))
              .wrap('<div>').parent().html(); // grr... no outerHTML() method in jQuery.

          Messaging.push("recommendation-notification", recommendationHTML, {dismissable: true});

          $('#recommendation-notification').fadeIn().click(function(event) {
            event.preventDefault();
            callbacks.launchPopup();
            callbacks.log('click');
          });
          $('#recommendation-notification + .dismisser').click(function(event) {
            callbacks.dismiss();
          });
        };
      }

      var generateMessage = function(alertTemplate, data) {
        // helper to prettify a list. e.g. [1,2,3,4] => "1, 2, 3 and 4"
        _listjoin = function (arr) {
          var last2 = arr.slice(-2).join(" and ");
          return arr.slice(0,-2).concat(last2).join(', ');
        };

        return (new Function("data", alertTemplate))(data);
      };

      var callbacks = {
        dismiss: dismiss,
        log: log,
        launchPopup: launchPopup
      };

      $.getJSON('/api/recommendations/' + id, function(response) {
        data = response.data;
        msg = generateMessage(response.alertTemplate, data);
        render(msg, data, callbacks);
        callbacks.log("show");
      });

      return callbacks;
  };
})(SPICEWORKS, jQuery);








































// Copyright Â© 2006-10 Spiceworks Inc. All Rights Reserved. http://www.spiceworks.com
var Browser = {
  IE6:false,
  IE7:false,
  IE8:false,
  hasStylesheet: function (stylesheet) {
    var document_stylesheets;
    var count;
    var sheet;
    document_stylesheets = document.styleSheets;
    if (!document_stylesheets){
      return false;
    }
    count = document_stylesheets.length;
    while(count){
      sheet = document_stylesheets[--count];
      if(sheet.href){
        if(sheet.href.indexOf(stylesheet) > 0){
          return true;
        }
      }
    }
    return false;
  }
};

var User = {};
var UserPermissions = {};

var SpiceworksApplication = {};

var Application = {
  runMode:'production',
  initialize: function(){
    this.indicator = $('application_activity_indicator');
  },
  narrowLayout: function(){
    $(document.body).addClassName('narrow');
    Application.narrow = true;
  },
  updatePageUri: function(hard_link){
    var my_href = location.href.toString(), matches = null;
    matches = my_href.match(/#(.+)/);
    if (matches){
      my_href = my_href.replace(matches[0], hard_link);
      location.href = my_href;
    } else {
      location.href += hard_link;
    }
  },
  inDevelopment: function() {
    return this.runMode == 'development';
  },
  inProduction: function() {
    return this.runMode == 'production';
  },
  // Simple refresh, just reset the iframe src to the same thing (will load another random ad with the same context)
  // Add &jsr=1 if needed (javascript refresh!)
  refreshAd: function () {
    var frame = $('sidebar_box_frame') || $('adframe');
    if (frame) {
      var src = frame.src.toString();
      if (!src.match(/jsr\=1/)) {
        src = src + "&jsr=1";
      }
      frame.src = src;
    } else if (typeof(gekko) != 'undefined') {
      if (gekko.refresh) {
        gekko.refresh();
      }
    }
  }
};

Event.register(Application);

var CurrentUser = {
  permissionClass:'guest',
  guest: function(){
    return this.permissionClass == 'guest';
  },
  unverified: function(){
    return this.permissionClass == 'unverified';
  },
  anonymous: function(){
    return this.permissionClass == 'anonymous';
  },
  verified: function(){
    return this.permissionClass == 'verified';
  }
};

var AdHelper = {
  checkResolutionAndRenderAds: function(url){
    var screenWidth = screen.width;
    var resolution = 'normal';
    if (screenWidth && parseInt(screenWidth, 10) < 1200){
      resolution = 'narrow';
      Application.narrowLayout();
    } else {
      url += '&_w=t';
    }

    // render the ads
    var adframe = $('sidebar_box_frame') || $('adframe');
    if (adframe) { adframe.src = url; }

    Cookie.set('screen_resolution', resolution);
  }
};

var Flyover = {

  prepare: function( darkbox ){
    this._setHeights( darkbox );
    document.fire("flyover:shown");
  },
  show_modal: function( flyover_content, myOptions){
    var options = jQuery.extend({url: '/login/ajax_form'}, myOptions||{});
    if (jQuery('#'+flyover_content).length === 0) {
      jQuery.ajax(options.url, {
        data: {overlay: flyover_content, referer:window.location.pathname},
        complete: function(data)
        {
          eval(data.responseText);
          jQuery('#'+flyover_content).modal('toggle');
        },
        dataType: "js"
      });
    }
    else {
      jQuery('#'+flyover_content).modal('toggle');
    }
  },
  show: function( flyover_content, myOptions ){
    if( flyover_content == 'login_overlay' ) {
      if (Application.inDevelopment()) {
        console.log( "Flyover.show('login_overlay') is deprecated. Please use JoinAndLogin.showLogin()." );
      }
      JoinAndLogin.showLogin(); return;
    }

    var options = jQuery.extend({url: '/login/ajax_form'}, myOptions||{});
    if (jQuery('#'+flyover_content).length === 0) {
      jQuery.ajax(options.url, {
        data: {overlay: flyover_content, referer: window.location.pathname + window.location.search },
        complete: function(data)
        {
          eval(data.responseText);
          var lightbox = $( flyover_content ).up( '.lightbox' );
          var darkbox = $( lightbox.getAttribute('id').replace( 'lightbox_', 'darkbox_' ) );
          if (Browser.IE6){lightbox.setStyle({top:-$(document.body).viewportOffset()[1] + 'px'});}
          darkbox.appear({duration:0.5, to:0.4});
          lightbox.appear({duration:0.5, afterFinish: function() {
            var form = lightbox.down("form");
            if(form && form.findFirstElement()) {
              form.focusFirstElement();
            }
          }});
          // this.prepare( darkbox );
          jQuery( '#' + flyover_content).trigger("flyover:shown");
          document.fire("flyover:shown");
        },
        dataType: "js"
      });
    }
    else {
      var lightbox = $( flyover_content ).up( '.lightbox' );
      var darkbox = $( lightbox.getAttribute('id').replace( 'lightbox_', 'darkbox_' ) );
      if (Browser.IE6){lightbox.setStyle({top:-$(document.body).viewportOffset()[1] + 'px'});}
      darkbox.appear({duration:0.5, to:0.4});
      lightbox.appear({duration:0.5, afterFinish: function() {
        var form = lightbox.down("form");
        if(form && form.findFirstElement()) {
          form.focusFirstElement();
        }
      }});
      // this.prepare( darkbox );
      jQuery( '#' + flyover_content).trigger("flyover:shown");
      document.fire("flyover:shown");
    }
  },
  hide: function( flyover_content ){
    if( flyover_content == 'login_overlay' ) {
      if (Application.inDevelopment()) {
        console.log( "Flyover.hide('login_overlay') is deprecated. Please use JoinAndLogin.hide()." );
      }
      JoinAndLogin.hide(); return;
    }

    if($(flyover_content)) {
      var lightbox = $( flyover_content ).up( '.lightbox' );
      if(lightbox) {
        var darkbox = $( lightbox.getAttribute('id').replace( 'lightbox_', 'darkbox_' ) );
        darkbox.fade({duration:0.5, from:0.4});
        lightbox.fade({duration:0.5});
        if ($(darkbox.id + '_iefix')) {
          $(darkbox.id + '_iefix').remove();
        }
        document.fire("flyover:hidden");
      }
    }
  },
  destroy: function( element_inside_lightbox, options){
    options = Object.extend( { instantDisplay:false }, options || {} );
    var lightbox = $( element_inside_lightbox ).up( '.lightbox' );
    var darkbox = $( lightbox.getAttribute('id').replace( 'lightbox_', 'darkbox_' ) );
    var darkboxFix = $(darkbox.id + '_iefix');
    if (darkboxFix) { darkboxFix.remove(); }
    lightbox.remove();
    darkbox.remove();
    document.fire("flyover:hidden");
  },
  hideWithEvent: function(flyover_content, event_name) {
    GoogleAnalytics.trackEvent(event_name, 'overlay closed');
    Flyover.hide(flyover_content);
  },
  _setHeights: function( darkbox ){
    /*
    The height of lightboxes and darkboxes is set in the CSS to be 100% width and height, but in all "good" browsers
    this is rendered as 100% of the width and height of the visible window, and does not include scrollable space
    We need to apply this height fix to make the darkbox and lightbox extend to the full content width
    */
    darkbox = $(darkbox);
    var lightbox = $(darkbox.getAttribute('id').replace('darkbox_', 'lightbox_'));

    var height = darkbox.parentNode.offsetHeight;
    if (height && document.documentElement.clientHeight > height){
      height = document.documentElement.clientHeight;
    }
    darkbox.style.height = height + 'px';
    lightbox.style.height = height + 'px';
  },
  center:function(lightbox_id){
    w = jQuery(window);
    o = jQuery('#' + lightbox_id);
    o.css({
      position:'absolute',
      top: ((w.height() - 250 - o.outerHeight()) / 2) + w.scrollTop() + "px"
    });
  }
};

var WelcomeModal = {
  show: function() {
    jQuery('#welcome-modal').modal().on( 'hidden', function() {
      GoogleAnalytics.trackEvent('Join', 'Welcome Overlay Closed Manually');
    });
    GoogleAnalytics.trackEvent('Join', 'Welcome Overlay Shown');
  },
  learnMoreClicked: function() {
    window.open("http://www.spiceworks.com/features/");
    GoogleAnalytics.trackEvent('Join', 'Welcome App Promotion Engagement', 'Learn More');
  },
  appInfoLinkClicked: function(url) {
    window.open(url);
    GoogleAnalytics.trackEvent('Join', 'Welcome App Promotion Engagement', url);
  }
};

var Textbox = {
  clearDefaultText:function(text_field, default_text){
    text_field = $(text_field);
    text_field.removeClassName('init');
    if (text_field.value == default_text){
      text_field.value = '';
    }
  },
  resetDefaultText:function(text_field, default_text){
    text_field = $(text_field);
    text_field.addClassName('init');
    if (text_field.value === ''){
      text_field.value = default_text;
    }
  }
};

var ImageButton = Class.create({
  initialize: function( button, buttonKey ){
    this.button = button;
    this.buttonKey = buttonKey;
    this.button.setAttribute( 'key', this.buttonKey );

    this.activeState = 'normal';
    if ( this.button.disabled ) { this.activeState = 'disabled'; }

    this.buttonStates = {
      normal: new Image(),
      hover: new Image(),
      disabled: new Image()
    };

    if( this.button.getAttribute('data-image-url') ) {
          this.buttonStates.normal.src = this.button.getAttribute('data-image-url');
    }
    else {
        this.buttonStates.normal.src = this.button.src.replace( '_hover', '' ).replace( '_disabled', '' );
    }

    if( this.button.getAttribute('data-image-hover-url') ) {
      this.buttonStates.hover.src = this.button.getAttribute('data-image-hover-url');
    }
    else {
      this.buttonStates.hover.src = this.buttonStates.normal.src.replace( /(-[a-z0-9]*)?\.gif/, '_hover.gif' );
    }

    if( this.button.getAttribute('data-image-disabled-url') ) {
              this.buttonStates.disabled.src = this.button.getAttribute('data-image-disabled-url');
    }
    else {
        this.buttonStates.disabled.src = this.buttonStates.normal.src.replace( /(-[a-z0-9]*)?\.gif/, '_disabled.gif' );
    }

    this.events = {
      mouseOver: this.mouseOver.bindAsEventListener( this ),
      mouseOut: this.mouseOut.bindAsEventListener( this )
    };
    this._addObservers();
  },
  setActiveState: function( state ){
    // set to default if an invalid state is passed in...
    if ( ![ 'normal', 'hover', 'disabled' ].include( state ) ) { state = 'normal'; }

    this.activeState = state;
    this.button.disabled = this.disabled();
    this.button.src = this.buttonStates[ this.activeState ].src;
  },

  mouseOver: function(){ this.setActiveState( 'hover' ); },
  mouseOut: function(){ this.setActiveState( 'normal' ); },
  disable: function(){ this.setActiveState( 'disabled' ); },

  normal: function(){ return this.activeState == 'normal'; },
  hover: function(){ return this.activeState == 'hover'; },
  disabled: function(){ return this.activeState == 'disabled'; },

  isOrphaned: function(){ return this.button.isOrphaned(); },

  destroy: function(){
    this._removeObservers();
    this.button = null;
    this.buttonKey = null;
    this.activeState = null;
    this.buttonStates.normal = null;
    this.buttonStates.hover = null;
    this.buttonStates.disabled = null;
    this.events.mouseOver = null;
    this.events.mouseOut = null;
  },
  _addObservers: function(){
    this.button.observe( 'mouseover', this.events.mouseOver );
    this.button.observe( 'mouseout', this.events.mouseOut );
  },
  _removeObservers: function(){
    this.button.stopObserving( 'mouseover', this.events.mouseOver );
    this.button.stopObserving( 'mouseout', this.events.mouseOut );
  }
});

var ButtonManager = {
  buttons:$H(),
  initialize: function(){
    var that = this;
    $$('input[type=image]').each( function( button ){
      that._attachButton( button );
    });

    document.observe('ajax:completed', this.ajaxOnComplete.bindAsEventListener(this));
  },

  ajaxOnComplete: function(){
    this._removeOrphaned();
    this._attachFreshButtons();
  },

  alterStateOfButton:  function( buttonKey, state ){
    var button = this.buttons.get(buttonKey);
    if (button) { button.setActiveState(state); }
  },

  _removeOrphaned: function(){
    var that = this;
    this.buttons.each( function( pair ){
      if (pair.value.isOrphaned()){
        pair.value.destroy();
        that.buttons.unset(pair.key);
      }
    });
  },

  _attachFreshButtons: function(){
    var that = this;
    var buttons = $$('input[type=image]');
    if (buttons) {
      buttons.each( function( button ){
        if (!button.getAttribute('key')) { that._attachButton(button); }
      });
    }
  },

  _attachButton: function(button){
    if (button.src.indexOf('_active.gif') > -1) { return; }
    // attach a button to the collection, keyed by either the button ID or a random number
    var buttonKey = button.id ? button.id : ( Math.random() * 100 ).toString();
    this.buttons.set(buttonKey, new ImageButton( button, buttonKey ));
  }
};

Event.register(ButtonManager);

/* TODO: integrate this better with the app, through a plugin probably */
var CalendarPopup = {
  setup:function(text_field_id, trigger_id, date_format, options) {
    // silently fail if the nodes to attach the calendar to cannot be found
    if( $(text_field_id) && (!trigger_id || $(trigger_id)) ){
      var default_options = {
        inputField : text_field_id, // ID of the input field
        ifFormat : date_format, // the date format
        button : trigger_id, // ID of the button
        align : 'Bl',
        single_click : true,
        step : 1, // show every year in menu
        cache : true, // reuse the div if calendar is reopened
        showOthers : true,
        weekNumbers : false
      };
      Calendar.setup(Object.extend(default_options, options || {}));
    }
  }
};

// Mark all inputs with their type as class name
document.observe('dom:loaded', function() {
  $$('input').each( function(input) { input.addClassName(input.type); });
});

var Pivot, PivotManager;

Pivot = Class.create({
  initialize: function(activator, menu, options) {
    this.activator = activator;
    this.menu = menu;

    this.options = Object.extend({
      scrollingParent:false,
      onShowCallback: Prototype.emptyFunction,
      onHideCallback: Prototype.emptyFunction
    }, options || {});

    // the options are passed in as eval'd JSON, and therefore if a callback is provided then it will likely be a string instead of a function
    if (typeof this.options.onShowCallback != 'function') {
      this.options.onShowCallback = eval(this.options.onShowCallback);
    }

    if (typeof this.options.onHideCallback != 'function') {
      this.options.onHideCallback = eval(this.options.onHideCallback);
    }

    var that = this;
    // add hooks so that we can refer to the menu from the activator and vice-versa, as well as the pivot instance itself
    Object.extend(this.activator, {
      menu: function(){ return that.menu; },
      pivot: function(){ return that; }
    });
    Object.extend(this.menu, {
      activator: function(){ return that.activator; },
      pivot: function(){ return that; }
    });

    this.events = {
      mouseOver: this.mouseOver.bindAsEventListener(this),
      mouseOut:  this.mouseOut.bindAsEventListener(this),
      hasFocus:  this.hasFocus.bindAsEventListener(this),
      lostFocus: this.lostFocus.bindAsEventListener(this),
      menuMouseOver: this.menuMouseOver.bindAsEventListener(this),
      itemMouseOver: this.itemMouseOver.bindAsEventListener(this),
      itemMouseOut: this.itemMouseOut.bindAsEventListener(this)
    };
    this._addObservers();
  },
  mouseOver: function(e) {
    this.clearMenuTimeout();
    this.setActivatorTimeout();
  },
  mouseOut: function(e) {
    this.clearActivatorTimeout();
    this.setMenuTimeout();
  },
  menuMouseOver: function(e) {
    this.clearMenuTimeout();
  },
  itemMouseOver: function(e) {
    this.clearMenuTimeout();
    var element = e.element();
  },
  itemMouseOut: function(e) {
  },
  show: function() {
    this.clearActivatorTimeout();
    this.clearMenuTimeout();

    var dimensions = this.activator.getDimensions(), position;

    // if this pivot is in a scrolling parent, then it is imperative that we
    // use the viewportOffset in conjunction with the scrollOffset of the body element

    // this technique will also work fine for pivots NOT in scrolling parents, but
    // since it requires an additional offset lookup, it's more expensive so we shouldn't
    // do it unless it is mandatory
    if (this.options.scrollingParent){
      position = this.activator.viewportOffset();
      var bodyScroll = document.body.cumulativeScrollOffset();
      position.top = position.top + bodyScroll.top;
      position.left = position.left + bodyScroll.left;
    } else {
      position = this.activator.cumulativeOffset();
    }

    var menuLeft   = position.left + parseInt(this.activator.getStyle('padding-left'), 10);
    var menuTop    = position.top + dimensions.height;

    // if another pivot menu is active, hide it and show this one instead
    if (PivotManager.active && PivotManager.active !== this) {
      PivotManager.active.hide();
    }
    PivotManager.active = this;

    if (this.menu && !this.menu.hasClassName('moved_pivot')) {
      document.body.insertBefore(this.menu, $('container'));
      this.menu.addClassName('moved_pivot').setStyle({zIndex:500}).absolutize();
    }

    this.menu.setStyle({top: menuTop  + 'px', left: menuLeft + 'px'});

    this.menu.show();

    this.menu.observe('mouseover', this.events.hasFocus);
    this.menu.observe('mouseout',  this.events.lostFocus);

    if (this.options.onShowCallback) {
      this.options.onShowCallback(this);
    }
    document.fire("pivot:shown", this.menu);
  },

  hide: function() {
    if (!this.menu) { return; } // for cases when the pivot menu is no longer on the page due to an ajax process altering the page content
    this.menu.hide();
    this._destroyZIndexFix();

    this.clearActivatorTimeout();
    this.clearMenuTimeout();

    this.menu.stopObserving('mouseover', this.events.hasFocus);
    this.menu.stopObserving('mouseout',  this.events.lostFocus);

    if (this.options.onHideCallback) { this.options.onHideCallback(this); }
    document.fire("pivot:hidden", this.menu);
  },

  setActivatorTimeout: function () {
    var timeout  = this.activator.getAttribute('pivot_timeout') || 100;
    this.clearActivatorTimeout();
    this.activatorTimeout = window.setTimeout(this.show.bind(this), timeout);
  },

  clearActivatorTimeout: function() {
    if (this.activatorTimeout) { window.clearTimeout(this.activatorTimeout); }
    this.activatorTimeout = null;
  },

  setMenuTimeout: function() {
    this.clearMenuTimeout();
    this.menuTimeout = window.setTimeout( this.hide.bind( this ), 250 );
  },

  clearMenuTimeout: function() {
    if (this.menuTimeout) { window.clearTimeout(this.menuTimeout); }
    this.menuTimeout = null;
  },

  hasFocus: function(e) {
    document.fire('pivot:hasFocus', this.activator.id);
    var element = e.element();
    if ( element.hasClassName( 'pivotable' ) || element.up( 'div.pivotable' ) ) { this.clearMenuTimeout(); }
  },
  lostFocus: function(e) {
    if (this.ignoreMouseOut) { return; }
    var element = e.element();
    if ( !element.hasClassName( 'pivotable' ) || !element.up( 'div.pivotable' ) ) { this.setMenuTimeout(); }
  },
  destroy: function(){
    // if the currently active menu is about to be destroyed, we need to clear/hide it first
    if (PivotManager.active && PivotManager.active == this) { PivotManager.clearActive(); }

    this._removeObservers();
    this.activator.menu = null;
    this.activator.pivot = null;
    this.menu.activator = null;
    this.menu.pivot = null;
    this.activator = null;

    if ( this.menu.parentNode ) { this.menu.parentNode.removeChild(this.menu); }
    this.menu = null;
  },
  isOrphaned: function(){
    return this.activator.isOrphaned();
  },
  _addObservers: function() {
    this.activator.observe('mouseover', this.events.mouseOver);
    this.activator.observe('mouseout',  this.events.mouseOut);

    this.menu.observe('mouseover', this.events.menuMouseOver);

    var that = this;
    this.menu.select('a').each( function(element) {
      element.observe('mouseover', that.events.itemMouseOver);
      element.observe('mouseout', that.events.itemMouseOut);
    });
  },
  _removeObservers: function(){
    this.activator.stopObserving('mouseover', this.events.mouseOver);
    this.activator.stopObserving('mouseout',  this.events.mouseOut);

    this.menu.stopObserving('mouseover', this.events.menuMouseOver);
    var that = this;
    this.menu.select('a').each( function(element) {
      element.stopObserving('mouseover', that.events.itemMouseOver);
      element.stopObserving('mouseout', that.events.itemMouseOut);
    });
  },
  _destroyZIndexFix: function(){
    if ( this.zIndexFix && this.zIndexFix.parentNode ){
      this.zIndexFix.parentNode.removeChild( this.zIndexFix );
      this.zIndexFix = null;
    }
  }
});

PivotManager = {
  active: null,
  initialize: function(){
    if (this.initialized) { return; }
    if (!this.pivots) { this.pivots = $H(); }
    this._addNew();

    this.listeners = {
      ajaxOnComplete:this.ajaxOnComplete.bindAsEventListener(this),
      clearActive:this.clearActive.bindAsEventListener(this)
    };

    document.observe('ajax:completed', this.listeners.ajaxOnComplete);

    // each instance of a pivot has a circular reference that MUST be cleaned up when pages are unloaded
    Event.observe(window, 'unload', this.pageUnload.bindAsEventListener(this));
    this.initialized = true;
  },
  ajaxOnComplete: function(){
    this._removeOrphaned();
    this._addNew();
  },
  clearActive: function(){
    if ( this.active ) { this.active.hide(); }
    this.active = null;
  },
  _removeOrphaned: function(){
    this.pivots.each( function( pair ){
      if ( pair.value.isOrphaned() ){
        pair.value.destroy();
        this.pivots.unset( pair.key );
      }
    }.bind( this ));
  },
  _addNew: function(){
    // pivot elements are usualy anchors, but can be spans as well, so with the selector we don't want to specify the tag name
    $$( '.pivot' ).each( function( pivot ){
      if ( !this.pivots.get( pivot.id ) ){
        var menu = $("menu_" + pivot.id);
        if ( menu ) {
          this.pivots.set( pivot.id, new Pivot( pivot, menu, (pivot.getAttribute('pivot_options') || '{}').evalJSON() ) );
        }
      }
    }.bind( this ));
  },
  pageUnload: function(){
    this.pivots.each(function(pair){
      // invoke the destroy method for each pivot instance so that it can cleanup after itself
      if (pair.value && pair.value.destroy) { pair.value.destroy(); }
    });
  }
};
Event.register(PivotManager);

var html_ad = {
  edit_html_ad:function(id) {
    new Ajax.Request('/html_ad/show_edit_form/' + id);
  },
  add_html_ad:function() {
    new Ajax.Request('/html_ad/show_add_form/');
  },
  delete_ad:function() {
    if(confirm("Are you sure you want to delete this link?")) {
      id = $('ad[id]').value;
      new Ajax.Request('/html_ad/delete_ad/' + id);
    }
  }
};

var RichTextEditor;

var NewTopic = {
  prep_postform:function(){
    var attachment_toggle = $('attachment_toggle');
    if(attachment_toggle){
      Event.observe(attachment_toggle, 'click', NewTopic.toggle_attachment);
      attachment_toggle.onclick = function(){return false;}; // this is for safari
    }
  },
  toggle_attachment:function() {
    var attachment = $('attachment_wrap');
    if (attachment.visible()){
      attachment.hide();
      $('cancel_attachment_button').hide();
      $('attachment_button').show();
      $('include_attachment').value = "false";
    } else {
      attachment.show();
      $('attachment_button').hide();
      $('cancel_attachment_button').show();
      $('include_attachment').value = "true";
    }
  },
  quote_original_post:function(e){
    var original_post_id = $F('original_post_id');
    if(original_post_id){
      new Ajax.Request('/posts/quote/' + original_post_id, {
        method:'get',
        onLoading:function(){
          Form.Element.disable('quote_original_post_button');
          $('quote_original_post_indicator').appear({'duration':0.5});
        },
        onSuccess:function(transport){
          RichTextEditor.insertAtCursor.defer('post_text', transport.responseText);
        },
        onFailure:function(){
          alert('There was an error while fetching the quote.\n\nPlease contact Spiceworks if you continue to see this error.\n\nSorry for the inconvenience.');
        },
        onComplete:function(){
          Form.Element.enable('quote_original_post_button');
          $('quote_original_post_indicator').fade({'duration':0.5});
        }
      });
    }
  },
  insertAtCursor:function(myField, myValue){
    //IE support
    if (document.selection) {
      myField.focus();
      sel = document.selection.createRange();
      sel.text = myValue;
    }
    //MOZILLA/NETSCAPE support
    else if (myField.selectionStart || myField.selectionStart == '0') {
      var startPos = myField.selectionStart;
      var endPos = myField.selectionEnd;
      myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
    } else {
      myField.value += myValue;
    }
  },
  seeMoreGroups:function(){
    $('see_more_groups').update('<em class="highlight">Loading...</em>');
  }
};

var Topic = {
  allowPrompt: false,
  showActions:function(elem) {
    $(elem).down('h2 span.actions').show();
    var unmark_answer = $(elem).down('div.unmark_answer');
    var mark_answer_options = $(elem).down('div.mark_answer_options');
    var vote_action = $(elem).down('p.vote_action');

    if(unmark_answer) {
      unmark_answer.addClassName('visible');
    }
    if(mark_answer_options) {
      mark_answer_options.show();
    }
    if(vote_action) {
      vote_action.show();
    }

  },
  originalPostActions:function(elem) {
    //Used for any additional actions needed for the original post.
    var userName = elem.attr('data-user-name');
    var attachment_action = elem.find('div.remove-actions');
    if((User.name == userName && !Topic.locked) || User.kind == "admin") {
      attachment_action.show();
    }
  },
  hideActions:function(elem) {
    $(elem).down('h2 span.actions').hide();
    var unmark_answer = $(elem).down('div.unmark_answer');
    var mark_answer_options = $(elem).down('div.mark_answer_options');
    var vote_action = $(elem).down('p.vote_action');
    if(unmark_answer) {
      unmark_answer.removeClassName('visible');
    }
    if(mark_answer_options) {
      mark_answer_options.hide();
    }
    if(vote_action) {
      vote_action.hide();
    }
  },
  checkLeaving:function() {
    // It seems that Event.observe doesn't work in all browsers for the beforeunload event
    window.onbeforeunload = Topic.promptWhenLeaving;
  },
  promptWhenLeaving:function(event) {
    if(RichTextEditor.isDirty('post_text') && Topic.allowPrompt) {
      return "You will lose any unsaved work if you continue.";
    }
  },
  promptWhenCancel:function(redirect) {
    Topic.allowPrompt = false;
    if(!RichTextEditor.isDirty('post_text') || confirm("Are you sure you want to navigate away from this page?\n\nYou will lose any unsaved work if you continue.\n\nPress OK to continue, or Cancel to stay on the current page.")) {
      document.location = redirect;
    }
    return false;
  },
  display_tab_for:function(section_name) {
    $$('ul#group_content_tabs li').each(function(tab) {
      tab.removeClassName('active');
    });
    $(section_name + '_tab').addClassName('active');
    $$('div.content div.footer_section').each(function(section) {
      section.hide();
    });
    $(section_name + '_section').show();
  },
  /*
    We insert post actions with Javascript for performance reasons.
    This also helps with all of the view caching we have, so that we don't
    have to cache for each of the different permissions and situations.
  */
  configureActions: function() {
    if(CurrentUser.permissionClass != "guest") {
      jQuery('.post').each(function(index, element) {
        var wrapper = jQuery(element);
        var actions = wrapper.find('.post_content .post-actions').first();
        var postID = parseInt(wrapper.attr('data-id'), 10);
        var divider = " <strong>&middot;</strong> ";
        var userName = wrapper.attr('data-user-name');
        var manage_actions = jQuery('<ul class="sui-dropdown-menu"></ul>');
        var attachment_actions = wrapper.find('.post_attachment .remove-actions').first();
        var show_manage = false;

        // Hide reply and report if locked
        if(Topic.locked) {
          actions.find('.reply').hide();
          actions.find('.report').hide();
        }
        // Edit
        if(User.kind == "admin" || (!Topic.locked && User.name == userName)) {
          show_manage = true;
          manage_actions.append( '<li><a href="/posts/' + postID + '/edit">Edit</a></li>');
        }

        // Undelete
        if(wrapper.hasClass('deleted-post') && (User.kind == "spiceuser" || User.kind == "admin")) {
          show_manage = true;
          manage_actions.append( '<li><a href="/topic/undelete_post/' + postID + '" onclick="return confirm(\'Are you sure you want to undelete this post?\')">Undelete</a></li>');
        }
        // Delete own post
        else if(User.name == userName && (!Topic.locked || User.kind == "admin" || User.kind == "spiceuser")) {
          show_manage = true;
          manage_actions.append( '<li><a href="/topic/delete_post/' + postID + '" onclick="return confirm(\'Are you sure you want to delete this post?\')">Delete</a></li>');
        }
        // Delete someone else's post
        else if((!Topic.locked && (UserPermissions.moderator || UserPermissions.group_admin)) || User.kind == "admin" || User.kind == "spiceuser") {
          show_manage = true;
          manage_actions.append( '<li><a href="#" onclick="Topic.showDeleteForm(' + postID + '); return false;">Delete</a></li>');
        }

        // Approve someone else's post
        if(wrapper.attr('data-moderation-status') != null && !Topic.locked && UserPermissions.moderator) {
          show_manage = true;
          manage_actions.append( '<li><a href="/topic/approve_post/' + postID + '" data-remote="true" data-method="post">Approve</a></li>' );
        }

        // Admin events
        if(User.kind == "spiceuser" || User.kind == "admin") {
          show_manage = true;
          manage_actions.append( '<li><a href="/admin_event/target/Post/' + postID + '">Admin Events</a></li>');
        }

        // Best Answer & Helpful Posts
        if(Topic.needs_answer && ((User.kind == "admin" || User.kind == "spiceuser") || (!Topic.locked && (UserPermissions.author || UserPermissions.moderator || UserPermissions.group_admin)))) {
          // Unmark Best
          if(Topic.best_answer && Topic.best_answer == postID) {
            manage_actions.append( '<li><a href="/posts/unmark_best_answer/' + postID + '">Unmark Best Answer</a></li>');
            show_manage = true;
          }
          // Unmark Helpful
          else if(Topic.helpful_posts.indexOf(postID) != -1) {
            manage_actions.append( '<li><a href="/posts/unmark_helpful/' + postID + '">Unmark Helpful Post</a></li>');
            show_manage = true;
          }
          // Mark Best
          else if(Topic.best_answer === null || Topic.needs_helpful) {
            if(Topic.best_answer === null) {
              manage_actions.append( '<li><a href="/posts/mark_best_answer/' + postID + '">Mark Best Answer</a></li>');
              show_manage = true;
            }
            if(Topic.needs_helpful) {
              manage_actions.append( '<li><a href="/posts/mark_helpful/' + postID + '">Mark Helpful Post</a></li>');
              show_manage = true;
            }
          }
        }

        // Attachment Management
        if((User.name == userName && !Topic.locked) || User.kind == "admin") {
          attachment_actions.show();
        }

        // Block IP
        if(User.kind == "admin") {
          var ip_wrapper = wrapper.find('.ip-address').first();
          if(ip_wrapper.html()) {
            manage_actions.append('<li><a href="#" onclick="Topic.showBlockIPModal(\'' + postID + '\', \'' + ip_wrapper.attr('data-ip-address') + '\'); return false;">Block IP</a></li>');
          }
          show_manage = true;
        }

        // Show Manage dropdown
        if(show_manage) {
          wrapper.find('.manage-actions-holder').first().prepend(divider);
          var manage_dropdown = wrapper.find('.sui-dropdown').first();
          manage_dropdown.append( '<a href="#" class="sui-dropdown-toggle" data-toggle="dropdown" onclick="return false;">Manage<span class="caret"></span></a>' );
          manage_dropdown.append( manage_actions );
        }
      });
    }
  },
  showDeleteForm: function(post_id) {
    if(jQuery('#delete_' + post_id).html() === '') {
      jQuery.get("/topic/show_delete_form/"+post_id, function(){
        var delete_el = jQuery('#delete_'+post_id);
        jQuery('#delete_post_overlay').modal('show');
      });
    } else {
      var delete_el = jQuery('#delete_'+post_id);
      jQuery('#delete_post_overlay').modal('show');
    }
  },
  closeDeleteForm: function(post_id) {
    jQuery('#delete_'+post_id).slideUp();
    jQuery('#topic_overlay').fadeOut();
  },
  showBlockIPModal: function(post_id, ip_address) {
    var modal_el = jQuery('#block_ip_modal');
    modal_el.find('input[name="ip"]').val(ip_address);
    modal_el.modal();
  },
  showTopicActivity: function(topic_id) {
    if(jQuery('#topic_event_overlay').length) {
      jQuery('#topic_event_overlay').modal('show');
    }
    else {
      new Ajax.Request('/topic/show_activity/' + topic_id);
    }
  },
  showTranslate: function(topic_id) {
    GoogleAnalytics.trackEvent("Topic", "Translate in menu");
    jQuery.ajax({
      url: "/topic/translate/" + topic_id,
      data: { 'referer': "/topic/" + topic_id }
    });
  },
  setupGuestState: function(topicSubject) {
        Form.Element.enable.delay(0.5, 'post_form_submit');

        var form = jQuery('form#new_post');

        Join.guestState({
                'text': escape( CKEDITOR.instances.post_text.getData() ),
                'parent_id': jQuery('#post_parent_id').val(),
                'topic_id': jQuery('#post_topic_id').val(),
                'enable_notify': form.find('input[name="enable_notify"]').is(':checked'),
                'join_group': form.find('input[name="join_group"]').is(':checked'),
                'content_type': 'Post'
        });

        JoinAndLogin.showJoin({ message: 'Sign up for free to publish your post!' });

        if( CurrentUser.guest() ) {
            GoogleAnalytics.trackEvent('Join', 'Guest Submitted Post', topicSubject);
        }

        return false;
  },
  showResults: function() {
    if(jQuery("#topic_search_results_loading")) {
      jQuery("#topic_search_results_loading").delay(1000).fadeOut(500, function() {
        jQuery("#topic_search_results").fadeIn(500);
      });
    }
  },
  levelInfoForAuthor: function(user) {
    if( user.kind == 'marketer' ) {
      return 'Marketer';
    }
    else if( user.community_only ) {
      return 'Community Only';
    }
    return '';
  },
  addAdminOnlySections: function(authors, posts) {
    jQuery.each(authors, function(index,author) {
      var avatar_admin_only = jQuery('.avatar[data-author-id=' + author.id + '] .admin-only');

      // Add author's email
      var actions = jQuery('<div class="actions light-links mts"></div>');
      actions.append('<a href="mailto:' + author.email_address + '">Email</a>');
      avatar_admin_only.append(actions);

      var user_info = jQuery('<div class="admin-user-info"></div>');
      user_info.append('<p class="title">' + Topic.levelInfoForAuthor(author) + '</p>');
      avatar_admin_only.append(user_info);
    });

    jQuery.each(posts, function(index,post) {
      if( !post.author_host ) { return; /* continue to next .each iteration */ }

      var post_admin_only = jQuery('.post[data-id=' + post.id + '] .post-actions .admin-only');

      post_admin_only.append('<span class="ip-address" data-ip-address="' + post.author_host + '">' + post.author_host + '</span>');
    });
  },
  highlightSearchTerms: function() {
      jQuery('.original-post .post_body p').highlightTerms( Topic.searchEngineTerms );
      jQuery('.post .post_body p').highlightTerms( Topic.searchEngineTerms );
  },
  ckeditorCheck: function() {
    if(jQuery('.quote_original_post').length > 0) {
      jQuery('.quote_original_post').hide();
      CKEDITOR.on('instanceReady', function() {
        jQuery('.quote_original_post').show();
      });
    }
  },
  scrollToPostInUrlHash: function() {
    // The browser scrolls for us but effectively overshoots b/c of nav and floating topic bar
    if( window.location.hash && window.location.hash != '' ) {
      // Have to use a timer b/c we get the dom-loaded event before the browser scrolls to the hash
      setTimeout( function() {
        var anchorElement = jQuery(window.location.hash);
        if (anchorElement.size() > 0) {
          jQuery(document).scrollTop( anchorElement.offset().top - 105 );          
        }
      }, 10 );
    }
  }
};

var TopicInvite = {
  showErrors: function(errors) {
    TopicInvite.resetErrors();
    for(var key in errors) {
      jQuery('#topic_invite .' + key + '_error').html(errors[key][0]);
    }
  },
  resetForm: function() {
    jQuery('#topic_invite input.text').each(function(i, e) {
      e.value = "";
    });
    jQuery('#topic_invite textarea').each(function(i, e) {
      e.value = "";
    });
    TopicInvite.resetErrors();
  },
  resetErrors: function() {
    jQuery('#invite_user_submit').removeAttr('disabled');
    jQuery('#topic_invite .error').html('');
    jQuery('#invite_user_status').html('');
  },
  toggleForms: function() {
    TopicInvite.resetForm();
    jQuery('#invite_success_dialog').modal('hide');
    jQuery('#invite_dialog').modal('show');
  }
};

var RelatedSubjects = {
  MAX_PRODUCT_TAGS: 1000,
  params: "",
  init: function() {
    RelatedSubjects.params = ""
    if (narrow || taggingType) {
      RelatedSubjects.params += "?";
      if (narrow) {
        RelatedSubjects.params += "narrow=true";
      }
      if (taggingType) {
        RelatedSubjects.params += (narrow ? "&" : "")+"object_type="+taggingType;
      }
    }
    var sa = jQuery('#subject_autocomplete');
    // only set up autocomplete if the element exists
    if(sa.length > 0) {
      if(removeText) {
        sa.focus(function() {
          var input = jQuery('#subject_autocomplete');
          input.css('color', '#000');
          input.val('');
        });
        sa.blur(function() {
          var input = jQuery('#subject_autocomplete');
          input.css('color', 'grey');
          input.val(narrow ? 'Add product or vendor...' : 'Add related product or vendor...');
          jQuery('#subject_autocomplete_loading').hide();
          jQuery('#subject_autocomplete_no_results').hide();
        });
      }

      sa.autocomplete({
        source: function(request, response) {
          if(taggingAssetId != 0)
            var path = '/' + taggingAssetPath + '/' + taggingAssetId + '/subject_autocomplete' + RelatedSubjects.params;
          else
            var path = '/' + taggingAssetPath + '/subject_autocomplete' + RelatedSubjects.params;
          jQuery.getJSON(
            path,
            { term: request.term },
            function(data) {
              if(data.length === 0) {
                jQuery('#subject_autocomplete_loading').hide();
                jQuery('#subject_autocomplete_no_results').css('display', 'block');
              }
              response(jQuery.map(data, function(i) { return i; }));
            }
          );
        },
        select: function(event, ui) {
          jQuery('#subject_autocomplete').val(ui.item.label);
          if (taggingProducts)
            RelatedSubjects.selectSubjectTag(event, ui);
          else
            jQuery('#subject_autocomplete_id').val(ui.item.id);
          return false;
        },
        focus: function(event, ui) {
          jQuery('#subject_autocomplete').val(ui.item.label);
          return false;
        },
        search: RelatedSubjects.setAutocompleteLoading,
        open:   RelatedSubjects.setAutocompleteLoaded,
        close:  RelatedSubjects.setAutocompleteLoaded,
        appendTo: inTable ? '.ui-front' : ''
      }).data('autocomplete')._renderItem = function(ul, item) {
        var li = jQuery('<li>');
        li.data('item.autocomplete', item);
        if(inTable)
          li.append('<a>' + item.value + '</a>');
        else
          li.append('<a>' + item.value + '<br><span class="type">' + item.type + '</span></a>');
        return li.appendTo(ul);
      };
    }

    // Set up tooltips for related products and vendors
    jQuery('.related-product-text-container a:first').tooltip();
  },
  setAutocompleteLoading: function() {
    jQuery('#subject_autocomplete_loading').show();
    jQuery('#subject_autocomplete_no_results').hide();
  },
  setAutocompleteLoaded: function() {
    jQuery('#subject_autocomplete_loading').hide();
  },
  selectSubjectTag: function(event, ui) {
    if(taggedProducts.size() < RelatedSubjects.MAX_PRODUCT_TAGS) {
      var id = ui.item.id;
      var type = ui.item.type;
      jQuery.ajax({
        type: 'POST',
        url: '/' + taggingAssetPath + '/' + taggingAssetId + '/tag_subject' + RelatedSubjects.params,
        data: { 'subject_id': id, 'type': type }
      });
    }
  },
  removeSubject: function(id, type) {
    jQuery('#tagged-' + type.toLowerCase() + '-' + id).slideUp(1000);
    jQuery.ajax({
      type: 'POST',
      url: '/' + taggingAssetPath + '/' + taggingAssetId + '/delete_subject_tag' + RelatedSubjects.params,
      data: { 'subject_id': id, 'type': type }
    });
  }
};

var PostAttachment;
var TopicReply = {
showForm:function(post_id, topicSubject){
    if($('postform')) {
      if(post_id){
        $('original_post_id').value = post_id;
      }
      new Effect.ScrollTo('postform', {
        offset:-105,
        afterFinish:function(){
          RichTextEditor.focus('post_text');
          RichTextEditor.resetDirty('post_text');
        }
      });
    }
    else {
      new Effect.ScrollTo('bottom_message');
    }

    if( CurrentUser.guest() ) {
        GoogleAnalytics.trackEvent('Join', 'Guest Started Post', topicSubject);
    }

    if( User.kind == 'marketer' ) {
      jQuery.ajax({
        url: '/posts/send_google_events_for_post/0'
      });
    }
  },
  cancel:function(){
    var that = this;
    if(!RichTextEditor.isDirty('post_text') || confirm('You will lose any unsaved work if you close this form.\n\nPress OK to continue, or Cancel to keep the form open.') ){
      $('postform').fade({
        duration:0.5,
        afterFinish:function(){
          that._resetForm();
        }
      });
      return true;
    } else {
      return false;
    }
  },
  showErrors:function(errorFields) {
    if (errorFields.text) {
      jQuery("#postform div.post_body p.error").show().html("Text " + errorFields.text);
    } else {
      jQuery("#postform div.post_body p.error").html("");
    }

    if (errorFields.attachment) {
      jQuery("#post_attachment_error").show().html(errorFields.attachment);
      jQuery("#post_attachment_attached_file")[0].clear();
    } else {
      jQuery("#post_attachment_error").html("");
    }

    Form.Element.enable("post_form_submit");
  },
  _resetForm:function(){
    var form = $('postform');
    var errorMessage = form.down('p.error');
    form.down('form.post_form').reset();
    if(errorMessage){ errorMessage.update(); }
    RichTextEditor.reset('post_text');
    PostAttachment.cancel();
  }
};

var SpicyTopics = {
  initialize: function() {
    this.container = $('spicy_topics');
    this.children = this.container.select('div.topic_feature');
    this.buttons = $('scrolling_buttons');
    if(this.buttons) {
      this.nextButton = this.buttons.down('div.next_button a');
      this.prevButton = this.buttons.down('div.prev_button a');
    }
    this.lastPage = this.children.length - 1;
    this.currentPage = 0;
    this.updateScrollButton();
  },
  scrollTo: function(page) {
    var newLeft = 470 * page;
    new Effect.Morph(this.container, {
      style:{left: -newLeft + 'px'},
      duration: 1
    });
    this.currentPage = page;
    this.updateScrollButton();
  },
  nextPage: function() {
    if(this.currentPage < this.lastPage) {
      this.scrollTo(this.currentPage + 1);
    }
  },
  prevPage: function() {
    if(this.currentPage > 0) {
      this.scrollTo(this.currentPage - 1);
    }
  },
  updateScrollButton: function() {
    if(this.prevButton) {
      if(this.currentPage > 0) {
        this.prevButton.show();
      }
      else {
        this.prevButton.hide();
      }
    }
    if(this.nextButton) {
      if(this.currentPage < this.lastPage) {
        this.nextButton.show();
      }
      else {
        this.nextButton.hide();
      }
    }
  }
};

var AskQuestion = {
  initialize: function(formIsOpen, forum_id) {
    allowSubmit = formIsOpen;
    forumID = forum_id;
    subject = "";
    resultsTimerOn = false;
    Event.observe($('post_subject'), 'keyup', function(e) {
      // if enter
      if(e.keyCode == 13) {
        AskQuestion.checkForm();
        AskQuestion.showTextStep();
        return false;
      }
      // if space
      else if(e.keyCode == 32) {
        AskQuestion.findResults();
      }
      // set timeout to check if they stop typing
      lastKeyPress = new Date().getTime();
      if(resultsTimerOn) {
        clearTimeout(resultsTimer);
      }
      else {
        resultsTimerOn = true;
      }
      AskQuestion.setResultsTimer();
    });
    Event.observe($('post_subject'), 'focus', function(e) {
      $('subject_status').update('');
      if($('post_subject').hasClassName('init')) {
        $('post_subject').value = "";
        $('post_subject').removeClassName('init');
      }
    });
  },
  findResults: function() {
    if(!$('search_results').visible() && !$('post_subject').value.blank()) {
      new Effect.Appear('search_results', {duration: 0.5});
    }
    if($('post_subject').value != subject) {
      $('search_results').down('span.busy').show();
      subject = $('post_subject').value;
      var url = "/topic/find_results_for_subject?question=" + subject + "&forum_id=" + forumID;
      new Ajax.Request(url, {method: "get",
        onSuccess: function() {
          $('search_results').down('span.busy').hide();
        }
      });
    }
  },
  setResultsTimer: function() {
    resultsTimer = setTimeout(function() {
      var currentTime = new Date().getTime();
      if(currentTime - lastKeyPress > 1500) {
        AskQuestion.findResults();
      }
      AskQuestion.setResultsTimer();
    }, 1000);
  },
  showTextStep: function() {
    $('subject_status').update('');
    var letters_only = $('post_subject').value.replace(/[^a-zA-Z]/g, "");
    if($('post_subject').value.blank() || $('post_subject').value == "Give your post a title") {
      $('subject_status').update('Question cannot be blank');
    }
    else if($('post_subject').value.length > 80) {
      $('subject_status').update('Question must be fewer than 80 characters.');
    }
    else if(!letters_only.blank() && letters_only == letters_only.toUpperCase()) {
      $('subject_status').update("Using all caps is considered bad form. For the best results, please try posting in normal case.");
    }
    else if(!$('text_step').visible()) {
      Topic.allowPrompt = true;
      $('subject_next_step').hide();
      new Effect.BlindDown('text_step', {duration:0.25, afterFinish: function() {
        if(CKEDITOR.instances.post_text) {
          CKEDITOR.instances.post_text.focus();
        }
        if($('ask_support_submit')) {
          allowSubmit = true;
        }
      }});
    }
    return false;
  },
  showGroupStep: function(current_forum,channel) {
    allowSubmit = true;
    $('text_step').down('p.btn').update('<img alt="" src="//static.spiceworks.com/assets/icons/ajax_busy-96d19e6b2f93905af43fffd61eca79c4.gif" />');
    var url = "/topic/find_groups_for_subject?question=" + encodeURIComponent(($('post_subject').value)) + "&forum_id=" + current_forum
    if( channel !== null && channel !== undefined && channel != '' )
    {
      url += "&channel=" + channel;
    }
    new Ajax.Request(url, {
      method: "get",
      onSuccess:function() {
        $('text_step').down('p.btn').hide();
      },
      onFailure:function() {
        $('text_step').down('p.btn').update("Sorry, an error occurred.");
      }
    });
  },
  checkForm: function() {
    if(allowSubmit) {
      if($('post_subject').value == "Give your post a title") {
        $('subject_status').update('Question cannot be blank');
        return false;
      }
      else {
        if($('ask_support_submit')) {
          Form.Element.disable('ask_support_submit');
        }
        else {
          Form.Element.disable('ask_question_submit');
        }
        $('new_post').submit();
        return true;
      }
    }
    return false;
  },
  selectSuggested: function() {
    if(!$('suggested_forums').visible()) {
      $$('ul#forum_choices_tabs li').each(function(e) {
        e.removeClassName('active');
      });
      $('tab_suggested').addClassName('active');
      $('browse_forums').hide();
      $('suggested_forums').show();
    }
  },
  selectBrowse: function() {
    if(!$('browse_forums').visible()) {
      $$('ul#forum_choices_tabs li').each(function(e) {
        e.removeClassName('active');
      });
      $('tab_browse').addClassName('active');
      $('suggested_forums').hide();
      $('browse_forums').show();
      if($('browse_forums').down('div.loading')) {
        GoogleAnalytics.trackEvent('Ask a Question', 'See More clicked');
        collectGroups = [];
        $$('div#suggested_forums li input').each(function(e) {
          collectGroups.push(e.value);
        });
        var url = "/topic/more_groups?exclude=" + collectGroups + "&from_ask_flow=true";
        new Ajax.Request(url, {
          method: 'get',
          onFailure: function() {
            $('browse_forums').down('div.loading').update('Error loading more forums');
          }
        });
      }
    }
  }
};

var tag_editor = {
  loaded_all: false,
  original_tags: "",
  tags: [],
  init: function(tag_list) {
    tag_editor.original_tags = tag_list;
    if( tag_editor.original_tags.length > 0 ) {
      tag_editor.tags = tag_editor.original_tags.split(',');
    } else {
      tag_editor.tags = [];
    }
  },
  show_selectors:function(taggable_class, taggable_id) {
    new Ajax.Request('/tag/load_selector', {
      parameters:{taggable_class:taggable_class, taggable_id:taggable_id, div_id:'recommended_tags'}
    });
    $('tag_display').hide();
    $('all_tags').hide();
    $('recommended_tags').show();
    $('edit_tags').show();
  },
  toggle_selectors: function(selector, taggable_class, taggable_id) {
    // selector is the id of the selector we want to hide
    if (selector == 'recommended_tags') {
      if (!tag_editor.loaded_all) {
        new Ajax.Request('/tag/load_selector', {
         parameters:{taggable_class:taggable_class, taggable_id:taggable_id, div_id:'all_tags'}
       });
        tag_editor.loaded_all = true;
      }
      $('recommended_tags').hide();
      $('all_tags').show();
    }
    else {
      $('all_tags').hide();
      $('recommended_tags').show();
    }
  },
  cancel_edit: function() {
    $('taggable_tag_list').value = tag_editor.original_tags;
    $('edit_tags').hide();
    $('tag_display').show();
    if (tag_editor.original_tags === "") {
      tag_editor.tags = [];
    } else {
      tag_editor.tags = tag_editor.original_tags.split(',');
    }
  },
  select_tag:function(tag) {
    new_tag = true;
    all_tag = $('atag ' + tag);
    rec_tag = $('rtag ' + tag);

    for( i=0; i < tag_editor.tags.length; i++){
      if( tag_editor.tags[i] == tag) {
        new_tag = false;
        tag_editor.tags.splice(i,1);

        if( all_tag ){
          all_tag.style.color = "black";
        }

        if( rec_tag ){
          rec_tag.style.color = "black";
        }
      }
    }

    if( new_tag ){
      if( all_tag ){
        all_tag.style.color = "#FF5200";
      }

      if( rec_tag ){
        rec_tag.style.color = "#FF5200";
      }
      tag_editor.tags.push( tag );
    }
    if( tag_editor.tags.length === 0  ) {
      $('taggable_tag_list').value = "";
    } else if( tag_editor.tags.length == 1 ) {
      $('taggable_tag_list').value = tag_editor.tags[0];
    } else {
      $('taggable_tag_list').value = tag_editor.tags.join(',');
    }
  }
};

var Ranking = {
  prep:function(ranking_element){
    Event.observe(ranking_element, 'mouseover', this.hover_on);
    Event.observe(ranking_element, 'mouseout', this.hover_off);
  },
  hover_on:function(e){
    Event.findElement(e,'div').addClassName('ranking_hover');
  },
  hover_off:function(e){
    Event.findElement(e,'div').removeClassName('ranking_hover');
  },
  rank: function(klass, id, value, rankable){
    if( rankable ) {
      this.change_value(rankable, value);
      this.disable_buttons(rankable);
    }
    new Ajax.Request('/ranking/rank', {
      parameters:{
        'class':klass,
        'id':id,
        'value':value,
        'show_label':( $$('p.spiciness').size() > 0 )
      }
    });

  },
  change_value: function(rankable, value){
    var value_node = $(rankable + '_value');
    // assuming that non-digit characters are the minus sign
    var new_value = parseInt(value_node.innerHTML.replace(/^\D/, '-'), 10) + value;
    value_node.innerHTML = String(new_value).replace('-', '&minus;');
  },
  disable_buttons: function(rankable){
    var buttons = $$('#' + rankable + ' p.action a');
    buttons.each(function(button) {
      button.addClassName('disabled');
      button.setAttribute('onclick', 'return false');
    });
  }
};

var StarRating = Class.create({
  initialize: function(node){
    this.node = $(node);
    this.stars = this.node.select('a');
    this.parent = {'id': this.node.getAttribute('ratable_id'), 'class': this.node.getAttribute('ratable_class')};
    this.value = this.node.getAttribute('value');
    this._attachHandlers();
    this.updateValue(this.value);
  },
  updateValue: function(value){
    var that = this;
    value = Math.round(value * 2) / 2.0;
    $w(this.node.className).each(function(className){
      if(className.startsWith('rated_at')){ that.node.removeClassName(className); }
    });
    this.node.addClassName("rated_at_" + value.toString().gsub(/\./,'_'));
  },
  rate: function(value){
    new Ajax.Request('/rating/rate', {
      parameters:{
        'class':this.parent['class'],
        'id':this.parent.id,
        'value':value
      },
      onSuccess: function(transport) {
        var memo = transport.responseText.evalJSON();
        document.fire('star_rating:succeeded', memo);
      },
      onFailure: function(transport) {
        document.fire('star_rating:failed');
      }
    });
  },
  _attachHandlers: function(){
    var that = this;
    this.stars.each(function(star){
      var value = star.getAttribute('value');
      star.observe('click', that._click.bindAsEventListener(that));
      star.observe('mouseover', that._mouseover.bindAsEventListener(that));
      star.observe('mouseout', that._mouseout.bindAsEventListener(that));
    });
    document.observe('star_rating:succeeded', this._succeeded.bindAsEventListener(this));
  },
  _click: function(event){
    if( CurrentUser.guest() ){
      JoinAndLogin.showJoin();
    } else {
      var value = event.element().getAttribute('value');
      this.updateValue(value);
      this.rate(value);
    }
  },
  _mouseover: function(event){
    this.node.addClassName('hover_at_' + event.element().getAttribute('value'));
  },
  _mouseout: function(event){
    this.node.removeClassName('hover_at_' + event.element().getAttribute('value'));
  },
  _succeeded: function(event){
    if(event.memo['class'] == this.parent['class'] && event.memo.id == this.parent.id){
      this.updateValue(event.memo.value);
    }
  }
});

StarRating.initialize = function(){
  this.starRatings = $$('span.star_rating').collect( function(node){ return new StarRating(node); });
};

Event.register( StarRating );

var RemoteForm = {
  check: function(layout, myOptions, func) {
    var options = jQuery.extend({url: '/login/ajax_form'}, myOptions||{});
    if (jQuery('#'+layout).length === 0) {
      jQuery.ajax(options.url, {
         data: {overlay: flyover_content, referer:(window.location.pathname + (window.location.href.indexOf("?") > 0 ? "?" + window.location.href.split("?")[1] : ""))},
        complete: function(data)
        {
          eval(data.responseText);
          func();
        },
        dataType: "js"
      });
    }
    else {
      func();
    }
  },
  after: function(layout)
  {
    Flyover.show(layout);
  }
};

var Tip = {
  show: function(id){
    $(id).show();
    $(id + '_toggler').hide();
    $(id).forceRerendering();
  },
  hide: function(id){
    $(id).hide();
    $(id + '_toggler').show();
  }
};

var Project = {
  create: function(){
    this.clearErrors();
    if(this.showErrors()){
      return false; // to prevent form submission
    } else {
      $('start_project').submit();
    }
    return true;
  },
  clearErrors: function(){
    var textbox = $$('#start_project input.text')[0];
    textbox.removeClassName('error');
    ['new_article_name_error', 'new_article_name_error_slashes'].each(Element.hide);
  },
  showErrors: function(){
    /* returns true if there is an error */
    var textbox = $$('#start_project input.text')[0];

    if ($F(textbox) === '') {
      textbox.addClassName('error');
      $('new_article_name_error').show();
      return true;
    } else if ($F(textbox).indexOf('/') != -1) {
      textbox.addClassName('error');
      $('new_article_name_error_slashes').show();
      return true;
    } else {
      return false;
    }
  }
};

var AjaxRequestManager = {
  /* Pass along requestClass: 'foo' in the ajax parameters and previous requests with requestClass 'foo' will get cancelled.
     Also if request 1 = "foo/bar", a request 2 comes in with requestClass "foo", request 1 will be cancelled. */

  initialize: function(){
    this.requests = $H();
    this.activeRequests = 0;
    this.indicator = $('application_activity_indicator');
    document.observe('ajax:started', this.ajaxStarted.bindAsEventListener(this));
    document.observe('ajax:completed', this.ajaxCompleted.bindAsEventListener(this));

    this.stealthRequests = $A([]);

  },
  ajaxStarted: function(event){
    var request = event.memo;
    var requestClass = this._getRequestClass(request);

    if (requestClass) {
      this._cancelRequestsOfClass(requestClass);
      this._addRequestClass(requestClass, request);
    }

    if (!this._requestIsStealth(request.url)) {
      this.incrementRequestCount();
    }
  },
  ajaxCompleted: function(event){
    var request = event.memo;
    var requestClass = this._getRequestClass(request);
    if (requestClass) { this._removeRequestClass(requestClass); }
    if (!this._requestIsStealth(request.url)) { this.decrementRequestCount(); }
  },
  decrementRequestCount: function() {
    this._modifyRequestCount(-1);
  },
  incrementRequestCount: function() {
    this._modifyRequestCount(1);
  },
  _modifyRequestCount: function(count) {
    this.activeRequests = this.activeRequests + count;
    if (this.activeRequests < 0) { this.activeRequests = 0; }
    if (!this.indicator) { return; }
    if (this.activeRequests > 0) {
      this.indicator.show();
    } else {
      this.indicator.hide();
    }
  },
  _getRequestClass: function(request) {
    var requestClass = false;
    if (request.options.requestClass !== undefined) {
      requestClass = request.options.requestClass;
    } else if ((request.options.parameters !== undefined) && (request.options.parameters.requestClass !== undefined)) {
      requestClass = request.options.parameters.requestClass;
    }
    return requestClass;
  },
  _cancelRequestsOfClass: function(requestClass) {
    var keys = this.requests.keys();
    var exp = new RegExp("^" + requestClass + "\/.+");
    var that = this;
    keys.each(function(key) {
      if ((key == requestClass) || (key.match(exp))) {
        that.requests.get(key).transport.abort();
        that.decrementRequestCount();
      }
    });
  },
  _addRequestClass: function(requestClass, request) {
     this.requests.set(requestClass, request);
  },
  _removeRequestClass: function(requestClass) {
     this.requests.unset(requestClass);
  },
  _requestIsStealth: function(url){ return this.stealthRequests.detect( function(element){ return url.indexOf(element) > -1; } ) ? true : false; }
};

Event.register(AjaxRequestManager);

var Launch = {
  moreFeatured:function(){
    $('featured_content').hide();
    $('more_featured').show();
  },
  lessFeatured:function(){
    $('featured_content').show();
    $('more_featured').hide();
  },
  setUpStatus: function(user_status) {
    GoogleAnalytics.trackEvent("HomePage", "status param");
    new Ajax.Request('/launch/toggle_activity?to=user_activity', {
      onSuccess: function() {
        window.setTimeout(function() {
          $('activity_field').removeClassName('init');
          $('activity_field').value = user_status;
          new Effect.ScrollTo('activity', {duration: 0.25, afterFinish: function() {
            $('activity_field').highlight();
          }});
        }, 100);
      }
    });
  }
};
var EventSearch ={
  initialize: function(){
    if(jQuery('#find_date_true').length > 0 && jQuery('#find_date_true').is(":checked")){
      jQuery('#date_search').show();
    }
    else{
      jQuery('#date_search').hide();
    }
    if(jQuery('#search_event_true').is(":checked")){
      jQuery('#event').hide();
      jQuery('#event_header').hide()
    }
    else{
      jQuery('#event').show();
      jQuery('#event_header').show();
    }
  },
  showDateSearch: function(){
    if(jQuery('#find_date_true').is(":checked")){
      jQuery('#date_search').show();
    }
    else{
      jQuery('#date_search').hide();
    }
  },
  hideNameSearch: function(){
    if(jQuery('#search_event_true').is(":checked")){
      jQuery('#event').hide();
      jQuery('#event_header').hide()
    }
    else{
      jQuery('#event').show();
      jQuery('#event_header').show();
    }
  },
  showPMForm: function(){
    if($('record_event').checked){
      $('pm_record').show();
    }
    else {
      $('pm_record').hide();
    }
  }
};

var CancelProfile ={
  showTooManyEmails:function(){
    $("too_many_emails").show();
    $("wont_help_with_job").hide();
  },
  wontHelpWithJob:function(){
    $("wont_help_with_job").show();
    $("too_many_emails").hide();
  },
  unclickAll:function(){
    $("wont_help_with_job").hide();
    $("too_many_emails").hide();
  }
};
var Profile = {
  showRemoteLogin:function(){
    Profile.clearPasswordForm(); 
    jQuery("#remote_login_display").hide();
    jQuery("#remote_login_edit").show();
    if(jQuery('#password_update_old_password').is(":visible")) {
      jQuery("#password_update_old_password").focus();
    }
    else {
      jQuery('#password_update_password').focus();
    }
  },
  cancelRemoteLogin:function(){
    jQuery("#remote_login_edit").hide();
    jQuery("#remote_login_display").show();
    return false;
  },
  clearPasswordForm: function() {
    jQuery("#remote_login_form input[type=password]").val("");
    jQuery("#remote_login_form .control-group").removeClass("error");
    jQuery("#remote_login_form .help-inline").html("");
    jQuery("#remote_login_message").html("");
  },
  initPasswordForm: function() {
    jQuery("#remote_login_form").on("ajax:success", function() {
      jQuery("#remote_login_message").html("Password saved");
      setTimeout(function() {
        Profile.cancelRemoteLogin();
      }, 2000);
    });
  }
};

var ProfileCarousel = {
  init: function(count) {
    this.current_page = 0;
    this.total_pages = Math.ceil(count/10.0);
    this.prev = $('profile_pages_container').down('div.prev_arrow');
    this.next = $('profile_pages_container').down('div.next_arrow');
    this.list = $('profile_pages_container').down('div.profile_pages_list');
    if(this.total_pages > 1) {
      this.next.show();
    }
  },
  scrollTo: function(page) {
    var newLeft = 450 * page;
    new Effect.Morph(this.list, {
      style:{left: -newLeft + 'px'},
      duration: 0.5
    });
    this.current_page = page;
    this.updateScrollButton();
  },
  prevPage: function() {
    if(this.current_page > 0) {
      this.scrollTo(this.current_page - 1);
    }
  },
  nextPage: function() {
    if(this.current_page < this.total_pages-1) {
      this.scrollTo(this.current_page + 1);
    }
  },
  updateScrollButton: function() {
    if(this.current_page === 0) {
      this.prev.hide();
    }
    else {
      this.prev.show();
    }
    if(this.current_page == this.total_pages-1) {
      this.next.hide();
    }
    else {
      this.next.show();
    }
  }
};

var Product = {
  clear_form:function(name) {
    Form.Element.clear(name + "_content");
    Effect.toggle("add_" + name, "blind", {'duration':0.5});
    Element.update(name + "_status", "");
    $("add_" + name).getElementsBySelector('span.fieldWithErrors').each(function(element) {
      element.replace(element.innerHTML);
    });
  },
  toggle_form:function(name) {
    Effect.toggle("add_" + name, "blind", {'duration':0.5});
    if(!$("add_" + name).visible()) {
      setTimeout(function(){Form.focusFirstElement(name + "_form");}, 1000);
    }
  },
  edit:function() {
    $('description_content').hide();
    $('description_edit').show();
   },
  cancel:function() {
    $('description_edit').hide();
    $('description_content').show();
    $('product_description_form').reset();
    Element.update('description_error', '');
  },
  showFilters:function() {
    $('add_filters').hide();
    $('filters_select').show();
  },
  hideFilters:function() {
    $('filters_select').hide();
    $('add_filters').show();
    $('filter_error').update("");
  },
  select:function(product) {
    checkbox = $(product).select('input');
    if(checkbox.length > 0 && checkbox[0].checked) {
      $(product).addClassName("selected");
    }
    else {
      $(product).removeClassName("selected");
    }
  },
  removeRelatedPage: function(vendor_id, vendor_page_id) {
    jQuery.ajax({
      url: "/product/remove_related_page",
      data: {
          "vendor_id": vendor_id,
          "vendor_page_id": vendor_page_id
        },
      error: function() {
        jQuery("#related_pages_" + vendor_id).append("<p class='error'>Error deleting</p>");
      }
    });
  },
  printHeaderTitle: function() {
    if(Product.category_name) {
      var result = [];
      if(Product.category_name == "services") {
        result.push("Researching ");
      }
      else {
        result.push("Buying ");
        if(Product.category_name != "software") {
          result.push("a ");
        }
      }
      result.push(Product.category_name);
      result.push("?");
      jQuery('#product_guest_header .starter').html(result.join(""));
    }
    else {
      jQuery('#product_guest_header .starter').html("Buying an IT product?");
    }
  }
};
var ProductComments ={
    showDeleteForm: function(review_id, page, sort) {
    if(jQuery('#delete_' + review_id).html() === '') {
      jQuery.get("/product_comments/show_delete_form/"+review_id + "?page=" + page + '&sort=' + sort, function(){
        var delete_el = jQuery('#delete_'+review_id);
        jQuery('#delete_post_overlay').modal('show');
      });
    } else {
      var delete_el = jQuery('#delete_'+review_id);
      jQuery('#delete_post_overlay').modal('show');
    }
  }
};
var Review = null;
(function($){
    Review = {
    rate: function(rating, product_id)
    {
        $.get("/product/rate", {product_id:product_id, rating: rating});
    },
    showForm: function()
    {
        $.scrollTo('#rating_call_to_action', 750, {easing:"easeOutExpo", onAfter: function(){

                    $('#product_comment_interaction_box').addClass("extended");
                }});
    },
    error: function(id, msg)
    {
        $('#'+id).html(msg).addClass('error');
    },
    init: function(options)
    {
      jQuery(function (){
        var box_id = options.box_id + '_content';
        jQuery('#' + box_id).elastic();

        window.has_rating = options.has_rating;
        window.has_error = false;
        //since we are using options.disabled to tell if the form has enough words, we can set the window variable here.
        window.has_enough_words = !options.disabled;

        var target_id = jQuery('.word_counter').data('target-id');
        var counter_id = jQuery("#"+target_id).data('counter-id');
        Review.validate();
        jQuery("#"+target_id).keyup(function () {
          var matches = jQuery(this).val().match(/\b/g);
          var len = (matches === null ? 0 : matches.length/2);
          var count = options.min_comment_length - len;
          var message = "";
          //reordered the else statements so that they execute in the correct order
          if (count == options.min_comment_length ) { message = options.min_comment_length + ' word minimum.'; }
          else if (count == 1) {                    message = "So close! 1 word left."; }
          else if (count > 0 && count <= 5) {       message = "You're almost there! " + count + " words left."; }
          else if (count > 0 && count <= 15) {      message = "You're off to a great start! " + count + " more words."; }
          else if (count <= -15) {                  message = window.has_rating ? "This is gonna be a good one!" : "Don't forget your rating!"; }
          else if (count > 0) {                     message = (count + " words to go."); }
          else {                                    message = window.has_rating ? "Good to go!" : "Don't forget your rating!"; }
            if (count > 0) {
              jQuery('#'+jQuery(this).data('counter-id')).removeClass("error");
              //remove the error checking because the server will do that if they find a way to submit.
              window.has_error = false;
              window.has_enough_words = false;
            }
            else {
              window.has_enough_words = true;
          }
          Review.validate();
          jQuery('#'+jQuery(this).data('counter-id')).html(message);
        });
        jQuery('#product_comment_form_save_button').click(function(evt){
          var $this = $(this);
          if($this.hasClass('disabled')) {
            return false;
          }
          //a work around to get the keyup to fire
          var keyup = jQuery.Event("keyup");
          jQuery('#'+target_id).trigger(keyup);

          if (!window.has_enough_words) {
            jQuery('#'+counter_id).addClass("error");
          }
          $this.addClass('disabled');
        });
      });
    },
  validate: function() {
    if(!has_enough_words || !has_rating) {
      $('#product_comment_form_save_button').addClass('disabled');
    } else {
      $('#product_comment_form_save_button').removeClass('disabled');
    }
  },
  disable_button: function(counter_id, box_id){
    jQuery('#product_comment_form_save_button').bind('click', function() {
      jQuery('#'+counter_id).addClass("error");
      jQuery('#' + box_id).addClass('error');
      return false;
    });
    jQuery('#product_comment_form_save_button').addClass('disabled');
  },
  activate: function(id, _options)
  {
      if($('#'+id+ ".editing").length > 0) {
          return;
      }

      $('#'+id+" .opened").css('opacity', 0);
      $('#'+id+" .opened").slideDown('fast', function() {
              $(this).animate({opacity:'1'}, 250);
              $('#'+id).addClass('editing');
              jQuery('#'+id).find('textarea').elastic();
              $('#'+id).find('textarea').focus();
          });
      $('#'+id+" .closed").fadeOut();
      $('.review-tooltip').show();

      jQuery(document).scrollTop( jQuery("#"+id).offset().top-75 );

      if( CurrentUser.guest() ) {
          GoogleAnalytics.trackEvent('Join', 'Guest Started Review', _options.productName);
      }
  },
  deactivate: function(id, func)
  {
      $('#'+id+" .opened").animate({opacity:'0'}, 100, function() {
              $(this).slideUp(250);
              $('#'+id).removeClass('editing');
              $('.review-tooltip').hide();
              $('#'+id+" .closed").fadeIn();
          });
      if (func !== undefined && jQuery.isFunction(func))
      {
          func();
      }
  },
  setupGuestState: function(review_form, productName) {

          var rating = Join.guestState().rating;
          if( rating !== null && rating !== undefined ) {
              var prod_id = jQuery(review_form).find('input[name="product_comment[products_id]"]').val();
              if (prod_id === "") {
                prod_id = jQuery(review_form).find('input[name="product_comment[catalog_product_id]"]').val();
              }
              Join.guestState({
                      'text': escape( jQuery(review_form).find('textarea[name="product_comment[content]"]').val() ),
                      'product_id': prod_id,
                      'content_type': 'ProductReview'
              });
              jQuery('#'+jQuery(review_form).find('input[name="product_comment[products_id]"]').val()+"_Product_counter").removeClass('error');
              jQuery('#product_comment_status').hide();
              JoinAndLogin.showJoin({ message: 'Sign up for free to publish your review!' });

              if( CurrentUser.guest() ) {
                  GoogleAnalytics.trackEvent('Join', 'Guest Submitted Review', productName);
              }
          }
          else {
            //here we find the form id and use that to find the word counter to set its text and color
              jQuery('#'+jQuery(review_form).find('input[name="product_comment[products_id]"]').val()+"_Product_counter").html('Don\'t forget your rating!');
              jQuery('#'+jQuery(review_form).find('input[name="product_comment[products_id]"]').val()+"_Product_counter").addClass('error');
          }

          return false;
  }
  };
})(jQuery);
var ProductRating = null;
(function($){
  $(function(){
  });

  ProductRating = {
    rate: function(rating, product_id)
    {
      $.get("/product/rate", {product_id:product_id, rating: rating});
    },
    showForm: function()
    {
      $.scrollTo('#rating_call_to_action', 750, {easing:"easeOutExpo", onAfter: function(){

        $('#product_comment_interaction_box').addClass("extended");
      }});
    },
    activate: function()
    {
      $.scrollTo('#rating_call_to_action', 750, {easing:"easeOutExpo", onAfter: function(){

        $('#product_comment_interaction_box').addClass("extended");
      }});
    },
    deactivate: function(scroll_to_id, func)
    {
      $('#product_comment_interaction_box').removeClass("extended");
      $('#product_comment_interaction_box').slideUp(750, 'easeOutExpo', function(){
        $('#rating_call_to_action .add_comment_link').slideDown();
        if (scroll_to_id)
        {
          $.scrollTo("#"+scroll_to_id, 750);
        }
        if (func !== undefined && jQuery.isFunction(func))
        {
          func();
        }
      });
    }
  };
})(jQuery);

var OldProductRating = {
  rate: function(rating, product_id){
    new Ajax.Request('/product/rate', {
      parameters: {
        product_id:product_id,
        rating:rating
      }
    });
    $w($("rating_form").className).each(function(klass){
      if(klass.startsWith('rated_at')){
        $("rating_form").removeClassName(klass);
      }
    });
    $("rating_form").addClassName("rated_at_" + rating);
  },
  showForm: function() {
    new Effect.ScrollTo('rating_call_to_action', {duration:0.5});
  },
  activate: function(){
    $('product_comment_interaction_box').hide();
    Effect.ScrollTo('rating_call_to_action', {
      queue:{position:'start', scope:'star_rating'},
      duration:0.5
    });
    $('product_comment_interaction_box').blindDown({
      queue:{position:'end', scope:'star_rating'},
      duration:0.5,
      afterFinish:function(){
        $('rating_call_to_action').highlight();
        $('product_comment_content').focus();
      }
    });
  },
  deactivate: function(scroll_to_id){
    $('product_comment_interaction_box').blindUp({
      duration:0.5,
      afterFinish:function(){
        $('product_comment_form').reset();
        Form.Element.enable('product_comment_form_save_button');
        if(scroll_to_id){
          Effect.ScrollTo(scroll_to_id, {
            queue:{position:'end', scope:'product_rating'},
            duration:0.5
          });
          $(scroll_to_id).highlight({
            queue:{position:'end', scope:'product_rating'},
            duration:1
          });
        }
      }
    });
  }
};

var Rater = Class.create({
  initialize: function(element, options){
    this.options = Object.extend({ rated: false }, options || {});

    this.rater = $(element);
    this.stars = this.rater.select('a.star');

    this.stars.invoke('observe', 'mouseover', this.starMouseOver.bindAsEventListener(this));
    this.stars.invoke('observe', 'mouseout', this.starMouseOut.bindAsEventListener(this));
  },
  starMouseOver: function(event){
    var hovered_star = Event.element(event);
    this.rater.addClassName('hover_at_' + hovered_star.getAttribute('rating'));
  },
  starMouseOut: function(event){
    var hovered_star = Event.element(event);
    this.rater.removeClassName('hover_at_' + hovered_star.getAttribute('rating'));
  }
});

jQuery.widget( 'spiceworks.starRater', {
  _create: function() {
    var self = this;

    this.element.find('.star').click( function(event) { event.preventDefault(); self._starClicked(jQuery(this)); } );
    this.element.find('.star').mouseover( jQuery.proxy( this._highlightStar, this ) );
    this.element.find('.star').mouseout( jQuery.proxy( this._unhighlightStar, this ) );
  },

  _starClicked: function(star) {
    this.element.trigger('starclicked');
    this._postRating(star);
  },

  _postRating: function(star) {
     this.element.find('.star').removeClass('hover');
     this.element.find('.star').removeClass('active_hovering');

     star.prevAll().addClass('active');
     star.addClass("active");

     var rating = star.data('rating');
     var ratableId = this.options.rated_object_id || this.options.ratable_id;

     if( CurrentUser.guest() ) {
       // This functionality relies on Review.setupGuestState to fill in the product_id and to show the join overlay.
       Join.guestState({ 'rating': rating, 'content_type': (this.options.ratable_class ? 'MspReview' : 'ProductReview') });

       //set the global has_rating to true
       window.has_rating = true;
       Review.validate();
       //From here we need to update the text below in case they have enough words.
       // We cannot get the word count without a lot of coupling so we just display "Rating Saved"
       jQuery('#interaction_box_counter')
        .removeClass('error')
        .html("Rating Saved!");
     }
     else {
       if( this.options.post_url && ratableId !== null && ratableId !== undefined) {
         var postData = {"rating":rating};
         if (this.options.ratable_class !== undefined) {
            postData.ratable_class = this.options.ratable_class;
            postData.ratable_id = this.options.ratable_id;
         }
         else {
            postData.id = this.options.rated_object_id;
         }
         jQuery.post( this.options.post_url, postData );
       }
     }
  },

  _highlightStar: function(event) {
    var star = jQuery( event.target );
    this.element.find('.active').addClass('active_hovering').removeClass('active');
    star.prevAll().addClass('hover');
    star.addClass("hover");
  },

  _unhighlightStar: function(event) {
    var star = jQuery( event.target );
    this.element.find('.active_hovering').addClass('active').removeClass('active_hovering');
    this.element.find('.star').removeClass('hover');
  }
});

var AjaxCallbacks = {

  onCompleteCallbacks: $A( [] ),
  onCreateCallbacks: $A( [] ),
  // references the methods that are to be invoked by this object
  supportedCallbacks: { onComplete: '_onComplete', onCreate: '_onCreate' },

  // references the methods that are to be supported and invoked on the passed in object
  expectedCallbacks: { onComplete: 'ajaxOnComplete', onCreate: 'ajaxOnComplete' },

  register: function( object, state ){
    if ( object.size ){
      // we have an array of objects to register
      $A( object ).each( function( callback ) {
        this._attach( callback, state );
      }.bind( this ));
    } else {
      this._attach( object, state );
    }
  },
  invoke: function( ajaxRequest, state ){
    // lookup the method to invoke
    var method = this.supportedCallbacks[ state ];
    // invoke the method, if a valid callback was supplied

    try{
      if (method) {
        this[method]( ajaxRequest );
      }
    } catch( err ){
      if (Application.inDevelopment()) {
        console.log( "Error invoking " + state + " for AjaxCallbacks" );
      }
    }
  },

  _attach: function( object, state ){
    // the name of the method that we're going to invoke on the passed in object
    var callback = this.expectedCallbacks[ state ];
    // the collection of callbacks that we're going to push this new callback onto
    var callbackCollection = state + 'Callbacks';

    try{
      // make sure the object implements the ajaxCallback method
      if ( !object[ callback ] ) {
        throw 'Object does not implement ' + callback + ' method, cannot register.';
      }
      // push it on the collection and make sure to bind it to itself so the scope doesn't get f'ed up
      this[ callbackCollection ].push( object[ callback ].bind( object ) );
    } catch ( exception ){
      if (Application.inDevelopment()){
        console.log(exception);
      }
    }
  },
  _onCreate: function( ajaxRequest ){ /* not implemented yet */ },
  _onComplete: function( ajaxRequest ) {
    // only render ajax callbacks if we have a response (empty responses have no new content)
    if ( ajaxRequest.transport.responseText !== '' ){
      // invoke all of the callbacks for this state
      this.onCompleteCallbacks.each( function( callback ){
        try{ callback();}
        catch( err ){
          if ( Application.inDevelopment() ) { console.log( "Error invoking onComplete method for object: " + err ); }
        }
      }.bind( this ));
    }
  }
};

var Invite = {
  showForm:function() {
    if($('invite_form_wrapper').visible()){
      $('invite_form').focusFirstElement();
      $('invite_form_wrapper').highlight();
    } else {
      this._resetForm();
      $('invite_form_wrapper').blindDown({
        'duration': 0.5,
        'afterFinish': function(){
          new Effect.ScrollTo('invite_form_wrapper', {
            'duration': 0.5,
            'afterFinish': function(){
              $('invite_form').focusFirstElement();
              $('invite_form_wrapper').highlight();
            }
          });
        }
      });
    }
  },
  cancelForm:function() {
    $('invite_form_wrapper').blindUp( {'duration':0.5} );
  },
  completeForm:function() {
    Form.Element.disable("invite_form_submit_button");
    setTimeout(function() {
      this.cancelForm();
    }.bind(this), 3000);
  },
  togglePersonalMessage:function(event) {
    if(event.element().checked){
      $('invite_personal_message_text_wrapper').blindDown( {'duration':0.5} );
    } else {
      $('invite_personal_message_text_wrapper').blindUp( {'duration':0.5} );
    }
  },
  togglePreview:function(event) {
    if(event.element().checked){
      $('invite_form_preview').blindDown( {'duration':0.5} );
    } else {
      $('invite_form_preview').blindUp( {'duration':0.5} );
    }
  },
  _resetForm:function(){
    $('invite_form').reset();
    $('invite_personal_message_text_wrapper').hide();
    Form.Element.enable("invite_form_submit_button");
    $('invite_form_preview').hide();
  }
};

var UserImage = {
  showForm:function() {
    Profile.hideAll('about_me');
    $('user_image_form').reset();
    Form.Element.enable('user_image_form_upload_button');
    $('user_image_form_wrapper').show();
  },
  cancel:function() {
    $('user_image_form_wrapper').hide();
    $('user_image_form').reset();
    Form.Element.enable('user_image_form_upload_button');
    Profile.cancel('about_me');
  },
  error:function(){
    Form.Element.enable('user_image_form_upload_button');
  },
  complete:function(){
    Form.Element.enable('user_image_form_upload_button');
  },
  action:function(msg){
    Form.Element.disable('user_image_form_upload_button');
    Form.Element.disable('user_image_form_clear_button');
    $('user_image_form_message').update(msg);
  },
  onchange:function(){
    $('user_image_form_message').update('');
  }
};

var SpiceList = {
  editForm:function() {
    if($('list_description').visible() || $('upload_list_image').visible()) {
      $('list_description').hide();
      $('upload_list_image').hide();
      $('edit_list_description').show();
    }
    else {
      $('edit_description_form').reset();
      $('edit_list_description').hide();
      $('list_description').show();
    }
  },
  uploadForm:function() {
    if($('list_description').visible() || $('edit_list_description').visible()) {
      $('list_description').hide();
      $('edit_list_description').hide();
      $('upload_list_image').show();
    }
    else {
      $('list_image_form').reset();
      $('list_image_status').update("");
      $('upload_list_image').hide();
      $('list_description').show();
    }
  },
  description:function(desc_id) {
    if($(desc_id).visible()) {
      Effect.BlindUp(desc_id, {duration:0.25});
    }
    else {
      Effect.BlindDown(desc_id, {duration:0.25});
    }
  },
  showAll:function() {
    $$('ul#items_list li').each(function(elem){
      $(elem).down('div.more_details').show();
    });
    $$('ul#add_item_addition li').each(function(elem){
      $(elem).down('div.more_details').show();
    });
  },
  hideAll:function() {
    $$('ul#items_list li').each(function(elem){
      $(elem).down('div.more_details').hide();
    });
    $$('ul#add_item_addition li').each(function(elem){
      $(elem).down('div.more_details').hide();
    });
  },
  mouseOver:function(element) {
    $(element).addClassName('hover');
  },
  mouseOut:function(element) {
    $(element).removeClassName('hover');
  },
  cancelDelete:function(element) {
    $(element).update("");
  },
  imageComplete:function(){
    setTimeout(function() {
      $('list_image_status').update('');
      this.uploadForm();
    }.bind(this), 3000);
  },
  showAddDesc:function() {
    if(!jQuery('#add_item_description').is(":visible")) {
      jQuery("#add_item_description").slideDown();
      jQuery('#sli_status').hide();
      jQuery('#add_item_modify_note').show();
    }
  },
  voteUp:function(dom_id, score) {
    $(dom_id + "_vote").update('<img alt="" src="//static.spiceworks.com/assets/icons/small/like-9833669c303408d3c8d1b360af2ed708.png" />');
    $(dom_id + "_score").update(score);
  },
  voteDown:function(dom_id, score) {
    $(dom_id + "_vote").update('<img alt="" src="//static.spiceworks.com/assets/community/icons/small/opinion_empty-57c8f25d0ac85ca1e64300a557a4c78a.png" />');
    $(dom_id + "_score").update(score);
  }
};

var Tv = {
  showCommentForm:function() {
    if(!$('add_comment_form').visible()) {
      $('add_comment_form').blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('video_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('video_comment_box').highlight();
              $('add_comment_form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('video_comment_box', {duration: 0.5});
    }
  },
  hideCommentForm:function() {
    if($('add_comment_form').visible()) {
      Effect.BlindUp('add_comment_form', {duration:0.5});
      $('add_comment_status').update('');
      $('add_comment_form').reset();
    }
  },
  redirect:function(comment) {
    url = video_path;
    if (comment) {
      url = url + '#comments';
    }
    window.location.href = url;
  }
};

var HowTos = {
  addStep:function() {
    if($('add_step_form').visible()) {
      Effect.BlindUp('add_step_form', {duration:0.5});
      $('add_step_form').down('form').reset();
    }
    else {
      Effect.BlindDown('add_step_form', {duration:0.5});
    }
  },
  showCommentForm:function() {
    jQuery('#comment_text').wordCounter({
      container: '#add_comment_status',
      words: 10,
      submit: '#howto_comment_button'
    });
    if(!$('add_comment_form').visible()) {
      $('add_comment_form').blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('how_tos_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('how_tos_comment_box').highlight();
              $('add_comment_form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('how_tos_comment_box', {duration: 0.5});
    }
  },
  hideCommentForm:function() {
    if($('add_comment_form').visible()) {
      Effect.BlindUp('add_comment_form', {duration:0.5});
      $('add_comment_status').update('');
      $('add_comment_form').reset();
    }
  },
  createHelp:function() {
    if($('visual_help_screenshot').visible()) {
      Effect.BlindUp('visual_help_screenshot', {duration:0.25});
      Cookie.set('howto_create_help', 'hide', {});
    }
    else {
      Effect.BlindDown('visual_help_screenshot', {duration:0.25});
      Cookie.set('howto_create_help', 'show', {});
    }
  },
  _allowed_comment_actions:[],
  allowCommentAction:function(id, type){
    this._allowed_comment_actions.push({id:id,type:type});
  },
  showAllowedCommentActions:function(){
    for (i = 0; i < this._allowed_comment_actions.length; i++) {
      var action = this._allowed_comment_actions[i];
      jQuery('input[data-comment-id="' + action.id + '"][data-type="' + action.type + '"]').show();
    }
  },
  showInviteForm:function(type, code) {
    GoogleAnalytics.trackEvent('ShareUserInvitation' + type,'Prompt',code);
    var overlay = jQuery('#share_join_overlay');
    overlay.on('click', '[data-dismiss="modal"]', function(e) {
      GoogleAnalytics.trackEvent('ShareUserInvitation' + type,'Close',code);
    });
    overlay.modal('show');
  },
  setModalTitle:function(name, title){
    jQuery('#' + name + ' .modal-header h3').text(title);
  },
  toggleModalClass:function(name, klass, toggle){
    jQuery('#' + name).toggleClass(klass, toggle);
  }
};

var Resources = {
  showAndHighlightForm:function() {
    $('resource_review_form').blindDown({
      duration:0.25,
      afterFinish:function() {
        new Effect.ScrollTo('resource_review_form', {
          duration:0.5,
          afterFinish:function(){
            $('resource_comment_box').highlight();
            $('resource_review_form').down('form').focusFirstElement();
          }
        });
      }
    });
  },
  addCommentForm:function() {
    if($('resource_review_form').visible()) {
      new Effect.BlindUp('resource_review_form', {duration:0.25});
      $('resource_review_form').down('form').reset();
      $('resource_review_form').down('em.highlight').update('');
    }
    else {
      Resources.showAndHighlightForm();
    }
  },
  goToEditForm:function() {
    if(!$('resource_review_form').visible()) {
      Resources.showAndHighlightForm();
    }
    else {
      new Effect.ScrollTo('resource_review_form', {
        duration:0.5,
        afterFinish:function(){
          $('resource_comment_box').highlight();
          $('resource_review_form').down('form').focusFirstElement();
        }
      });
    }
  },
  showSubmitForm:function() {
    if(!$('lead_gen_submission').visible()) {
      new Effect.BlindDown('lead_gen_submission', {
        duration:0.25,
        afterFinish:function() {
          new Effect.ScrollTo('lead_gen_submission', {duration:0.5});
        }
      });
    }
    else {
      new Effect.ScrollTo('lead_gen_submission', {duration:0.5});
    }
  },
  hideSubmitForm:function() {
    if($('lead_gen_submission').visible()) {
      Effect.BlindUp('lead_gen_submission', {durection:0.25});
      $('spiceworks_form').reset();
    }
  },
  hideConfirm:function() {
    if($('lead_gen_submission').visible()) {
      Effect.BlindUp('lead_gen_submission', {duration:0.5});
    }
  },
  updateRatingCount: function(count){
    var message = '(' + count + ' vote';
    if(count != 1){
      message = message + 's';
    }
    message = message + ')';
    $('resources_times_rated').update(message);
  },
  ratingConfirm:function() {
    $('resources_rate_confirm').update('Thanks');
    setTimeout(function() {
      $('resources_rate_confirm').update('');
    }, 3000);
  },
  _updatedRating: function(id){
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'LeadGenForm' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
        that.ratingConfirm();
        that.addCommentForm();
      }
    };
  },
  _newRating: function(id) {
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'LeadGenForm' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
        that.goToEditForm();
      }
    };
  },
  showThankYou:function() {
    new Effect.BlindDown('lead_gen_submission', {afterFinish: function() {
      new Effect.ScrollTo('lead_gen_submission', {offset:-30});
    }});
    $('ajax_busy').hide();
  },
  showMySurveys:function() {
    if(!$('my_surveys_list').visible()) {
      $('my_surveys_tab').addClassName('active');
      $('past_surveys_tab').removeClassName('active');
      $('my_surveys_list').show();
      $('past_surveys_list').hide();
    }
  },
  showPastSurveys:function() {
    if(!$('past_surveys_list').visible()) {
      $('my_surveys_tab').removeClassName('active');
      $('past_surveys_tab').addClassName('active');
      $('my_surveys_list').hide();
      $('past_surveys_list').show();
    }
  }
};

var PrivateMessageForm = {
  resetToFieldStyles:function(event) {
    switch(event.keyCode) {
     case Event.KEY_TAB:
     case Event.KEY_RETURN:
     case Event.KEY_ESC:
     case Event.KEY_LEFT:
     case Event.KEY_RIGHT:
     case Event.KEY_UP:
     case Event.KEY_DOWN:
       return;
    }
    $('topic_to_name').setStyle({
      color:'#000',
      fontWeight:'normal'
    });
  }
};

var PrivateMessageTopic = {
  reply:function(){
    jQuery('html, body').stop().animate({ scrollTop: jQuery("#topic-reply").offset().top - 50 }, 800);
    jQuery("#topic-reply #message_text").focus();
  },
  initElastic: function() {
    jQuery('#message_text').elastic();
  }
};

var NavigationManager = {
  initialize: function(sponsorshipURL){
    this.sponsorshipURL = sponsorshipURL;
    this.sponsorshipBox = $('sponsored_block');
    document.observe('dom:loaded', this._initializeSponsorshipBox.bindAsEventListener(this));
  },
  sponsorshipRender: function(content){
    if (content !== ''){
      this.sponsorshipBox.update(content);

      this.sponsorshipBox.select('a').each(function(anchor){
        if (!anchor.target) { anchor.setAttribute('target', '_blank'); }
      });

      this.sponsorshipBox.up('#navigation_closeout').addClassName('sponsored');
      this.sponsorshipBox.show();
    }
  },
  _initializeSponsorshipBox: function(){
    if(this.sponsorshipBox){
      DynamicScriptInclude.load( this.sponsorshipURL );
    }
  }
};

var Messaging = {
  PREFIX: 'application_messaging_',
  initialize: function(){
    if ( !this.initialized ){
      this.initialized = true;
      this.expiredMessages = $A();
      this.container = $( 'application_messaging' );
      if (!this.container) { return; }
      this.visible = this.container.visible();
      if ( !this.container ) { return; }

      this.list = new Element( 'ol' );
      this.container.appendChild(this.list);
      this.list = this.container.down('ol');
    }
  },
  push: function( messageID, messageBody, options ){
    if ( !this.initialized ) { this.initialize(); }

    var globalID = this.PREFIX + messageID; // create our element ID, should be unique
    if ( $(globalID) ) { return; } // if the element is already on the page, don't do anything

    options = Object.extend({
      dismissable:false, // give the message a clickable element to remove it
      ajaxOnDismiss:true, // fire an AJAX call when the dismiss button is clicked
      selfRemoving:false, // make the message remove itself after timeSeconds have lapsed
      timeoutSeconds:5 // when selfRemoving is true, this is time duration the message is displayed
    }, options || {});

    var message = new Element( 'li', { id: globalID, message_id: messageID }).update( messageBody );

    if ( options.dismissable ) { this._makeDismissable(message, messageID, options.ajaxOnDismiss); }

    this._hideAll();
    this.list.appendChild( message );

    this.container.appear({duration:0.50});
    this.visible = true;

    if ( options.selfRemoving ) { this.pop.bind(this, messageID).delay(options.timeoutSeconds); }

    return message;
  },
  pop: function( messageID ){
    var message;
    if (messageID) {
      message = this._removeByID(messageID);
    } else {
      message = this._removeLast();
    }

    this._hideAll();
    var last = this.messages().last();
    if (last) {
      last.show();
    } else {
      this._noMessages();
    }

    return message;
  },

  dismissMessage: function(event, messageID, ajaxOnDismiss){
    if (event) { event.stop(); }
    this.pop(messageID);
    if(ajaxOnDismiss){
      new Ajax.Request('/launch/dismiss_top_message/' + messageID, {
        parameters: { hide: true }
      });
    }
  },

  messages: function(){ return this.list.select( 'li' ); },

  _noMessages: function(){
    var self = this;
    setTimeout(function () {
      self.container.hide();
      self.visible = false;
    }, 500);
  },
  _makeDismissable: function( message, messageID, ajaxOnDismiss ){
    message.addClassName( 'dismissable' );
    var dismisser = new Element('a', { 'class': 'dismisser', title: 'Dismiss this message' } ).update('<img alt="dismiss" height="10" src="//static.spiceworks.com/assets/icons/square_close_white-323f002eecdd096382cf7ab0cff18a50.png" width="10" />');
    dismisser.observe('click', this.dismissMessage.bindAsEventListener(this, messageID, ajaxOnDismiss));
    message.appendChild(document.createTextNode(' '));
    message.appendChild(dismisser);
  },
  _removeByID: function( messageID ){
    return this._remove( this.list.down( '#' + this.PREFIX + messageID ) );
  },
  _removeLast: function(){
    return this._remove( this.messages().last() );
  },
  _remove: function( message ){
    if (message) { message.parentNode.removeChild(message); }
    return message;
  },

  _hideAll: function(){ this.messages().invoke( 'hide' ); }
};

var ContentBlock = {
  showEditForm:function(id){
    var contentBlock = $(id);
    contentBlock.down('div.content_block_wrapper').hide();
    contentBlock.down('div.content_block_form').show();
  },
  cancelEdit:function(id){
    var contentBlock = $(id);
    contentBlock.down('div.content_block_wrapper').show();
    contentBlock.down('div.content_block_form').hide();
    contentBlock.down('div.content_block_form form').reset();
  }
};

// Set up path for CKeditor
var CKEDITOR_BASEPATH = '/assets/ckeditor_3.6.5/';

var RichTextEditor = {
  replaceTextarea:function(id, mode, options){
    // load jQuery.Syntax
    var SyntaxRoot = "//static.spiceworks.com/assets/vendor/jquery-syntax/";
    jQuery.getScript(SyntaxRoot + "jquery.syntax.min.js", function () {
      jQuery.syntax({root: SyntaxRoot, layout: "table", replace: true});
    });

    var config = {
      customConfig: options.ck_config || null,
      contentsCss: options.ck_stylesheet || null,
      toolbar: (mode && mode == 'full') ? 'Full' : 'Basic',
      startupFocus: !!options.focus,
      resize_enabled: !!options.resizable
    };
    return CKEDITOR.replace(id, config);
  },
  insertAtCursor:function(id, text){
    CKEDITOR.instances[id].insertHtml(text);
  },
  reset:function(id){
    var editor = CKEDITOR.instances[id];
    editor.setData('', function(){
      editor.resetDirty();
    });
  },
  isDirty:function(id){
    return CKEDITOR.instances && CKEDITOR.instances[id] && CKEDITOR.instances[id].checkDirty();
  },
  resetDirty:function(id){
    return CKEDITOR.instances[id].resetDirty();
  },
  focus:function(id){
    return CKEDITOR.instances[id].focus();
  },
  destroy: function(id) {
    CKEDITOR.instances && CKEDITOR.instances[id] && CKEDITOR.instances[id].destroy();
  },
  updateElement: function(id) {
    CKEDITOR.instances && CKEDITOR.instances[id] && CKEDITOR.instances[id].updateElement();
  }
};

var Plugin = {
  updateRatingCount: function(count){
    var pluginRatingCountMessage = count + ' vote';
    if(count != 1){
      pluginRatingCountMessage = pluginRatingCountMessage + 's';
    }
    $('plugin_times_rated').update(pluginRatingCountMessage);
  },
  _starRatingSucceeded: function(id){
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'Plugin' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
      }
    };
  }
};

var PluginComment = {
  showForm: function(){
    jQuery('#shared_plugin_comment_content').wordCounter({
      container: '#add_comment_status',
      words: 10,
      submit: '#plugin_comment_button'
    });
    $('plugin_comment_interaction_box').down('form').blindDown({
      duration: 0.5,
      afterFinish: function(){
        new Effect.ScrollTo('plugin_comment_interaction_box', {
          duration: 0.5,
          afterFinish:function(){
            $('plugin_comment_interaction_box').highlight();
            $('shared_plugin_comment_content').focus();
          }
        });
      }
    });
  },
  hideForm: function(){
    var commentForm = $('plugin_comment_interaction_box').down('form');
    commentForm.blindUp({
      duration:0.5,
      afterFinish:function(){
        commentForm.reset();
      }
    });
  },
  showErrors: function(errors){
    $('add_comment_status').update(errors);
    Form.Element.enable("plugin_comment_button");
    $('plugin_comment_interaction_box').highlight();
    $('shared_plugin_comment_content').focus();
  },
  actionLink: function(){
    this.showForm();
  },
  _starRatingSucceeded: function(klass, id, has_comments){
    var that = this;
    return function(event){
      if(!has_comments && event.memo.count && event.memo['class'] == klass && event.memo.id == id){
        that.showForm();
      }
    };
  }
};

var SharedPluginDescription = {
  showForm: function(){
    jQuery('#shared_plugin_description_form').on( 'form-pre-serialize', function() {
      RichTextEditor.updateElement('shared_plugin_description');
      return true;
    });

    $('shared_plugin_description_content').hide();
    $('shared_plugin_description_form').show();
  },
  hideForm: function(){
    $('shared_plugin_description_form').hide();
    $('shared_plugin_description_content').show();
    $('shared_plugin_description_form').down('form').reset();
  },
  actionLink: function(){
    this.showForm();
    new Effect.ScrollTo('description_section', {
      duration:0.5,
      afterFinish:function(){
        $('description_section').highlight();
      }
    });
  }
};

var SharedPluginName = {
  showForm: function(){
    $('shared_plugin_name_content').hide();
    $('shared_plugin_name_form').show();
  },
  hideForm: function(){
    $('shared_plugin_name_form').hide();
    $('shared_plugin_name_content').show();
    $('shared_plugin_name_form').down('form').reset();
  },
  actionLink: function(){
    this.showForm();
    new Effect.ScrollTo('name_section', {
      duration:0.5,
      afterFinish:function(){
        $('name_section').highlight();
      }
    });
  }
};

var PluginImage = {
  init: function(){
    this._attachHandlers();
  },
  showForm: function(){
    $('plugin_image_form_toggler').hide();
    $('plugin_image_form').show();
  },
  hideForm: function(){
    $('plugin_image_form').hide();
    $('plugin_image_form_toggler').show();
    $('plugin_image_form').reset();
    Form.Element.enable('plugin_image_form_upload_button');
  },
  imageComplete: function(){
    var that = this;
    setTimeout(function() {
      $('plugin_image_message').update('');
      that.hideForm();
    }, 3000);
  },
  imageError: function(){
    setTimeout(function(){
      $('plugin_image_message').update('');
    }, 3000);
  },
  actionLink: function(){
    this.showForm();
    new Effect.ScrollTo('plugin_images', {
      duration:0.5,
      afterFinish:function(){
        $('plugin_images').highlight();
      }
    });

  },
  _attachHandlers:function(){
    var that = this;
    if(Browser.IE6){
      var listItems = $$('#plugin_images ul.plugin_images li');
      listItems.invoke('observe', 'mouseover', that._mouseOver);
      listItems.invoke('observe', 'mouseout', that._mouseOut);
    }
  },
  _mouseOver:function(event){
    event.findElement('li').addClassName('hover');
  },
  _mouseOut:function(event){
    event.findElement('li').removeClassName('hover');
  }
};

var FeaturedPlugin = {
  initialize: function() {
    this.container = $('featured_plugins');
    this.children = this.container.select('div.plugin_feature');
    this.buttons = $('scrolling_buttons');
    if(this.buttons) {
      this.nextButton = this.buttons.down('a.next_button');
      this.prevButton = this.buttons.down('a.prev_button');
    }
    this.lastPage = this.children.length - 1;
    this.currentPage = 0;
    this.updateScrollButton();
  },
  scrollTo: function(page) {
    var newLeft = 434 * page;
    new Effect.Morph(this.container, {
      style:{left: -newLeft + 'px'},
      duration: 1
    });
    this.currentPage = page;
    this.updateScrollButton();
  },
  nextPage: function() {
    if(this.currentPage < this.lastPage) {
      this.scrollTo(this.currentPage + 1);
    }
  },
  prevPage: function() {
    if(this.currentPage > 0) {
      this.scrollTo(this.currentPage - 1);
    }
  },
  updateScrollButton: function() {
    if(this.prevButton) {
      if(this.currentPage > 0) {
        this.prevButton.show();
      }
      else {
        this.prevButton.hide();
      }
    }
    if(this.nextButton) {
      if(this.currentPage < this.lastPage) {
        this.nextButton.show();
      }
      else {
        this.nextButton.hide();
      }
    }
  }
};

var LanguagePack = {
  updateRatingCount: function(count){
    var languagePackRatingCountMessage = count + ' vote';
    if(count != 1){
      languagePackRatingCountMessage = languagePackRatingCountMessage + 's';
    }
    $('language_pack_times_rated').update(languagePackRatingCountMessage);
  },
  _starRatingSucceeded: function(id){
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'LanguagePack' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
      }
    };
  }
};

var ReportComment = {
  showForm: function(){
    $('report_comment_interaction_box').down('form').blindDown({
      duration: 0.5,
      afterFinish: function(){
        new Effect.ScrollTo('report_comment_interaction_box', {
          duration: 0.5,
          afterFinish:function(){
            $('report_comment_interaction_box').highlight();
            $('shared_report_comment_content').focus();
          }
        });
      }
    });
  },
  hideForm: function(){
    var commentForm = $('report_comment_interaction_box').down('form');
    commentForm.blindUp({
      duration:0.5,
      afterFinish:function(){
        commentForm.reset();
      }
    });
  },
  showErrors: function(errors){
    $('add_comment_status').update(errors);
    Form.Element.enable("report_comment_button");
    $('report_comment_interaction_box').highlight();
    $('shared_report_comment_content').focus();
  },
  actionLink: function(){
    this.showForm();
  }
};

var ReportDescription = {
  showForm: function(){
    $('report_description_content').hide();
    $('report_description_form').show();
  },
  hideForm: function(){
    $('report_description_form').hide();
    $('report_description_content').show();
    $('report_description_form').down('form').reset();
  },
  actionLink: function(){
    this.showForm();
    $('report_description_section').highlight();
  }
};

var HallOfFame = {
  showWeekly: function(name) {
    if(!$(name + "_week").visible()) {
      $(name + "_month").hide();
      $(name + "_alltime").hide();
      $(name + "_week").show();
    }
  },
  showMonthly: function(name) {
    if(!$(name + "_month").visible()) {
      $(name + "_week").hide();
      $(name + "_alltime").hide();
      $(name + "_month").show();
    }
  },
  showAllTime: function(name) {
    if(!$(name + "_alltime").visible()) {
      $(name + "_month").hide();
      $(name + "_week").hide();
      $(name + "_alltime").show();
    }
  }
};

PostAttachment = {
  showForm:function(){
    var attachment_wrap = $('attachment_wrap');
    if(!attachment_wrap.visible()){
      attachment_wrap.appear({'duration':0.5});
      $('attachment_button').hide();
      $('cancel_attachment_button').show();
      $('include_attachment').value = "true";
    }
  },
  cancel:function(){
    var attachment_wrap = $('attachment_wrap');
    if(attachment_wrap.visible()){
      attachment_wrap.fade({'duration':0.5});
      $('cancel_attachment_button').hide();
      $('attachment_button').show();
      $('include_attachment').value = "false";
    }
  }
};

var SharePlugin = {
  acceptTerms:function(){
    var accept = !!$F('accept_terms');
    new Ajax.Request('/plugin/accept_terms', {
      synchronous: true,
      parameters:{
        'accept':accept
      }
    });
    if(accept){
      Form.Element.enable('share_button');
    } else {
      Form.Element.disable('share_button');
    }
  }
};

var WindowsEvent = {
  updateRatingCount: function(count){
    var eventRatingCountMessage = count + ' vote';
    if(count != 1){
      eventRatingCountMessage = eventRatingCountMessage + 's';
    }
    $('windows_event_times_rated').update(eventRatingCountMessage);
  },
  _starRatingSucceeded: function(id, has_comments){
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'WindowsEvent' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
      }
    };
  },
  showEdit: function() {
    if(!$('windows_event_edit_description').visible()) {
      $('windows_event_description').hide();
      $('windows_event_edit_description').show();
    }
  },
  cancelEdit: function() {
    if($('windows_event_edit_description').visible()) {
      $('windows_event_edit_description').hide();
      $('windows_event_description').show();
      $('edit_description_form').reset();
    }
  }
};

var WindowsEventComment = {
  showForm: function(){
    var commentWrap = $('windows_event_comment_wrapper');
    if(!commentWrap.visible()) {
      commentWrap.blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('windows_event_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('windows_event_comment_box').highlight();
              commentWrap.down('form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('windows_event_comment_box', {duration: 0.5});
    }
  },
  hideForm: function(){
    var commentWrap = $('windows_event_comment_wrapper');
    if(commentWrap.visible()) {
      commentWrap.blindUp({duration: 0.5});
      commentWrap.down('form').reset();
    }
  }
};

var Subscription = {
  optionsToggle:function() {
    if($('community_digest_options').visible()) {
      $('community_digest_options').hide();
    }
    else {
      $('community_digest_options').show();
    }
  },
  unsubscribeStatus:function(dom_id) {
    $(dom_id).down('div.unsubscribe').update('<em class="highlight">Unsubscribing...</em>');
  },
  showBusy:function(dom_id) {
    $(dom_id).update('<img alt="" src="//static.spiceworks.com/assets/icons/ajax_busy-96d19e6b2f93905af43fffd61eca79c4.gif" />');
  }
};

var FeatureRequest = {
  showCommentForm:function() {
    if(!$('feature_request_comment_form').visible()) {
      $('feature_request_comment_form').blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('feature_request_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('feature_request_comment_box').highlight();
              $('feature_request_comment_form').down('form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('feature_request_comment_box', {duration:0.5});
    }
  },
  hideCommentForm:function() {
    if($('feature_request_comment_form').visible()) {
      new Effect.BlindUp('feature_request_comment_form', {duration:0.5});
    }
  }
};

var FlashMessage = {
  hide: function(dom_id) {
    window.setTimeout( function(){
      $(dom_id).blindUp();
    }.bind( this ), 5000);
  }
};

/* Manage the ad refreshing for the app
 * Reload when user comes back to the app from another tab/application
 * Watches for window focus to do the reloading.
 * (Wrapped to keep this all out of the global NS)
 */
(function () {
  var timeout = null,
  allowSwap = false,
  swapDelay = 3000, // 3 Seconds before swapping
  showAtLeast = 60000; // 60 Seconds per ad (at least)

  // Set Allow Swap to true after some time.
  function startCountdownToSwap() {
    allowSwap = false;
    setTimeout(doAllowSwap, showAtLeast);
  }
  function doAllowSwap() {
    allowSwap = true;
  }

  function onTabFocus () {
    clearTimeout(timeout);
    timeout = setTimeout(function () {
      if (allowSwap) {
        startCountdownToSwap();
        Application.refreshAd();
      }
    }, swapDelay);
  }

  // if we leave, just clear the timeout so we don't reload
  function onTabBlur () {
    clearTimeout(timeout);
  }

  Event.observe(window, 'focus', onTabFocus);
  Event.observe(window, 'blur', onTabBlur);
  startCountdownToSwap();
})();

var ManualScoreAchievement = {
  plus: function(id) {
    $('msa_id').value = id;
    $('msa_form').action = "/manual_score_achievement/add_one_for_user";
    $('add_remove_'+id).innerHTML = "Saving . . .";
    $('msa_form').submit();
  },
  minus: function(id) {
    $('msa_id').value = id;
    $('msa_form').action = "/manual_score_achievement/remove_one_for_user";
    $('add_remove_'+id).innerHTML = "Saving . . .";
    $('msa_form').submit();
  }
};

var ScriptComment = {
  showForm: function(){
    jQuery('#script_comment_content').wordCounter({
      container: 'em.highlight',
      words: 10,
      submit: '#script_comment_button'
    });
    var commentWrap = $('script_comment_wrapper');
    if(!commentWrap.visible()) {
      commentWrap.blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('script_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('script_comment_box').highlight();
              commentWrap.down('form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('script_comment_box', {duration: 0.5});
    }
  },
  hideForm: function(){
    var commentWrap = $('script_comment_wrapper');
    if(commentWrap.visible()) {
      commentWrap.blindUp({duration: 0.5});
      commentWrap.down('form').reset();
    }
  },
  _starRatingSucceeded: function(id, has_comments){
    var that = this;
    return function(event){
      if(!has_comments && event.memo.count && event.memo['class'] == 'Script' && event.memo.id == id){
        that.showForm();
      }
    };
  }
};

var ScriptImage = {
  init: function(){
    this._attachHandlers();
  },
  showForm: function(){
    $('script_image_form_toggler').hide();
    $('script_image_form').show();
  },
  hideForm: function(){
    $('script_image_form').hide();
    $('script_image_form_toggler').show();
    $('script_image_form').reset();
    Form.Element.enable('script_image_form_upload_button');
  },
  imageComplete: function(){
    var that = this;
    setTimeout(function() {
      $('script_image_message').update('');
      that.hideForm();
    }, 3000);
  },
  imageError: function(){
    setTimeout(function(){
      $('script_image_message').update('');
    }, 3000);
  },
  actionLink: function(){
    this.showForm();
    new Effect.ScrollTo('script_screenshots', {
      duration:0.5,
      afterFinish:function(){
        $('script_screenshots').highlight();
      }
    });
  },
  _attachHandlers:function(){
    var that = this;
    if(Browser.IE6){
      var listItems = $$('#script_screenshots ul.script_images li');
      listItems.invoke('observe', 'mouseover', that._mouseOver);
      listItems.invoke('observe', 'mouseout', that._mouseOut);
    }
  },
  _mouseOver:function(event){
    event.findElement('li').addClassName('hover');
  },
  _mouseOut:function(event){
    event.findElement('li').removeClassName('hover');
  }
};

var Scripts = {
  selectNewDiffVersion: function(elem){
    $('new_selected').value='true';
    var id = elem.id;
    id = id.substring(4);
    var diff_form = $('diff_form');
    nElements = diff_form.length;
    for (i=0; i<nElements; i++){
      if (diff_form[i].type == "radio"){
        if (diff_form[i].id.substring(0,3) == 'old'){
          diff_form[i].selected = false;
          diff_form[i].disabled = false;
        }
      }
    }
//    $('old_'+id).disable();
    if($('old_selected').value == 'true' && $('new_selected').value == 'true'){
      Form.Element.enable('diff_submit');
    }
  },
  selectOldDiffVersion: function(elem){
    $('old_selected').value='true';
    var id = elem.id;
    id = id.substring(4);
    var diff_form = $('diff_form');
    nElements = diff_form.length;
    for (i=0; i<nElements; i++){
      if (diff_form[i].type == "radio"){
        if (diff_form[i].id.substring(0,3) == 'new'){
          diff_form[i].selected = false;
          diff_form[i].disabled = false;
        }
      }
    }
//    $('new_'+id).disable();
    if($('old_selected').value == 'true' && $('new_selected').value == 'true'){
      Form.Element.enable('diff_submit');
    }
  },
  updateRatingCount: function(count){
    var message = count + ' vote';
    if(count != 1){
      message = message + 's';
    }
    $('script_times_rated').update(message);
  },
  _starRatingSucceeded: function(id){
    var that = this;
    return function(event){
      if(event.memo.count && event.memo['class'] == 'Script' && event.memo.id == id){
        that.updateRatingCount(event.memo.count);
      }
    };
  }
};

var BlogTopic = {
  attachListeners: function(elem){
    elem.observe('mouseover', this._mouseover.bindAsEventListener(elem) );
    elem.observe('mouseout', this._mouseout.bindAsEventListener(elem) );
  },
  _mouseover: function(event){
    this.down('.blog_actions').show();
  },
  _mouseout: function(event){
    this.down('.blog_actions').hide();
  }
};

var Follow = (function(){

  var popupFollow = function(el){
    var type = el.readAttribute('data-type'),
        id = el.readAttribute('data-id'),
        url = el.readAttribute('data-url'),
        memo = {type: type, id: id};

    el.up('.popup')
      .addClassName('following')
      .removeClassName('not_following');

    new Ajax.Request(url, {parameters: {no_response: true}});
    SPICEWORKS.fire("connection:followed", memo);
    SPICEWORKS.fire("popup:followed", memo);
  };

  var popupUnfollow = function(el){
    var type = el.readAttribute('data-type'),
        id = el.readAttribute('data-id'),
        url = el.readAttribute('data-url'),
        memo = {type: type, id: id};

    el.up('.popup')
      .addClassName('not_following')
      .removeClassName('following');

    new Ajax.Request(url, {parameters: {no_response: true}});
    SPICEWORKS.fire("connection:unfollowed", memo);
    SPICEWORKS.fire("popup:unfollowed", memo);
  };

  var followManager = {
    initialize: function(){
      Event.observe(document.body,'click',function(ev){
        var link = ev.findElement('a');
        var input = ev.findElement('input');
        var el = (link && link != document) ? link : input;
        if(!el || el == document) { return; }
        el = $(el);

        var is_follow = el.hasClassName('follow'),
            is_unfollow = el.hasClassName('unfollow');

        if(is_follow || is_unfollow){
          if(el.up('.suggestion')) { return; }
          if(is_follow){
            popupFollow(el);
          } else if(is_unfollow) {
            popupUnfollow(el);
          }
        }
      });
    }
  };

  Event.register(followManager);

  return {};
})();

var Extensions = {
  initialize:function() {
    var nav = $('extensions_navigation');
    var content = $('extensions_header_content');
    Event.observe(nav, 'mouseover', this.navMouseOver);
    Event.observe(content, 'mouseout', this.contentMouseOut);
  },
  navMouseOver:function(event) {
    elem = Event.element(event).up('li').identify();
    Extensions.mouseOverFor(elem.replace('_select', ''));
  },
  mouseOverFor:function(type) {
    Extensions.resetContent();
    $('extensions_header').down('div.content').addClassName('sub_content');
    $(type + '_select').addClassName('selected');
    $(type + '_description').show();
  },
  contentMouseOut:function(event) {
    elem = $(event.relatedTarget || event.toElement);
    if(elem.id == "extensions_header_content" || elem.up('div#extensions_header_content')) {
      event.stop();
    }
    else {
      Extensions.defaultContent();
    }
  },
  defaultContent:function() {
    $('extensions_header').down('div.content').removeClassName('sub_content');
    Extensions.resetContent();
    $('default_description').show();
  },
  resetContent:function() {
    $$('ul#extensions_navigation li').each(function(item) {
      item.removeClassName('selected');
    });
    $$('div#extensions_more_info div.extension_description').each(function(section) {
      section.hide();
    });
  }
};

var HelpCategory;

var HelpNavigation = {
  toggleNavi:function() {
    navi = $('help_navigation');
    button = $('help_navigation_drop');
    if(!navi.visible()) {
      Cookie.set('help_navigation', 'open', {});
      button.addClassName('selected');
      new Effect.BlindDown(navi, {duration:0.25});
    }
    else {
      Cookie.set('help_navigation', 'close', {});
      button.removeClassName('selected');
      new Effect.BlindUp(navi, {duration:0.25});
    }
  }
};

var HelpColumn = Class.create({
  initialize:function(items, parent_column) {
    this.child = null;
    this.parent_column = parent_column;
    this.column = new Element('div', {'class': 'category_column'});
    this.items = items;
  },
  draw:function() {
    var list = new Element('ul');
    $('help_category_wrapper').insert(this.column.insert(list));
    this.drawItems(this.items);
  },
  drawDefault:function() {
    this.column.addClassName('default_message');
    this.column.insert('<span class="message">Select A Category</span>');
    $('help_category_wrapper').insert(this.column);
  },
  kill:function() {
    if(this.child) {
      this.child.kill();
    }
    this.column.replace("");
    this.child = null;
    this.parent_column = null;
  },
  setChild:function(child_column) {
    if(this.child) {
      this.child.kill();
    }
    this.child = child_column;
  },
  selectItem:function(item) {
    this.column.select('li').each(function(li) {
      li.removeClassName('selected');
    });
    item.addClassName("selected");
  },
  drawItems:function(list_items) {
    var that = this;
    var list = this.column.down('ul');
    if(!this.parent_column) {
      list.addClassName('root_categories');
    }
    list_items.each(function(item) {
      var list_item = new Element('li', {id:'node_' + item.id});
      var link_tag;

      if(item.url || item.page_id) {
        list_item.addClassName("page");
        var path = "";
        if(item.url) {
          path = item.url;
        }
        else if(item.page_id && item.page) {
          path = escape("/help/" + item.page.name);
        }
        if(item.anchor) {
          path += "#" + item.anchor;
        }
        link_tag = new Element('a', {href: path}).update(item.name.escapeHTML());
      }
      else {
        if(!this.parent_column) {
          list_item.addClassName(item.name.toLowerCase().replace(/\s/g, "_"));
        }
        link_tag = new Element('a').update(item.name.escapeHTML());
        link_tag.observe('click', that.observeItem.curry(list_item, item).bindAsEventListener(that));
      }
      list_item.insert(link_tag);
      list.insert(list_item);
    });
  },
  observeItem:function(list_item, item) {
    this.selectItem(list_item);
    HelpCategory.initialize('/help_category/show/' + item.id + '.json', this);
  }
});

HelpCategory = {
  initialize:function(url, parent_column) {
    new Ajax.Request(url, {
      method:"get",
      onSuccess:function(transport) {
        var roots = transport.responseJSON;
        if(roots && roots.size() > 0) {
          var column = new HelpColumn(roots, parent_column);
          if(parent_column) {
            parent_column.setChild(column);
          }
          column.draw();
          if(!parent_column) {
            var default_column = new HelpColumn(null, column);
            column.setChild(default_column);
            default_column.drawDefault();
            var cookie = Cookie.get('help_navigation');
            if($('help_navigation_drop')) {
              if(!(cookie && cookie == 'close')) {
                $('help_navigation').show();
                $('help_navigation_drop').addClassName('selected');
              }
              $('help_navigation_drop').show();
            }
            else {
              $('help_navigation').show();
            }
          }
        }
        else if(parent_column && parent_column.child) {
          parent_column.setChild(null);
        }
      }
    });
  },
  initializeFromNode:function(url) {
    var current_column = null;
    new Ajax.Request(url, {
      method:"get",
      onSuccess:function(transport) {
        var node = transport.responseJSON;
        var parent_column = null;
        if(node) {
          if(node.parent_node) {
            parent_column = HelpCategory.initializeFromNode('/help_category/siblings/' + node.parent_node.id + '.json');
            current_column = new HelpColumn(node.siblings, parent_column);
            current_column.draw();
            $('node_' + node.self_node.id).addClassName('selected');
            parent_column.setChild(current_column);
          }
          else {
            current_column = new HelpColumn(node.siblings, null);
            current_column.draw();
            $('node_' + node.self_node.id).addClassName('selected');
            var cookie = Cookie.get('help_navigation');
            if($('help_navigation_drop')) {
              if(!(cookie && cookie == 'close')) {
                $('help_navigation').show();
                $('help_navigation_drop').addClassName('selected');
              }
              $('help_navigation_drop').show();
            }
            else {
              $('help_navigation').show();
            }
          }
        }
      },
      asynchronous: false
    });
    return current_column;
  },
  initializeFromPage:function(page_id) {
    var anchor = unescape(self.document.location.hash.substring(1));
    new Ajax.Request('/help_category/node_for_page/' + page_id + ".json?anchor=" + anchor, {
      method:"get",
      onSuccess:function(transport) {
        var node = transport.responseJSON;
        if(node) {
          HelpCategory.initializeFromNode('/help_category/siblings/' + node.id + '.json');
        }
        else {
          HelpCategory.initialize('/help_category/root.json', null);
        }
      }
    });
  }
};

var MeetingComment = {
  showForm: function(){
    var commentWrap = $('meeting_comment_wrapper');
    if(!commentWrap.visible()) {
      commentWrap.blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('meeting_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('meeting_comment_box').highlight();
              commentWrap.down('form').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('meeting_comment_box', {duration: 0.5});
    }
  },
  hideForm: function(){
    var commentWrap = $('meeting_comment_wrapper');
    if(commentWrap.visible()) {
      commentWrap.blindUp({duration: 0.5});
      commentWrap.down('form').reset();
    }
  },
  _starRatingSucceeded: function(id, has_comments){
    var that = this;
    return function(event){
      if(!has_comments && event.memo.count && event.memo['class'] == 'Meeting' && event.memo.id == id){
        that.showForm();
      }
    };
  }
};

var MeetingAttendance = {
  selectAll:function(){
    $$('#edit_attendance_form input[type=checkbox]').each(function(input){
      input.checked = true;
    });
  },
  deselectAll:function(){
    $$('#edit_attendance_form input[type=checkbox]').each(function(input){
      input.checked = false;
    });
  }
};

var ComparisonTable = {
  voteUp:function(dom_id, updated_up_count, updated_down_count, orig_vote_value) {
    ComparisonTable.disableUpVote(dom_id);
    $(dom_id).down('span.up_rating_count').update(updated_up_count);
    ComparisonTable.disableGrayDownVote(dom_id);
    if(parseInt(orig_vote_value, 10) == -1) {
      $(dom_id).down('span.down_rating_count').update(updated_down_count);
    }
  },
  removeUpVote:function(dom_id, updated_up_count) {
    ComparisonTable.disableGrayUpVote(dom_id);
    $(dom_id).down('span.up_rating_count').update(updated_up_count);
    ComparisonTable.disableGrayDownVote(dom_id);
  },
  voteDown:function(dom_id, updated_up_count, updated_down_count, orig_vote_value) {
    ComparisonTable.disableDownVote(dom_id);
    $(dom_id).down('span.down_rating_count').update(updated_down_count);
    ComparisonTable.disableGrayUpVote(dom_id);
    if(parseInt(orig_vote_value, 10) == 1) {
      $(dom_id).down('span.up_rating_count').update(updated_up_count);
    }
  },
  removeDownVote:function(dom_id, updated_down_count) {
    ComparisonTable.disableGrayDownVote(dom_id);
    $(dom_id).down('span.down_rating_count').update(updated_down_count);
    ComparisonTable.disableGrayUpVote(dom_id);
  },
  disableUpVote:function(dom_id) {
    $(dom_id).down('a.up_vote').replace('<img alt="" class="rating" src="//static.spiceworks.com/assets/icons/small/like-9833669c303408d3c8d1b360af2ed708.png" />');
  },
  disableGrayUpVote:function(dom_id) {
    $(dom_id).down('a.up_vote').replace('<img alt="" class="rating" src="//static.spiceworks.com/assets/community/icons/small/like_gray-678a3936fa098f4a8fa314cdf3332ada.png" />');
  },
  disableDownVote:function(dom_id) {
    $(dom_id).down('a.down_vote').replace('<img alt="" class="rating" src="//static.spiceworks.com/assets/icons/small/dislike-3d1a9e1efe63134d3d114cd74d69c20d.png" />');
  },
  disableGrayDownVote:function(dom_id) {
    $(dom_id).down('a.down_vote').replace('<img alt="" class="rating" src="//static.spiceworks.com/assets/community/icons/small/dislike_gray-ae519898953ba4fced2cbe6f41239966.png" />');
  },
  showCellActions:function(elem) {
    $(elem).down('span.cell_actions').show();
  },
  hideCellActions:function(elem) {
    $(elem).down('span.cell_actions').hide();
  },
  propertySelect:function(type) {
    var decimal = $('decimal_places');
    if(type == "number") {
      if(!decimal.visible()) {
        decimal.show();
      }
    }
    else {
      if(decimal.visible()) {
        decimal.hide();
      }
    }
  },
  showCommentForm:function() {
    if(!$('comparison_table_comment_form').visible()) {
      $('comparison_table_comment_form').blindDown({
        duration:0.5,
        afterFinish: function() {
          new Effect.ScrollTo('comparison_table_comment_box', {
            duration: 0.5,
            afterFinish: function() {
              $('comparison_table_comment_box').highlight();
              $('new_comparison_table_comment').focusFirstElement();
            }
          });
        }
      });
    }
    else {
      new Effect.ScrollTo('comparison_table_comment_box', {duration: 0.5});
    }
  },
  hideCommentForm:function() {
    if($('comparison_table_comment_form').visible()) {
      Effect.BlindUp('comparison_table_comment_form', {duration:0.5});
      $('add_comment_status').update('');
      $('new_comparison_table_comment').reset();
    }
  },
  initializeScrollingTable: function() {
    Event.observe('comparison_attributes', 'scroll', function() {
      $('record_headers').setStyle({left: "-" + $('comparison_attributes').scrollLeft + "px"});
      $('comparison_properties').setStyle({top: "-" + $('comparison_attributes').scrollTop + "px"});
    });
  },
  scrollToCell: function(cell) {
    $('comparison_attributes').scrollTop = $(cell).offsetTop;
    $('comparison_attributes').scrollLeft = $(cell).offsetLeft;
  }
};

var ComparisonTableOverlay = Class.create({
  cell_link:null,
  overlay:null,
  initialize:function(cell){
    this.cell_link = cell.down('a.more_link');
    this.overlay = cell.adjacent('div.cell_overlay').first();
    this._attachListeners();
  },
  _update: function(menu) {
    $(document.body).insert(menu.remove());
  },
  _attachListeners: function(){
    // var that = this;
    if(this.cell_link && this.overlay){
      new SPICEWORKS.ui.SimpleMenu(this.cell_link, this.overlay, {
        alignment: 'left',
        verticalAlignment: 'top',
        offsetLeft: 50,
        activatorZIndex:1,
        menuZIndex:2,
        update:this._update
      });
    }
  }
});

var ComparisonTableOverlayManager = {
  initialize:function(){
    $$('div.string_cell_wrapper').each(function(cell){
      if(cell.down('a.more_link')) {
        new ComparisonTableOverlay(cell);
      }
    });
  }
};

var StatusBar = {
  popups: {},
  key: 'status_bar_indicators',
  initialize: function(){
    this.initializeIndicators();
  },
  initializeIndicators: function() {
    this.popups = {};

    this.popups.messages = SUI.statusBarPopup($("status-messages"), {
      title: "Private Messages",
      count: User.unreadCount,
      hideCountOnZero: true,
      onShow: this.callbacks.messages.onShow
    });

    this.popups.community =  SUI.statusBarPopup($("status-community"), {
      title: "Community Activity",
      hideCountOnZero: true,
      count: 0,
      beforeShow: this.callbacks.community.beforeShow,
      afterInitialize: this.callbacks.community.afterInitialize,
      onShow: this.callbacks.community.onShow
    });

    this.popups.recentlyViewed =  SUI.statusBarPopup($("status-recently-viewed"), {
      title: "Recently Viewed",
      hideCountOnZero: true,
      count: 0,
      beforeShow: this.callbacks.recentlyViewed.beforeShow,
      onShow: this.callbacks.recentlyViewed.onShow
    });

    new SPICEWORKS.ui.SimpleMenu($('indicator-community-about'), $('status-community-about').down('div.popup'), {
      align:function(menu, activator){} // Skip the align callback
    });
  },
  callbacks: {
    generic: {
      beforeShow: function(self) {
         self.setData('lastSeen', self.getData('seen'));
         if (!self.getData('data')) {
           self.resetLayout("Loading&hellip;");
           self.clearFlag('unseen');
         }
      },
      afterInitialize: function(self) {
        // So any new items that come in after page load will be marked as new
        self.setData('seen', new Date());
      },
      afterShow: function(self) {
        self.setData('seen', new Date());
      }
    },
    community: {
      beforeShow: function(self) {
        // If data isn't set, it means that the count changed since the last time we refreshed
        if (!self.getData('data')) {
           self.resetLayout("Loading&hellip;");
           self.clearFlag('unseen');
        }
      },
      afterInitialize: function(self) {
        function calculateLastSeen(data) {
          var serverLastSeen, cookieLastSeen, cookieValue;

          cookieValue = Cookie.get('statusBarActivityLastSeen');
          if(cookieValue) {
            cookieLastSeen = new Date(unescape(cookieValue));
          }

          if (data.lastSeen){
            serverLastSeen = new Date(data.lastSeen);
          }

          self.setData('lastSeen', [cookieLastSeen, serverLastSeen].max());
        }

        function updateCount(data) {
          var lastSeen = self.getData('lastSeen');
          if (data.timestamps) {
            var count = data.timestamps.select(function(time) {
              return !lastSeen || (new Date(time)) > lastSeen;
            }).size();
            self.setCount(count);
          }
        }

        function response(data) {
          calculateLastSeen(data);
          updateCount(data);
        }

        function refresh() {
          SPICEWORKS.community.activity.userTimestamps({}, response, "status_bar");
        }

        refresh(); // Do a refresh
        SPICEWORKS.utils.focusTimer(60, false, refresh);
      },
      onShow: function(self) {
        function displayData(data){
          var lastSeen = self.getData('lastSeen');
          self.setFooter(SPICEWORKS.community.linkTo(data.path).update("View Community Activity"));
          if (data.activities.size() > 0) {
            var formatted = data.activities.inject([], function(memo, value, index) {
              memo.push({
                title: value.title,
                subtitle: value.subtitle,
                icon: SPICEWORKS.community.url(value.icon['20px'].path),
                message: SUI.truncate(value.message, 150),
                date: value.timestamp,
                when: self.formatters.date(value.timestamp),
                type: 'activity',
                url: SPICEWORKS.community.url(value.path),
                unseen: !lastSeen || (self.getData('lastSeen') < new Date(value.timestamp))
              });
              return memo;
            });
            self.update(self.builders.list(formatted));

            lastSeen = new Date(self.getData('lastSeen')).getTime();
            var latestStamp = new Date(data.activities[0].timestamp).getTime();
            self.setCount(0);
          }
          else {
            self.setPanelMessage("No Community Activity");
          }
        }

        function updateLastSeen(data) {
          var lastSeen = new Date();
          self.setData('lastSeen', lastSeen);
          Cookie.set('statusBarActivityLastSeen', lastSeen.toGMTString());
        }

        function response(data) {
          if (!data.error) {
            self.setData('data', data);
            updateLastSeen(data);
            displayData(data);
          }
          else {
            self.setPanelMessage("An Error Occurred, Please Try Again Later.");
          }
        }

        if (self.getData('data')) { displayData(self.getData('data')); }
        else { SPICEWORKS.community.activity.user({}, response, "status_bar"); }
      }
    },
    messages: {
      onShow: function(self) {
        self.setFooter(SPICEWORKS.community.linkTo('/messages/inbox').update("View Inbox"));
        function response(data) {
          if (!data.error) {
            self.setData('data', data);
            displayData(data);
          }
          else {
            self.setPanelMessage("An Error Occurred, Please Try Again Later.");
          }
        }

        function displayData(data){
          if (data.messages.size() > 0) {
            var formatted = data.messages.inject([], function(memo, value, index) {
              memo.push({
                title: new Element('span', {style: "color:#{color}".interpolate({color:value.from.color})}).update(value.from.name),
                subtitle: value.subject,
                icon: SPICEWORKS.community.url(value.from.avatars['20px'].path),
                message: SUI.truncate(value.text, 150),
                date: value.last_post_created_at,
                when: self.formatters.date(value.last_post_created_at),
                type: 'message ' + (value.unread ? "unread": ""),
                url: SPICEWORKS.community.url(value.path),
                unseen: (self.getData('lastSeen') && (self.getData('lastSeen') < new Date(value.last_post_created_at)))
              });
              return memo;
            });
            self.update(self.builders.list(formatted));
          }
          else {
            self.setPanelMessage("No Messages");
          }
        }
        if (self.getData('data')) {
          displayData(self.getData('data'));
        } else {
          SPICEWORKS.community.messages.inbox({}, response, "status_bar");
        }
      }
    },
    recentlyViewed: {
      beforeShow: function(self) {
        // If data isn't set, it means that the count changed since the last time we refreshed
        if (!self.getData('data')) {
           self.resetLayout("Loading&hellip;");
        }
      },
      onShow: function(self) {
        function displayData(data){
          self.setFooter(SPICEWORKS.community.linkTo(data.path).update("View Community Activity"));
          if (data.activities.size() > 0) {
            var formatted = data.activities.inject([], function(memo, value, index) {
              memo.push({
                title: value.title,
                subtitle: value.subtitle,
                icon: SPICEWORKS.community.url(value.icon['20px'].path),
                date: value.timestamp,
                when: 'Last viewed ' + self.formatters.date(value.timestamp).toLowerCase(),
                type: 'activity',
                url: SPICEWORKS.community.url(value.path)
              });
              return memo;
            });
            self.update(self.builders.list(formatted));
          }
          else {
            self.setPanelMessage("No topics have been viewed recently.");
          }
        }

        function response(data) {
          if (!data.error) {
            self.setData('data', data);
            displayData(data);
          }
          else {
            self.setPanelMessage("An Error Occurred, Please Try Again Later.");
          }
        }

        if (self.getData('data')) { displayData(self.getData('data')); }
        else { SPICEWORKS.community.activity.recentlyViewed({}, response, "status_bar"); }
      }
    }
  },
  cacheValues: function(json) {
    var currentValues = this.getCachedValues();
    Cookie.set(this.key, Object.toJSON(Object.extend(currentValues, json)), {path: '/'});
  },
  getCachedValues: function() {
    return unescape(Cookie.get(this.key) || "{}").evalJSON();
  }
};

var TextHelper = {
  incrementNumberInString: function(element, increment) {
    element = $(element);
    var newCount, match = element.innerHTML.match(/[0-9]+/);
    if (match) {
      newCount = parseInt(match[0], 10) + increment;
      element.update(element.innerHTML.replace(match[0], newCount));
    }
  },
  showFullText: function( id ){
    var brief = $( 'brief_text_for_' + id );
    var full = $( 'full_text_for_' + id );
    brief.hide();
    full.show();
  }
};

var LeadGenAdmin = {
  move_field_down: function(arrow_object) {
    row = $(arrow_object).up('tr');
    swap_row = row.next('tr');
    if (!swap_row) {
      return;
    }
    $(row).insert({before:$(swap_row)});
    row_id = $(row).down('.field_id').value;
    new Ajax.Request('/lead_gen/move_field', {parameters:{id:row_id, direction:'down'}});

  },
  move_field_up: function(arrow_object) {
    row = $(arrow_object).up('tr');
    swap_row = row.previous('tr');
    if (!swap_row) {
      return;
    }
    $(row).insert({after:$(swap_row)});
    row_id = $(row).down('.field_id').value;
    new Ajax.Request('/lead_gen/move_field', {parameters:{id:row_id, direction:'up'}});
  }
};

var Search = {
  toggleOptions: function() {
    options = $('advanced_search_options').down('div.options');
    if(options.visible()) {
      new Effect.BlindUp(options, {duration:0.25});
      $('advanced_search_options_link').removeClassName('opened');
    }
    else {
      new Effect.BlindDown(options, {duration:0.25});
      $('advanced_search_options_link').addClassName('opened');
    }
  }
};

var AccountSetupTimeout;
var AccountSetup = {
  checkBlank: function(event) {
    var field = jQuery("#display_name");
    if(field.val().blank()) {
      event.preventDefault();
      field.next("span.error").html("cannot be blank");
    }
  },
  delayedCheckName: function(element) {
    if(AccountSetupTimeout !== undefined){
      clearTimeout(AccountSetupTimeout);
    }
    AccountSetupTimeout = setTimeout(function(){AccountSetup.checkName(element);}, 300);
  },
  checkField: function(element) {
    element = jQuery(element);
    if(element.val().blank()) {
      element.addClass('error');
      element.next('span.error').html("cannot be blank");
    }
    else if(element.val().length < 3) {
      element.addClass('error');
      element.next('span.error').html("must be at least 3 characters");
    }
  },
  checkPasswordLength: function(element) {
    if(element.value.length < 8) {
      element.addClassName('error');
      element.next('span.error').update("must be at least 8 characters");
    }
    else {
      AccountSetup.checkField(element);
    }
  },
  checkPassword: function(element) {
    if($('password').value != element.value) {
      element.addClassName('error');
      element.next('span.error').update("passwords don't match");
    }
  },
  clearErrors: function(element) {
    element.removeClassName('error');
    element.next('span.error').update("");
  },
  checkName: function(element) {
    element = jQuery(element);
    var value = element.val();
    element.next('span.error').html('<img alt="" src="//static.spiceworks.com/assets/icons/ajax_busy-96d19e6b2f93905af43fffd61eca79c4.gif" />');
    var regex = /^[a-zA-Z0-9_@\-'()\s\.]+$/;
    var sw_regex = /spice.*?works/i;
    if(value.blank() || value.length < 3) {
      AccountSetup.checkField(element);
    }
    else if(value.toLowerCase().match("spiceworks")) {
      element.addClass('error');
      element.next('span.error').html('name cannot contain Spiceworks');
    }
    else if(sw_regex.test(value)) {
      element.addClass('error');
      element.next('span.error').html('name cannot contain spice works');
    }
    else if(!regex.test(value)) {
      element.addClass('error');
      element.next('span.error').html("name contains invalid characters");
    }
    else {
      jQuery.ajax({
        url :"/join/name_check?name=" + encodeURIComponent(value),
        method: 'get',
        complete: function(transport) {
          if(transport.responseText == "not available") {
            element.addClass('error');
            element.next('span.error').html("has already been taken");
          }
          else {
            element.removeClass('error');
            element.next('span.error').html('<img alt="" class="available_icon" src="//static.spiceworks.com/assets/community/icons/small/green_checkmark_circle-a95cc75611fbee9698d89e3ae1e41d00.png" />');
          }
        }
      });
    }
  },
  selectAllGroups: function() {
    $$('div#join_groups ul.groups li input[type="checkbox"]').each(function(element) {
      element.checked = true;
    });
  },
  deselectAllGroups: function() {
    $$('div#join_groups ul.groups li input[type="checkbox"]').each(function(element) {
      element.checked = false;
    });
  }
};

var SignupSetup = {
  displayStatus: function(element, msg, css_class) {
    css_class = css_class || '';
    var formCondition = element.next('.formError');
    if (formCondition) {
      formCondition.update(msg);
      formCondition.writeAttribute('class','formError ' + css_class);
    } else {
      element.insert({
        after: new Element('div', {'class': 'formError ' + css_class}).update(msg)
      });
    }
  },
  displayError: function(element, msg) {
    element.addClassName('error');
    SignupSetup.displayStatus(element,msg);
  },
  displaySuccess: function(element, msg) {
    element.removeClassName('error');
    SignupSetup.displayStatus(element,msg,'success');
  },
  displayBusy: function(element) {
                 SignupSetup.displayStatus(element,'<img alt="busy" id="busy" src="//static.spiceworks.com/assets/icons/ajax_busy-96d19e6b2f93905af43fffd61eca79c4.gif" />', 'busy');
  },
  checkField: function(element) {
    if(element.value.blank()) {
      element.addClassName('error');
      SignupSetup.displayError(element, "cannot be blank");
    }
    else if(element.value.length < 3) {
      element.addClassName('error');
      SignupSetup.displayError(element, "must be at least 3 characters");
    }
  },
  checkPasswordLength: function(element) {
    if(!element.value.blank() && element.value.length < 6) {
      SignupSetup.displayError(element, "Password must be at least 6 characters");
    }
  },
  checkPassword: function(element, passwordElemId) {
    passwordElemId = passwordElemId || 'password';
    if($(passwordElemId).value != element.value) {
      SignupSetup.displayError(element, "Passwords don't match");
    }
  },
  clearErrors: function(element) {
    element.removeClassName('error');
    var formError = element.next('.formError');
    if (formError) {
      formError.remove();
    } else {
      formError = element.up("p").next('.formError');
      if (formError) {
        formError.remove();
      }
    }
  },
  checkName: function(element) {
    var value = element.value;
    var regex = /^[a-zA-Z0-9_@\-'()\s\.]+$/;
    var sw_regex = /spice.*?works/i;
    if (value.blank()) {
      return;
    }
    else if (value.length < 3) {
      SignupSetup.displayError(element, "must be at least 3 characters");
    }
    else if(value.toLowerCase().match("spiceworks")) {
      SignupSetup.displayError(element, "name cannot contain Spiceworks");
    }
    else if(sw_regex.test(value)) {
      SignupSetup.displayError(element, "name cannot contain spice works");
    }
    else if(!regex.test(value)) {
      SignupSetup.displayError(element, "name contains invalid characters");
    }
    else {
      SignupSetup.displayBusy(element);
      new Ajax.Request("/join/name_check?name=" + encodeURIComponent(value), {
        method: 'get',
        onFailure: function(transport) {
          SignupSetup.clearErrors(element);
        },
        onSuccess: function(transport) {
          try{
            if(transport.responseText == "not available") {
              SignupSetup.displayError(element, "has already been taken");
            }
            else {
              SignupSetup.displaySuccess(element, '<img alt="" class="available_icon" src="//static.spiceworks.com/assets/community/icons/small/green_checkmark_circle-a95cc75611fbee9698d89e3ae1e41d00.png" />');
            }
          } catch (e) {
            SignupSetup.clearErrors(element);
          }
        }
      });
    }
  },
  checkAndPopulateWebsiteFromEmail: function(emailElement, websiteElementId) {
    var BOGUS_DOMAINS = ["gmail.com", "yahoo.com", "hotmail.com", "mailinator.com", "burnthespam.info", "deadaddress.com", "dispostable.com",
                         "dump-email.info", "e4ward.com", "eyepaste.com", "fakemailgenerator.com",
                         "filzmail.com", "fornow.eu", "guerrillamailblock.com", "mailmoat.com",
                         "mailscrap.com", "meltmail.com", "10minutemail.com", "12minutemail.com",
                         "mytrashmail.com", "nabuma.com", "no-spam.ws", "nowmymail.com", "onewaymail.com",
                         "shitmail.org", "slopsbox.com", "sneakemail.com", "soodonims.com", "spamjackal.net",
                         "spamavert.com", "spambox.us", "spamex.com", "spamgourmet.com", "tempemail.net",
                         "temporaryinbox.com", "yopmail.com", "zoemail.com"];
    var email_regexp = /@(.*)$/;

    var domain = email_regexp.exec(emailElement.value);
    var website_elem = $(websiteElementId);
    if (domain) {
      var email_bogus = BOGUS_DOMAINS.include(domain[1]);
      if (email_bogus) {
        SignupSetup.displayError(emailElement, "Email Address must be for your business domain");
      }
      if (!email_bogus && website_elem.empty()) {
        website_elem.setValue("http://" + domain[1]);
      }
    }
  }
};

var BookContent = {
  loadBook: function(book_name) {
    $$('div.book_choice').each(function(element) {
      element.hide();
    });
    $(book_name + "_left").show();
    $(book_name + "_right").show();
  },
  loadChoice: function(book_name, choice_name) {
    new Effect.Fade('book_pages', {duration:0.2,
      afterFinish:function() {
        $(book_name + "_left").hide();
        $(book_name + "_right").hide();
        $(book_name + "_" + choice_name + "_left").show();
        $(book_name + "_" + choice_name + "_right").show();
        new Effect.Appear('book_pages', {duration: 0.2});
      }
    });
  },
  reloadBook: function(book_name) {
    new Effect.Fade('book_pages', {duration:0.2,
      afterFinish:function() {
        $$('div.book_choice').each(function(element) {
          element.hide();
        });
        $(book_name + "_left").show();
        $(book_name + "_right").show();
        new Effect.Appear('book_pages', {duration: 0.2});
      }
    });
  }
};

var SearchHeader = {
  // used in Google Optimizer
  getJoinUrl: function() {
    var url = "/join";
    var page = window.location.href;
    // this is to remove the community.spiceworks.com part
    if(page && page.length > 0) {
      var start = page.indexOf("spiceworks.com");
      if(start > 0) {
        // 14 is the length of "spiceworks.com", we want the end
        var refer = page.substr(start+14, page.length);
        url = url + "?referer=" + refer;
      }
    }
    return url;
  }
};

// used on product and topic pages
var FeaturedVendorPage = {
  followFeaturedVendor: function(vendor_name, origin_name, origin_type, topBannerFollowLink, followLink, show_hyphen) {
    topBannerFollowLink = topBannerFollowLink || "#top_banner .follow-link";
    followLink = followLink || ".featured_vendor_page .follow-link";
    show_hyphen = (show_hyphen === undefined) ? true : show_hyphen;
    jQuery(topBannerFollowLink).html((show_hyphen ? '- ' : '') + '<em class="highlight">Following...</em>');
    GoogleAnalytics.trackEvent("Vendor Pages", "Follow from " + origin_type, origin_name);
    var count = parseInt(jQuery('#follow_count').attr('data-count'), 10) + 1;
    jQuery.ajax({
      url: "/pages/" + vendor_name + "/add_fan",
      data: {'stm_source': origin_type + '_page', 'stm_medium': 'organic'},
      success: function() {
        if(count == 1) {
          jQuery('#follow_count').html('1 Follower');
        }
        else {
          jQuery('#follow_count').html(count + ' Followers');
        }
        jQuery(followLink + " em").html("Followed!");
        setTimeout('jQuery("' + followLink + '").replaceWith("");', 2000);
      }
    });
  }
};

var Carousel;
Carousel = Class.create({
  initialize: function(dom_id, num_per_page, width) {
    this.currentPage = 0;
    this.container = $(dom_id);
    this.children = this.container.select("li");
    this.lastPage = Math.ceil(this.children.length/num_per_page) - 1;
    this.drawButtons(dom_id);
    this.updateButtons();
    this.width = width;
  },
  drawButtons: function(dom_id) {
    var that = this;
    if(this.currentPage != this.lastPage) {
      this.nextButton = new Element('a', {'id': dom_id + '_next', 'class': 'next_link'});
      this.nextButton.update('<img alt="Next" src="//static.spiceworks.com/assets/controls/light_orange_right-84dad94bd1b379a2d18af6f42de07630.png" />');
      this.nextButton.observe("click", that.nextPage.bindAsEventListener(that));
      this.container.up('div.carousel_wrapper').insert(this.nextButton, {position:'after'});
      this.prevButton = new Element('a', {'id': dom_id + '_previous', 'class':'previous_link'});
      this.prevButton.update('<img alt="Previous" src="//static.spiceworks.com/assets/controls/light_orange_left-28a8d0603b54e2afc52ff0decb2cd5b6.png" />');
      this.prevButton.observe("click", that.prevPage.bindAsEventListener(that));
      this.container.up('div.carousel_wrapper').insert(this.prevButton, {position:'after'});
    }
  },
  updateButtons: function() {
    if(this.nextButton) {
      if(this.currentPage < this.lastPage) {
        this.nextButton.show();
      }
      else {
        this.nextButton.hide();
      }
    }
    if(this.prevButton) {
      if(this.currentPage > 0) {
        this.prevButton.show();
      }
      else {
        this.prevButton.hide();
      }
    }
  },
  scrollTo:function(page) {
    var newLeft = this.width * page;
    new Effect.Morph(this.container, {
      style:{left: -newLeft + 'px'},
      duration: 0.5
    });
    this.currentPage = page;
    this.updateButtons();
  },
  nextPage:function() {
    if(this.currentPage < this.lastPage) {
      this.scrollTo(this.currentPage + 1);
    }
  },
  prevPage:function() {
    if(this.currentPage > 0) {
      this.scrollTo(this.currentPage - 1);
    }
  }
});

var SpiceworksTv = {
  initializeCarousel: function(dom_id) {
    var carousel = new Carousel(dom_id, 4, 715);
    //carousel.width = 695;
  }
};

/* Slideshow with paging
   wrapper_id = id of the containing element
   item_width = width of each item in the slideshow
   random = true if you want to start on a random slide
   Slideshow automatically plays until a page is clicked, then the timer stops.
   Use class="slideshow-container" for the outermost container.
   Use class="slideshow-item" for each item.
   Use class="slideshow-item-wrapper" for the item wrapper.
*/
var PagedSlideshow = Class.create({
  initialize: function(wrapper_id, default_item_width, random) {
    var that = this;
    this.wrapper = jQuery("#" + wrapper_id);

    this.current_index = 0;

    this.max_index = this.wrapper.find(".slideshow-item").length;
    this.item_wrapper = this.wrapper.find(".slideshow-item-wrapper").first();

    this.default_item_width = default_item_width;
    this.original_item_height = parseInt( this.item_wrapper.find('.slideshow-item').first().css('height') );
    this.resize(this);

    if(random) {
      this.current_index = Math.floor(Math.random()*this.max_index);
      this.item_wrapper.css("left", -(this.current_index * this.item_width));
    }

    this.timer = setInterval(function() {that.nextItem();}, 10000);

    jQuery(window).bind( 'orientationchange', function() { that.resize(that); } );

    this.wrapper.bind( 'swipeleft', function()  {
      clearInterval( that.timer );
      if( (that.current_index + 1) < that.max_index ) {
        that.nextItem();
      }
    });
    this.wrapper.bind( 'swiperight', function() {
      clearInterval( that.timer );
      if( that.current_index > 0 ) {
        that.previousItem();
      }
    });
  },
  resize: function(that) {
    that.item_width = that.wrapper.outerWidth();

    that.item_wrapper.css("width", (that.max_index * that.item_width));

    var newHeight = null;
    that.item_wrapper.find('.slideshow-item').each( function(index,item) {
      item = jQuery(item);

      item.css('width', that.item_width + 'px');

      if( that.item_width != that.default_item_width ) {
        if( !newHeight ) {
          newHeight = (that.item_width / that.default_item_width) * that.original_item_height;
        }
        item.css('height', newHeight + 'px' );
      }
    });

    if( newHeight ) {
      that.item_wrapper.css('height', newHeight + 'px' );
      // Make sure to get the wrapper on the item wrapper if there is one
      that.wrapper.find('> *').css('height', newHeight + 'px' );
      that.item_wrapper.find('.slideshow-item').css('height', newHeight + 'px' );
    }

    this.removePager();
    this.buildPager(this.wrapper);
    this.switchTo(0, false); // Jump to the beginning on a resize to prevent artifacts
  },
  removePager: function() {
    this.wrapper.find('.slideshow-pager').remove();
  },
  buildPager: function(wrapper) {
    // only build the pager if there's more than one
    if(this.max_index > 1) {
      var code = '<div class="slideshow-pager"><ul style="width:' + (this.max_index*18)  + 'px;">';
      for(var i = 0; i < this.max_index; ++i) {
        code += '<li data-page="' + i + '"><a href="#">' + i + '</a></li>';
      }
      code += "</ul></div>";
      wrapper.append(code);

      this.pages = wrapper.find(".slideshow-pager li");
      var that = this;
      this.pages.each(function(i, e) {
        e = jQuery(e);
        var page = parseInt(e.attr("data-page"), 10);
        if(page == that.current_index) {
          e.addClass("selected");
        }
        e.find("a").click(function(event) { event.preventDefault(); that.switchTo(page, true); });
      });
    }
  },
  switchTo: function(new_page, clearTimer) {
    // stop timer
    if(clearTimer) {
      clearTimeout(this.timer);
    }

    if(new_page != this.current_index) {
      // switch to the right page
      this.pages.each(function(i, e) {
        e = jQuery(e);
        var page = parseInt(e.attr("data-page"), 10);
        if(page == new_page) {
          e.addClass("selected");
        }
        else {
          e.removeClass("selected");
        }
      });
      this.current_index = new_page;

      // animation
      var that = this;
      if( window.$UI.touchEnabled() ) {
        this.item_wrapper.animate({
          left: -(that.current_index * that.item_width)
        }, 250);
      }
      else {
        this.item_wrapper.fadeOut(500, function() {
          that.item_wrapper
            .css("left", -(that.current_index * that.item_width))
            .fadeIn(500)
            .find('.slideshow-item').eq(that.current_index).trigger("selected.PagedSlideshow");
        });
      }
    }
  },
  nextItem: function() {
    var new_index = (this.current_index + 1) % this.max_index;
    this.switchTo(new_index, false);
  },
  previousItem: function() {
    var new_index = (this.current_index - 1) % this.max_index;
    this.switchTo(new_index, false);
  }
});

var Advisor = {
  show: function(title, width, height, url,_from) {
    $('advisor_overlay').setStyle({'width':(width + 'px')});
    $('advisor_overlay').setStyle({'background':('#666')});
    $('advisor_overlay').down('h2').update(title);

    if (url.match(/^\/app\/frames\/advisor\/printing/)) {
      jQuery('#advisor_overlay').addClass('blue');
    } else {
      jQuery('#advisor_overlay').removeClass('blue');
    }
    var from = _from ? "ViewedFrom"+_from : "ViewedForm";

    _gaq.push(["_trackEvent","AdvisorBranding",from,title]);

    var iframe_code = '<iframe src="' + url + '" width="' + width + '" height="' + height + '" frameborder="0"></iframe>';
    $('advisor_overlay').down('div.content_container').update(iframe_code);
    Flyover.show('advisor_overlay');
  }
};

var TopicAndPostSpice = {
  initialize: function() {
    jQuery('.topic-spicebutton').spicebutton({
      user_can_downspice: UserPermissions.can_downspice,
      status_only: UserPermissions.author,
      status_only_tip: "You can't spice your own stuff!",
      user_can_spice: (CurrentUser.permissionClass != "guest")
    })
      .on('spiced', function(event, spicebutton, direction) {
        if( CurrentUser.permissionClass == "guest" ) {
          JoinAndLogin.showJoin();
        }
        else {
          Ranking.rank( 'Topic', spicebutton.options.spiceable_id, SpicedState.toInt(direction) );
        }
      });

    jQuery('.post .sui-spicebttn').each( function(index, spicebutton_el) {
      var userName = jQuery(spicebutton_el).parents('.post').attr('data-user-name');
      var post_id = parseInt( jQuery(spicebutton_el).attr('data-spiceable-id'), 10 );

      jQuery(spicebutton_el).spicebutton({
        spicedstate: (User.post_ids_with_votes.indexOf(post_id) != -1) ? SpicedState.up : SpicedState.unspiced,
        status_only: Topic.locked || (User.name == userName),
        status_only_tip: Topic.locked ? "Topic locked" : "You can't spice your own stuff!",
        user_can_spice: (CurrentUser.permissionClass != "guest")
      })
        .on('spiced', function(event, spicebutton, direction) {
          if( CurrentUser.permissionClass == "guest" ) {
            JoinAndLogin.showJoin();
          }
          else {
            SPICEWORKS.fire("popup:destroy", { url: "/posts/voters_popup/" + post_id });

            if( SpicedState.toInt(direction) == 1 ) { TopicAndPostSpice.voteUp( post_id );   }
            else                 { TopicAndPostSpice.voteDown( post_id ); }
          }
        })
        .on('count_click', function(event, spicebutton) {
          jQuery.getScript('/posts/all_voters_popup/' + post_id);
        });
    });
  },
  voteUp:function(postID) {
    GoogleAnalytics.trackEvent("Topic", "PostVoteUp");
    jQuery.ajax( '/posts/vote/' + postID );
  },
  voteDown:function(postID) {
    GoogleAnalytics.trackEvent("Topic", "PostVoteDown");
    jQuery.ajax( '/posts/remove_vote/' + postID );
  }
};

var LaunchPopup = {
  initialize:function(){
    var that = this;
    $$('#upgrade_overlay ul.group_list li').each(function(item){
      item.down('input[type=checkbox]').observe('change', that._groupChange);
    });
    $$('#upgrade_overlay ul.vendor_page_list li').each(function(item) {
      item.down('input[type=checkbox]').observe('change', that._pageChange);
    });
    $$('#upgrade_overlay ul.digest_list li').each(function(item) {
      item.down('input[type=radio]').observe('click', that._digestChange);
    });
  },
  _groupChange:function(event){
    var checkbox = event.element('input[type=checkbox]');
    var groupID = checkbox.value;
    var groupName = checkbox.readAttribute('data-name');
    new Ajax.Request('/launch/follow_group_from_popup', {
      parameters:{
        'group_id': groupID,
        'join': checkbox.checked
      },
      onSuccess:function(){
        if(checkbox.checked) {
          $('popup_groups_status').update('Joined group');
          SPICEWORKS.fire('connection:followed', {type: 'group'});
          GoogleAnalytics.trackEvent("ThingsMissed", "Group", groupName);
        }
        else {
          $('popup_groups_status').update('Left group');
          SPICEWORKS.fire('connection:unfollowed', {type: 'group'});
        }
        setTimeout(function() {
          $('popup_groups_status').update();
        }, 3000);
      },
      onFailure:function(){
        $('popup_groups_status').update('Error');
        setTimeout(function() {
          $('popup_groups_status').update();
        }, 3000);
      }
    });
  },
  _pageChange:function(event){
    var checkbox = event.element('input[type=checkbox]');
    var pageID = checkbox.value;
    var pageName = checkbox.readAttribute("data-name");
    new Ajax.Request('/launch/follow_page_from_popup', {
      parameters:{
        'vendor_page_id': pageID,
        'join': checkbox.checked
      },
      onSuccess:function(){
        if(checkbox.checked) {
          $('popup_pages_status').update('Followed vendor');
          SPICEWORKS.fire('connection:followed', {type: 'page'});
          GoogleAnalytics.trackEvent("ThingsMissed", "VendorPage", pageName);
        }
        else {
          $('popup_pages_status').update('Unfollowed vendor');
          SPICEWORKS.fire('connection:unfollowed', {type: 'page'});
        }
        setTimeout(function() {
          $('popup_pages_status').update();
        }, 3000);
      },
      onFailure:function(){
        $('popup_pages_status').update('Error');
        setTimeout(function() {
          $('popup_pages_status').update();
        }, 3000);
      }
    });
  },
  _digestChange:function(event){
    var radio = event.element('input[type=radio]');
    var type = radio.value;
    new Ajax.Request('/launch/subscribe_digest_from_popup', {
      parameters:{
        'type': type
      },
      onSuccess:function(){
        $('popup_digest_status').update(type == "none" ? 'Unsubscribed' : 'Subscribed' );
        GoogleAnalytics.trackEvent("ThingsMissed", "Digest", type);
        setTimeout(function() {
          $('popup_digest_status').update();
        }, 3000);
      },
      onFailure:function(){
        $('popup_digest_status').update('Error');
        setTimeout(function() {
          $('popup_digest_status').update();
        }, 3000);
      }
    });
  },
  dismiss:function(element) {
    Flyover.hide(element);
    new Ajax.Request('/launch/dismiss_overlay');
  }
};

var ShareLink = (function(){
  var init = function(){
    $('post_url').observe('change', checkURL);
    $('post_subject').observe('keyup', checkSubjectLength);
    checkSubjectLength({element: function(){ return $('post_subject'); }});
  };

  var initForPopup = function() {
    if($('post_subject') && $('post_subject').up('.link_input_wrapper')) {
      $('post_subject').observe('keyup', checkSubjectLength);
      checkSubjectLength({element: function(){ return $('post_subject'); }});
    }
  };

  var checkURL = function(ev){
    var input = $('post_url');

    validateURL(input.value);

    setLoading(true);
    request = new Ajax.Request('/info/check_url', {
      requestClass: 'check_url',
      parameters: {href: input.value},
      onSuccess: function(response){
        response = response.responseText.evalJSON();
        var link_status_el = $('link_status');
        if(response.exists){
          link_status_el.update(response.message);
          if(!link_status_el.visible()){
            link_status_el.blindDown({duration: 0.5});
          }
        } else {
          if(response.title && response.title !== ""){
            $("post_subject").value = response.title;
          }
          if(link_status_el.visible()){
            link_status_el.blindUp({duration: 0.5});
          }
        }
        input.removeClassName('error');
        setLinkExists(response.exists);
        setLoading(false);
      }
    });
  };

  var checkSubjectLength = function(ev){
    var el = ev.element();
    el.up('.link_input_wrapper').down('.character_counter').innerHTML = (80 - el.value.length);
  };

  var validateURL = function(value){
    var checkUnique = $("link_exists"),
        unique = !checkUnique ? true : checkUnique.value == 'false';
    return value !== "" && value != "http://" && unique;
  };

  var checkForm = function(){
    var input = $('post_url'),
        valid = validateURL(input.value);
    input[valid ? 'removeClassName' : 'addClassName']('error');
    return valid;
  };

  var setLinkExists = function(value){
    $("link_exists").value = value;
  };

  var setLoading = function(loading){
    $("checking_link_busy")[loading ? 'show' : 'hide']();
  };

  return {
    init: init,
    initForPopup: initForPopup,
    setLinkExists: setLinkExists,
    checkForm: checkForm,
    validateURL: validateURL
  };

})();

(function(){
  var formatPrice = function(price) { return ("$" + parseFloat(price).toFixed(2));};
  var isOem = function(variant) { return variant.options.select(function(o) { return (o.name=="Product Type" && o.value == "OEM"); }).length > 0; };
  var withHeader = function(header, content) {
    var t = new Element('div');
    if (content) {
      t.insert(new Element('h3').update(header));
      t.insert(content);
    }
    return t.innerHTML;
  };
  var readAttr = function(product, attr) {
    var match = product.properties.detect(function(o) { if (o.name == attr) { return true; }});

    if (match) { return match.value; }
    else { return ""; }
  };

  SPICEWORKS.observe("product:ready", function(event) {
    var memo = event.memo;

    SPICEWORKS.products.catalog.find({'mfg':memo.manufacturer, 'model': memo.model}, function(response){
      if (response && response.length > 0) {
        var suppliesTab, suppliesContent, supplies, price,
            area = $('product_description'),
            activeTab = area.down("li.active"),
            content = area.down('.content'),
            supplyArea,
            variants = {},
            activeContent = content.innerHTML;

        activeTab.insert({before: "<li class='active'><a id='product_supplies' href='#'>Supplies</a>"});
        suppliesTab = activeTab.previous();

        var buildList = function(criteria) {
          var li, matchedProducts, update, matchedCriteria = false;
          suppliesContent = new Element('ul');

          response.each(function(product) {
            if (!product) { return; }
            matchedProducts = product.variants.select(function(v) { return criteria(v); });
            if (matchedProducts.length > 0) { matchedCriteria = true; }
            matchedProducts = matchedProducts.sortBy(function(v) { return parseFloat(v.price); });

            var variant = matchedProducts.first();
            if (variant) {

              var temp = "<div class='buy'>" +
                          "<p><strong>" + product.name + "</strong>" +
                          "<button class='sui-bright-btn orange small'>Add To Cart</button>" +
                          "<span class='price'>" + formatPrice(variant.price) + "</span></p>" +
                          "<p>" + readAttr(product, "Yield") + "</p></div>";

              li = new Element('li').update( temp );
              li.setAttribute('data-variants', (variants.length > 1 ? 'yes' : 'no'));
              li.setAttribute('data-product-id', product.id);
              li.setAttribute('data-variant-id', variant.id);
              li.setAttribute('data-type', isOem(variant) ? "oem" : "compatible");
              li.setAttribute('data-color', readAttr(product, 'Color'));

              temp = "<div class='update'>" +
                          "<p><strong>" + product.name + "</strong>" +
                          "<span class='added'><span class='msg'>Added To Cart. </span><a href='http://shop.spiceworks.com/cart'>Checkout</a></span></p>" +
                          "<p>" +
                          "<span class='vendor'>Vendor:</span>" +
                          "<span class='qty'>Qty:</span>" +
                          "<button class='sui-bright-btn secondary small'>Update</button>" +
                          "</p></div>";

              li.insert(temp);
              update = li.down('div.update');

              var qty = SPICEWORKS.ui.createSelect($R(1,10).collect(function(n) { return {label:n, value:n}; }));
              qty.addClassName('qty');

              if (matchedProducts.length > 1) {
                var vendorChoices = SPICEWORKS.ui.createSelect(matchedProducts.collect(function(v) {
                  return {label: (v.vendor + " - " + formatPrice(v.price)), value: v.id};
                }));
                vendorChoices.addClassName('vendor');

                update.down('.vendor').insert(vendorChoices);
              }
              else {
                update.down('.vendor').insert(" " + variant.vendor);
              }

              update.down('.qty').insert(qty);
              suppliesContent.insert(li);
              variants[variant.id] = matchedProducts;
            }
          });

          return (matchedCriteria ? suppliesContent : false);
        };

        var showSuppliesTab = function(event) {
          if (event) { event.stop(); }

          suppliesTab.addClassName('active');
          activeTab.removeClassName('active');

          var supplyArea = $('supplies_area');
          if (supplyArea) {
            supplyArea.show();
            content.hide();
          } else {
            supplies = new Element('div', {'class':'printer-supplies'});
            supplies.insert(withHeader("OEM", buildList(isOem)));
            supplies.insert(withHeader("Compatible/Remanufactured", buildList(function(v) { return !isOem(v); })));

            supplyArea = new Element('div', {'class': 'content nopadding', 'id': 'supplies_area'});
            supplyArea.insert(supplies);
            content.insert({after:supplyArea});
            content.hide();
            supplyArea.show();
          }
        };

        var showLoadedTab = function(event) {
          if (event) { event.stop(); }

          // content.innerHTML = activeContent;
          activeTab.addClassName('active');
          suppliesTab.removeClassName('active');

          content.show();
          supplyArea.hide();

          // content.removeClassName('nopadding');
        };

        var handleClick = function(e) {
          var variant, product, qty, status,
              el = e.element();
          if (el && el.tagName == "BUTTON") {
            li = el.up('li');

            if (el.up('.buy')) {
              li.addClassName('added');
              SPICEWORKS.products.cart.add(li.getAttribute('data-variant-id'), 1);
            }
            else if (el.up('.update')) {
              oldVariant = li.getAttribute('data-variant-id');

              if (li.down('select.vendor')) {
                newVariant = $F(li.down('select.vendor'));
              }
              else {
                newVariant = oldVariant;
              }

              q = $F(li.down('select.qty'));

              li.setAttribute('data-variant-id', newVariant);

              if (oldVariant != newVariant) {
                SPICEWORKS.products.cart.remove(oldVariant);
                SPICEWORKS.products.cart.add(newVariant, q);
              }
              else {
                SPICEWORKS.products.cart.update(newVariant, q);
              }

              li.down('span.added .msg').update("Updated Cart.");
              li.down('span.added').highlight();

              SPICEWORKS.fire("cart:refresh");
            }
            e.stop();
          }
        };

        activeTab.observe('click', showLoadedTab);
        suppliesTab.observe('click', showSuppliesTab);
        showSuppliesTab();
        supplyArea.observe('click', handleClick);
      }
    });

  });

  function updateCart() {
    SPICEWORKS.products.cart.get(function(response){
      var gocart = $("cart_status"), total;

      if (response && response.cart && response.cart.line_items.length > 0) {
        if (!gocart) {
          gocart = new Element('div', {'id': 'cart_status', 'class':'cart'});
          $("adbox").insert({top: gocart});
        }
        total = 0;
        response.cart.line_items.each(function(l) { total = total + l.quantity; });

        gocart.update(new Element('span', {'class':'count'}).update(total == 1 ? "1 Item" : (total + " Items")));
        gocart.insert(new Element('a', {'class': 'sui-bright-btn orange medium', 'href':"http://shop.spiceworks.com/cart"}).update("Checkout"));
        gocart.insert(new Element('span', {'class':'total'}).update(formatPrice(response.cart.item_total)));
      }
    });
  }

  SPICEWORKS.observe("cart:refresh", updateCart);
})();

var BCG = {
  load: function (container, bcg_product, _from, tagging) {
    var from = _from ? "ViewedFrom"+_from : "ViewedForm";
    GoogleAnalytics.trackEvent("BusinessCase", from, bcg_product);
    jQuery("#business_case_container").addClass(bcg_product.replace("_","-"));
    bcg_url = "/business_cases/" + bcg_product + "/new?from=" + _from;
    if(!Browser.hasStylesheet("assets/bcg.css")){
      jQuery('head').append('<link rel="stylesheet" href="http://static.spiceworks.com/assets/bcg.css" type="text/css" />');
    }
    jQuery("#" + container).html("<p>Loading Business Case Generator...</p>");
    new Ajax.Updater(container, bcg_url, {asynchronous:true, evalScripts:true});
    if(tagging){
      var product_page = (_from == "ProductPageTab")
      BCG.addTagger(bcg_product, product_page);
    }
  },
  addTagger: function(bcg_product, product_page) {
    if(!Browser.hasStylesheet("assets/3rd_party/jquery-ui/jquery-ui-aristo.css")){
      jQuery('<link>', { rel: 'stylesheet', type: 'text/css',
        href: 'http://static.spiceworks.com/assets/3rd_party/jquery-ui/jquery-ui-aristo.css'
      }).appendTo('head');
    }
    var prodPgParam = product_page ? "?prodp=true" : "";
    var tag_url = "/business_cases/"+bcg_product+"/tags/"+prodPgParam;
    jQuery.post(tag_url, function(data) {
      jQuery('#tagging_for_bcg').html(data);
    });
  },
  initializeLinkedIn : function(_postTitle, _postBody, _url){
    BCG.linkedIn = {postTitle: _postTitle, postBody: _postBody, url: _url};
    var newWidth = window.outerWidth < 650 ? 650 : window.outerWidth;
    var newHeight = window.outerHeight < 400 ? 400 : window.outerHeight;
    window.resizeTo(newWidth, newHeight);
    BCG.updateLinkedIn();
    jQuery("#title").click(function(){
      BCG.editLinkedInTitle();
    });
    jQuery("#body").click(function(){
      BCG.editLinkedInBody();
    });
    jQuery("#title-input, #body-input").blur(function(){
      BCG.finishLinkedInEdit();
    });
  },
  updateLinkedIn : function(){
    jQuery("#title").text(BCG.linkedIn.postTitle);
    jQuery("#title-input").val(BCG.linkedIn.postTitle)
    jQuery("#body, #body-input").text(BCG.linkedIn.postBody);
  },
  editLinkedInTitle : function(){
    jQuery("#title").hide();
    jQuery("#title-input").show().focus();
  },
  editLinkedInBody : function(){
    jQuery("#body").hide();
    jQuery("#body-input").show().focus();
  },
  finishLinkedInEdit : function(){
    jQuery("#title-input, #body-input").hide();
    BCG.linkedIn.postTitle = jQuery("#title-input").val();
    BCG.linkedIn.postBody = jQuery("#body-input").val();
    BCG.updateLinkedIn();
    jQuery("#title, #body").show();
  },
  showLinkedInError : function(errorMsg) {
    var errorText = ( errorMsg ? "<br> Error message: "+errorMsg : "" );
    jQuery('#message').html("Oops, something went wrong! Want to try again?" + errorText).stop(true, true).slideDown('fast').addClass('active');
    jQuery('#share-btn').text("Try again")
    jQuery('#share_dialog').loadmask('hide');
  },
  shareLinkedIn: function(shareUrl){
    jQuery('#share_dialog').loadmask('show');
    jQuery.post(shareUrl, {title: BCG.linkedIn.postTitle, body: BCG.linkedIn.postBody})
      .done(function(data) {
        console.warn("Response data: %o", data);
        if (data.errorCode || data.errorCode === 0){
          BCG.showLinkedInError(data.message);
        } else {
          jQuery('#hideable').slideUp('fast');
          jQuery('#message').text("Successfully shared your post.").removeClass('message-panel-error').addClass('message-panel-info').stop(true, true).slideDown('fast');
          jQuery('#share_dialog .footer-actions a').hide();
          jQuery('#share_dialog .footer-actions').append("<a class='sui-bttn sui-bttn-primary' href="+data.updateUrl+">Show me my post</a><a class='sui-bttn' href='#' onclick='window.close(); return false;'>Close this window</a></li>");
          jQuery('#share_dialog').loadmask('hide');
        }
      }).fail(function(data) {
        BCG.showLinkedInError();
      });
  }
};

var ShowcasedItem = {
  findItem: function() {
    var status_container = jQuery("#item_status");
    status_container.html('<img alt="Ajax_busy" src="//static.spiceworks.com/assets/icons/ajax_busy-96d19e6b2f93905af43fffd61eca79c4.gif" />');
    var type = jQuery("#showcased_item_showcaseable_type").val();
    var id = jQuery("#showcased_item_showcaseable_id").val();
    jQuery.ajax({
      url: "/showcased_items/find_item",
      data: {"item_type": type, "item_id": id},
      statusCode: {
        404: function() {
          jQuery("#item_status").html('<em class="highlight">Not found</em>');
        },
        403: function() {
          jQuery("#item_status").html('<em class="highlight">Is not public</em>');
        },
        500: function() {
          jQuery("#item_status").html('<em class="highlight">Error: something went wrong!</em>');
        }
      },
      success: function(data) {
        jQuery("#item_status").html("");
        jQuery("#showcased_item_name").val(data.substring(0, 55));
      }
    });
  },
  clearCache: function() {
    jQuery("#showcased_items_status").html("Clearing...");
    jQuery.ajax({
      url: "/showcased_items/clear_cache",
      success: function() {
        jQuery("#showcased_items_status").html("Cache is cleared");
        setTimeout(function() {jQuery("#showcased_items_status").html("");}, 3000);
      },
      error: function() {
        jQuery("#showcased_items_status").html("Error: could not clear cache");
      }
    });
  },
  attachLinks: function() {
    var items = jQuery("#homepage_showcase .slideshow-item");
    items.each(function(index, element) {
      element = jQuery(element);
      var link = element.find(".showcase-title a").attr("href");
      element.click(function() { document.location = link; });
    });
  }
};

/* Counter that takes both a min and max.
   If you have no min, just use zero.
   The name is the id of the textarea.
   Use the same name for the counter. (foobar_counter if the textarea is foobar).
*/
var CharacterCount = {
  init: function(name, min, max) {
    this.min = min;
    this.max = max;
    this.counter = jQuery("#" + name + "_counter");
    this.textarea = jQuery("#" + name);
    this.count = 0;
    CharacterCount.updateCount();
    this.textarea.keyup(function() {CharacterCount.updateCount();});
  },
  updateCount: function() {
    this.count = this.textarea.val().length;
    this.counter.html(this.count + "/" + this.max);
    if((this.count < this.min) || (this.count > this.max)) {
      this.counter.addClass("error");
    }
    else {
      this.counter.removeClass("error");
    }
  }
};

var AdminEvent = {
  selectAll: function() {
    jQuery("input[type=checkbox]").each(function(i, e) {
      e.checked = true;
    });
  },
  selectNone: function() {
    jQuery("input[type=checkbox]").each(function(i, e) {
      e.checked = false;
    });
  },
  approve: function() {
    var ids = [];
    var status_icon = jQuery("#admin_event_status");
    status_icon.show();
    jQuery("input[type=checkbox]").each(function(i, e) {
      if(e.checked) {
        ids.push(e.value);
      }
    });
    if(ids.length > 0) {
      jQuery.ajax({
        data: {event_ids: ids},
        url: "/admin_event/approve",
        complete: function(data) {
          AdminEvent.updateMod(ids, data.responseText);
          status_icon.hide();
          AdminEvent.selectNone();
        }
      });
    }
    else {
      status_icon.hide();
    }
  },
  unapprove: function() {
    var ids = [];
    var status_icon = jQuery("#admin_event_status");
    status_icon.show();
    jQuery("input[type=checkbox]").each(function(i, e) {
      if(e.checked) {
        ids.push(e.value);
      }
    });
    if(ids.length > 0) {
      jQuery.ajax({
        data: {event_ids: ids},
        url: "/admin_event/unapprove",
        complete: function() {
          AdminEvent.clearMod(ids);
          status_icon.hide();
          AdminEvent.selectNone();
        }
      });
    }
    else {
      status_icon.hide();
    }
  },
  updateMod: function(ids, name) {
    var link = '<a href="/profile/show/' + name + '">' + name.replace("(Spiceworks)", "") + '</a>';
    for(var i = 0; i < ids.length; ++i) {
      jQuery("#spice_admin_event_" + ids[i] + " .mod").html(link);
    }
  },
  clearMod: function(ids) {
    for(var i = 0; i < ids.length; ++i) {
      jQuery("#spice_admin_event_" + ids[i] + " .mod").html("");
    }
  }
};

var HelpDoc = {
  initFeedback: function() {
    if(window.location.hash && window.location.hash.length > 0) {
      var section = window.location.hash.gsub("#", "");
      jQuery("#help_feedback_content").attr("data-section", section);
    }
    jQuery("#help_feedback").delay(5000).fadeIn(500);
  },
  toggleOptions: function() {
    jQuery("#help_feedback .no-options-list").toggle();
    jQuery("#help_feedback .up-arrow").toggle();
    jQuery("#help_feedback .down-arrow").toggle();
  },
  sendResponse: function(response, page_id) {
    var url = "/help_feedbacks/respond_" + response;
    jQuery.ajax({
      url: url,
      type: "POST",
      data: {
        page_id: page_id,
        section: jQuery("#help_feedback_content").attr("data-section")
      }
    });
  },
  sendOption: function(id, reason) {
    if(reason == "Other" && jQuery("input#notes").val().length == 0) {
      jQuery("#other-option-error").html("Please fill in a reason.");
    }
    else {
      if(reason == "Other") {
        reason = reason + " - " + jQuery("input#notes").val();
      }
      jQuery.ajax({
        type: "POST", 
        url: "/help_feedbacks/" + id + "/add_reason",
        data: {
          notes: reason
        },
        complete: function() {
          jQuery("#feedback_optional_message").html("Thanks for your feedback!");
        }
      });
    }
  }
}

!function($) {
  $(document)
    .on("spiced.spicebutton.sui", '.votable[data-toggle="spicebttn"]', function(event, btn) {
      var httpMethod =  btn.options.spicedstate == SpicedState.unspiced ? "DELETE" : "POST",
          url = ["/votes", btn.options.spiceable_class, btn.options.spiceable_id].join('/');
      $.ajax(url, {type: httpMethod, data: btn.options});
    })
    .on("count_click.spicebutton.sui", '.votable[data-toggle="spicebttn"]', function(event, btn) {
      var url = ["/votes", btn.options.spiceable_class, btn.options.spiceable_id].join('/');
      $.get(url, function(data) { $(data).modal(); });
    });
}(jQuery);

!function ($) {
  "use strict";

  $.fn.highlightTerms = function (terms) {
    return this.each( function () {
      var self = $(this);

      $.each(terms, function(i,term) {
        $(self).html( function(i,val) {
          var regex = new RegExp( term, 'ig' );
          return val.replace( regex, function(match) { return '<span style="background-color:yellow;">' + match + '</span>'; } );
        });
      });
    });
  };

}( window.jQuery );

!function($) {
  $(document).on("bootstrap", function() {
    $('[data-toggle="followbttn"]').each(function() {
      var $this = $(this),
          klass = $this.data("followableClass"),
          id = $this.data("followableId");
      if(User.following && _(User.following[klass]).contains(id)) {
        $this.data("followbutton").setOptions({following: true});
      }
    });
  });
}(jQuery);

var Optimizely = {
  activateExperiments: function() {
    window.optimizely = window.optimizely || [];
    window.optimizely.push(["activate"]);
  }
};

/* Fix for SUI timestamp plugin with Prototype AJAX calls */
/* Don't want Prototype code in SUI */
document.observe('ajax:completed', function() { jQuery('[data-js-postprocess="timestamp"]').timestamp(); } );

/*
 * Word counter for use with text boxes
 * Options:
 *  - container: the container to display the word count in
 *  - submit: (optional) button to enable/disable
 *  - words: the target number of words
 */
!function($) {
  "use strict"

  var WordCounter = function(element, options) {
    var field = $(element);
    var container = $(options.container);
    var submit = $(options.submit);

    // prime the field by display the number of words needed
    var initial = options.words + ' word minimum.';
    container.text(initial);
    field.on('keyup.wordCounter keydown.wordCounter', function(event) {
      var text = $(field).val();
      var wordcount = text.split(/\w+/).length;
      var delta = options.words - wordcount + 1;
      if(delta === options.words) {
        // reset the initial text since the field is empty
        container.text(initial);
        submit.attr('disabled', 'disabled');
      } else if(delta <= 0) {
        // the user has entered enough words, stop bothering them
        container.text('');
        submit.removeAttr('disabled');
      } else {
        // display the remaining word count, disable the submit button
        submit.attr('disabled', 'disabled');
        container.text(delta + ' words to go.');
      }
    });
  }

  $.fn.wordCounter = function(option) {
    return this.each(function() {
      var $this = $(this)
        , data = $this.data('wordCounter')
        , options = typeof option === 'object' && option
      if(!data) $this.data('wordCounter', (data = new WordCounter(this, options)));
    });
  }
}(window.jQuery);
var Popup = (function($){
  var popups = {};

  var findPopup = function(url){
    return popups[url];
  };

  var addPopup = function(url, popup){
    popups[url] = popup;
    return popup;
  };

  SPICEWORKS.ready(function(event){
    if( !$UI.mobileView() ) {
      $(document.body).delegate('[data-popup-url]', 'mouseover', function(event){
        SPICEWORKS.fire("popup:mouseover", {el: $(this)});
      });

      $(document.body).delegate('[fancy-title]', 'mouseover', function(event){
        SPICEWORKS.fire("popup:mouseover", {el: $(this), 'fancy-title': true});
      });
    }
  });

  SPICEWORKS.observe('popup:destroy', function(evt){
    popup = findPopup(evt.memo.url);
    if (popup !== undefined) {
      popup.destroy();
      delete popups[evt.memo.url];
    }
  });

  SPICEWORKS.observe('popup:mouseover',function(event){
    var activator = event.memo.el,
        id = event.memo['fancy-title'] ? activator.attr('fancy-title') : activator.attr('data-popup-url'),
        popup = findPopup(id);

    if (popup && popup.activator !== p$(activator)) {
      popup.setActivator(p$(activator));
      popup.activatorOver();
    } else if (!popup) {
      if (event.memo['fancy-title']) {
        createFancyTitle(activator, id);
      } else {
        createPopup(activator, id);
      }
    } else {
      popup.hidden = false;
    }
  });

  SPICEWORKS.observe('popup:hide',function(event){
    var activator = event.memo.el,
        id = event.memo['fancy-title'] ? activator.attr('fancy-title') : activator.attr('data-popup-url'),
        popup = findPopup(id);
    if (popup) {
      popup.hideMenu();
    }
  });

  var createPopup = function(activator, url){
    if(!activator || !url) { return; }
    var loaded = false,
        fetching = false,
        alignToActivator = activator.attr('data-align-to-activator'),
        offsetLeft,
        offsetTop;

    var update = function(){
      if(!loaded && !fetching) {
        fetch.call(this);
      }
    };

    var fetch = function(){
      fetching = true;
      popup = this;
      $.ajax({
        url: url,
        success: function(data){
          popup.setMenu(p$($(data)));

          fetching = false;
          loaded = true;
          if(!popup.hidden) { popup.showMenu(); }
          $('a.sui-followbttn, a.sui-followlink').followbutton();
        },
        onFailure: function(){
          fetching = false;
        }
      });
    };

    var afterHide = function(){
      var popup = findPopup(url);
      popup.hidden = true;
    };

    var alignRight = function(){
      return findPopup(url).activator.getWidth();
    };

    var alignTop = function(){
      return -findPopup(url).activator.getHeight();
    };

    // setup offsets
    if (alignToActivator == 'right') {
      offsetLeft = alignRight;
      offsetTop = alignTop;
    } else {
      offsetTop = 0;
      offsetLeft = 0;
    }

    var popup = new SPICEWORKS.ui.SimpleMenu(p$(activator), p$($('<div class="popup_overlay"></div>')), {
      alignment: activator.attr('data-align') || 'left',
      activateDelay: 500,
      update: update,
      offsetLeft: offsetLeft,
      offsetTop: offsetTop,
      alignToActivator: alignToActivator || 'bottom',
      afterHide: afterHide,
      autoAdjustable: true,
      absolutize: true,
      id: url
    });
    addPopup(url, popup).activatorOver();
  };

  var createFancyTitle = function(activator, title){
    if(!activator || !title) { return; }

    var popup_el = $('<span class="dark_hover_wrap popup"><span class="dark_hover popup">'+title+'</span></span>');

    var popup = new SPICEWORKS.ui.SimpleMenu(p$(activator), p$(popup_el), {
      alignment: activator.attr('data-align') || 'center',
      alignToActivator: activator.attr('data-align-to-activator') || 'top',
      activateDelay: 0,
      deactivateDelay: 0,
      absolutize: true,
      id: title
    });
    addPopup(title, popup).activatorOver();
  };

  return;
})(jQuery);

document.observe("dom:loaded", function() {
  $$("#navigation ul.top-level > li.has-menu").each(function(container) {
      var link = container.down('a');
      var menu = container.down('div.menu');
      if (link && container) {
          new SUI.SimpleMenu(link, menu, {
              alignment:'left',
              offsetLeft:0,
              offsetTop:0,
              activateDelay: 50,
              deactivateDelay: 300
          });
      }
  });

  SPICEWORKS.app.navigation.addSubMenu($("menu-option-channels"), {
    onLoad: function(self) {
      var request = new Ajax.Request("/api/groups/channels.json", {
        method: "get",
        requestClass: "menu-option-channels",
        parameters: {filter: "front_page"},
        onSuccess: function(response) {
          var channels = response.responseText.evalJSON();
          var links = channels.collect(function(channel) {
            return new Element('a', {href: channel.url}).update(channel.name);
          });
          self.buildMenu(links);
        }
      });
    }
  });
  SPICEWORKS.app.navigation.addSubMenu($("menu-option-my_groups"), {
    onLoad: function(self) {
      var request = new Ajax.Request("/api/groups/my_groups.json", {
        method: "get",
        requestClass: "menu-option-my_groups",
        parameters: {filter: "front_page"},
        onSuccess: function(response) {
          var groups = response.responseText.evalJSON();
          var links = groups.collect(function(group) {
            return new Element('a', {href: group.url}).update(group.name);
          });
          self.buildMenu(links);
        }
      });
    }
  });
});
/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/


(function(){if(window.CKEDITOR&&window.CKEDITOR.dom)return;if(!window.CKEDITOR)window.CKEDITOR=(function(){var a={timestamp:'C9A85WF',version:'3.6.5',revision:'7647',rnd:Math.floor(Math.random()*900)+100,_:{},status:'unloaded',basePath:(function(){var d=window.CKEDITOR_BASEPATH||'';if(!d){var e=document.getElementsByTagName('script');for(var f=0;f<e.length;f++){var g=e[f].src.match(/(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/i);if(g){d=g[1];break;}}}if(d.indexOf(':/')==-1)if(d.indexOf('/')===0)d=location.href.match(/^.*?:\/\/[^\/]*/)[0]+d;else d=location.href.match(/^[^\?]*\/(?:)/)[0]+d;if(!d)throw 'The CKEditor installation path could not be automatically detected. Please set the global variable "CKEDITOR_BASEPATH" before creating editor instances.';return d;})(),getUrl:function(d){if(d.indexOf(':/')==-1&&d.indexOf('/')!==0)d=this.basePath+d;if(this.timestamp&&d.charAt(d.length-1)!='/'&&!/[&?]t=/.test(d))d+=(d.indexOf('?')>=0?'&':'?')+'t='+this.timestamp;return d;}},b=window.CKEDITOR_GETURL;if(b){var c=a.getUrl;a.getUrl=function(d){return b.call(a,d)||c.call(a,d);};}return a;})();var a=CKEDITOR;if(!a.event){a.event=function(){};a.event.implementOn=function(b){var c=a.event.prototype;for(var d in c){if(b[d]==undefined)b[d]=c[d];}};a.event.prototype=(function(){var b=function(d){var e=d.getPrivate&&d.getPrivate()||d._||(d._={});return e.events||(e.events={});},c=function(d){this.name=d;this.listeners=[];};c.prototype={getListenerIndex:function(d){for(var e=0,f=this.listeners;e<f.length;e++){if(f[e].fn==d)return e;}return-1;}};return{on:function(d,e,f,g,h){var i=b(this),j=i[d]||(i[d]=new c(d));if(j.getListenerIndex(e)<0){var k=j.listeners;if(!f)f=this;if(isNaN(h))h=10;var l=this,m=function(o,p,q,r){var s={name:d,sender:this,editor:o,data:p,listenerData:g,stop:q,cancel:r,removeListener:function(){l.removeListener(d,e);}};e.call(f,s);return s.data;};m.fn=e;m.priority=h;for(var n=k.length-1;n>=0;n--){if(k[n].priority<=h){k.splice(n+1,0,m);return;}}k.unshift(m);}},fire:(function(){var d=false,e=function(){d=true;},f=false,g=function(){f=true;};return function(h,i,j){var k=b(this)[h],l=d,m=f;d=f=false;if(k){var n=k.listeners;if(n.length){n=n.slice(0);for(var o=0;o<n.length;o++){var p=n[o].call(this,j,i,e,g);if(typeof p!='undefined')i=p;if(d||f)break;}}}var q=f||(typeof i=='undefined'?false:i);d=l;f=m;return q;};})(),fireOnce:function(d,e,f){var g=this.fire(d,e,f);delete b(this)[d];return g;},removeListener:function(d,e){var f=b(this)[d];if(f){var g=f.getListenerIndex(e);
if(g>=0)f.listeners.splice(g,1);}},hasListeners:function(d){var e=b(this)[d];return e&&e.listeners.length>0;}};})();}if(!a.editor){a.ELEMENT_MODE_NONE=0;a.ELEMENT_MODE_REPLACE=1;a.ELEMENT_MODE_APPENDTO=2;a.editor=function(b,c,d,e){var f=this;f._={instanceConfig:b,element:c,data:e};f.elementMode=d||0;a.event.call(f);f._init();};a.editor.replace=function(b,c){var d=b;if(typeof d!='object'){d=document.getElementById(b);if(d&&d.tagName.toLowerCase() in {style:1,script:1,base:1,link:1,meta:1,title:1})d=null;if(!d){var e=0,f=document.getElementsByName(b);while((d=f[e++])&&d.tagName.toLowerCase()!='textarea'){}}if(!d)throw '[CKEDITOR.editor.replace] The element with id or name "'+b+'" was not found.';}d.style.visibility='hidden';return new a.editor(c,d,1);};a.editor.appendTo=function(b,c,d){var e=b;if(typeof e!='object'){e=document.getElementById(b);if(!e)throw '[CKEDITOR.editor.appendTo] The element with id "'+b+'" was not found.';}return new a.editor(c,e,2,d);};a.editor.prototype={_init:function(){var b=a.editor._pending||(a.editor._pending=[]);b.push(this);},fire:function(b,c){return a.event.prototype.fire.call(this,b,c,this);},fireOnce:function(b,c){return a.event.prototype.fireOnce.call(this,b,c,this);}};a.event.implementOn(a.editor.prototype,true);}if(!a.env)a.env=(function(){var b=navigator.userAgent.toLowerCase(),c=window.opera,d={ie:/*@cc_on!@*/false,opera:!!c&&c.version,webkit:b.indexOf(' applewebkit/')>-1,air:b.indexOf(' adobeair/')>-1,mac:b.indexOf('macintosh')>-1,quirks:document.compatMode=='BackCompat',mobile:b.indexOf('mobile')>-1,iOS:/(ipad|iphone|ipod)/.test(b),isCustomDomain:function(){if(!this.ie)return false;var g=document.domain,h=window.location.hostname;return g!=h&&g!='['+h+']';},secure:location.protocol=='https:'};d.gecko=navigator.product=='Gecko'&&!d.webkit&&!d.opera;var e=0;if(d.ie){e=parseFloat(b.match(/msie (\d+)/)[1]);d.ie8=!!document.documentMode;d.ie8Compat=document.documentMode==8;d.ie9Compat=document.documentMode==9;d.ie7Compat=e==7&&!document.documentMode||document.documentMode==7;d.ie6Compat=e<7||d.quirks;}if(d.gecko){var f=b.match(/rv:([\d\.]+)/);if(f){f=f[1].split('.');e=f[0]*10000+(f[1]||0)*100+ +(f[2]||0);}}if(d.opera)e=parseFloat(c.version());if(d.air)e=parseFloat(b.match(/ adobeair\/(\d+)/)[1]);if(d.webkit)e=parseFloat(b.match(/ applewebkit\/(\d+)/)[1]);d.version=e;d.isCompatible=d.iOS&&e>=534||!d.mobile&&(d.ie&&e>=6||d.gecko&&e>=10801||d.opera&&e>=9.5||d.air&&e>=1||d.webkit&&e>=522||false);d.cssClass='cke_browser_'+(d.ie?'ie':d.gecko?'gecko':d.opera?'opera':d.webkit?'webkit':'unknown');
if(d.quirks)d.cssClass+=' cke_browser_quirks';if(d.ie){d.cssClass+=' cke_browser_ie'+(d.version<7?'6':d.version>=8?document.documentMode:'7');if(d.quirks)d.cssClass+=' cke_browser_iequirks';}if(d.gecko&&e<10900)d.cssClass+=' cke_browser_gecko18';if(d.air)d.cssClass+=' cke_browser_air';return d;})();var b=a.env;var c=b.ie;if(a.status=='unloaded')(function(){a.event.implementOn(a);a.loadFullCore=function(){if(a.status!='basic_ready'){a.loadFullCore._load=1;return;}delete a.loadFullCore;var e=document.createElement('script');e.type='text/javascript';e.src=a.basePath+'ckeditor.js';document.getElementsByTagName('head')[0].appendChild(e);};a.loadFullCoreTimeout=0;a.replaceClass='ckeditor';a.replaceByClassEnabled=1;var d=function(e,f,g,h){if(b.isCompatible){if(a.loadFullCore)a.loadFullCore();var i=g(e,f,h);a.add(i);return i;}return null;};a.replace=function(e,f){return d(e,f,a.editor.replace);};a.appendTo=function(e,f,g){return d(e,f,a.editor.appendTo,g);};a.add=function(e){var f=this._.pending||(this._.pending=[]);f.push(e);};a.replaceAll=function(){var e=document.getElementsByTagName('textarea');for(var f=0;f<e.length;f++){var g=null,h=e[f];if(!h.name&&!h.id)continue;if(typeof arguments[0]=='string'){var i=new RegExp('(?:^|\\s)'+arguments[0]+'(?:$|\\s)');if(!i.test(h.className))continue;}else if(typeof arguments[0]=='function'){g={};if(arguments[0](h,g)===false)continue;}this.replace(h,g);}};(function(){var e=function(){var f=a.loadFullCore,g=a.loadFullCoreTimeout;if(a.replaceByClassEnabled)a.replaceAll(a.replaceClass);a.status='basic_ready';if(f&&f._load)f();else if(g)setTimeout(function(){if(a.loadFullCore)a.loadFullCore();},g*1000);};if(window.addEventListener)window.addEventListener('load',e,false);else if(window.attachEvent)window.attachEvent('onload',e);})();a.status='basic_loaded';})();a.dom={};var d=a.dom;(function(){var e=[];a.on('reset',function(){e=[];});a.tools={arrayCompare:function(f,g){if(!f&&!g)return true;if(!f||!g||f.length!=g.length)return false;for(var h=0;h<f.length;h++){if(f[h]!=g[h])return false;}return true;},clone:function(f){var g;if(f&&f instanceof Array){g=[];for(var h=0;h<f.length;h++)g[h]=this.clone(f[h]);return g;}if(f===null||typeof f!='object'||f instanceof String||f instanceof Number||f instanceof Boolean||f instanceof Date||f instanceof RegExp)return f;g=new f.constructor();for(var i in f){var j=f[i];g[i]=this.clone(j);}return g;},capitalize:function(f){return f.charAt(0).toUpperCase()+f.substring(1).toLowerCase();},extend:function(f){var g=arguments.length,h,i;
if(typeof (h=arguments[g-1])=='boolean')g--;else if(typeof (h=arguments[g-2])=='boolean'){i=arguments[g-1];g-=2;}for(var j=1;j<g;j++){var k=arguments[j];for(var l in k){if(h===true||f[l]==undefined)if(!i||l in i)f[l]=k[l];}}return f;},prototypedCopy:function(f){var g=function(){};g.prototype=f;return new g();},isArray:function(f){return!!f&&f instanceof Array;},isEmpty:function(f){for(var g in f){if(f.hasOwnProperty(g))return false;}return true;},cssStyleToDomStyle:(function(){var f=document.createElement('div').style,g=typeof f.cssFloat!='undefined'?'cssFloat':typeof f.styleFloat!='undefined'?'styleFloat':'float';return function(h){if(h=='float')return g;else return h.replace(/-./g,function(i){return i.substr(1).toUpperCase();});};})(),buildStyleHtml:function(f){f=[].concat(f);var g,h=[];for(var i=0;i<f.length;i++){g=f[i];if(/@import|[{}]/.test(g))h.push('<style>'+g+'</style>');else h.push('<link type="text/css" rel=stylesheet href="'+g+'">');}return h.join('');},htmlEncode:function(f){var g=function(k){var l=new d.element('span');l.setText(k);return l.getHtml();},h=g('\n').toLowerCase()=='<br>'?function(k){return g(k).replace(/<br>/gi,'\n');}:g,i=g('>')=='>'?function(k){return h(k).replace(/>/g,'&gt;');}:h,j=g('  ')=='&nbsp; '?function(k){return i(k).replace(/&nbsp;/g,' ');}:i;this.htmlEncode=j;return this.htmlEncode(f);},htmlEncodeAttr:function(f){return f.replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');},getNextNumber:(function(){var f=0;return function(){return++f;};})(),getNextId:function(){return 'cke_'+this.getNextNumber();},override:function(f,g){return g(f);},setTimeout:function(f,g,h,i,j){if(!j)j=window;if(!h)h=j;return j.setTimeout(function(){if(i)f.apply(h,[].concat(i));else f.apply(h);},g||0);},trim:(function(){var f=/(?:^[ \t\n\r]+)|(?:[ \t\n\r]+$)/g;return function(g){return g.replace(f,'');};})(),ltrim:(function(){var f=/^[ \t\n\r]+/g;return function(g){return g.replace(f,'');};})(),rtrim:(function(){var f=/[ \t\n\r]+$/g;return function(g){return g.replace(f,'');};})(),indexOf:Array.prototype.indexOf?function(f,g){return f.indexOf(g);}:function(f,g){for(var h=0,i=f.length;h<i;h++){if(f[h]===g)return h;}return-1;},bind:function(f,g){return function(){return f.apply(g,arguments);};},createClass:function(f){var g=f.$,h=f.base,i=f.privates||f._,j=f.proto,k=f.statics;if(i){var l=g;g=function(){var p=this;var m=p._||(p._={});for(var n in i){var o=i[n];m[n]=typeof o=='function'?a.tools.bind(o,p):o;}l.apply(p,arguments);};}if(h){g.prototype=this.prototypedCopy(h.prototype);
g.prototype['constructor']=g;g.prototype.base=function(){this.base=h.prototype.base;h.apply(this,arguments);this.base=arguments.callee;};}if(j)this.extend(g.prototype,j,true);if(k)this.extend(g,k,true);return g;},addFunction:function(f,g){return e.push(function(){return f.apply(g||this,arguments);})-1;},removeFunction:function(f){e[f]=null;},callFunction:function(f){var g=e[f];return g&&g.apply(window,Array.prototype.slice.call(arguments,1));},cssLength:(function(){return function(f){return f+(!f||isNaN(Number(f))?'':'px');};})(),convertToPx:(function(){var f;return function(g){if(!f){f=d.element.createFromHtml('<div style="position:absolute;left:-9999px;top:-9999px;margin:0px;padding:0px;border:0px;"></div>',a.document);a.document.getBody().append(f);}if(!/%$/.test(g)){f.setStyle('width',g);return f.$.clientWidth;}return g;};})(),repeat:function(f,g){return new Array(g+1).join(f);},tryThese:function(){var f;for(var g=0,h=arguments.length;g<h;g++){var i=arguments[g];try{f=i();break;}catch(j){}}return f;},genKey:function(){return Array.prototype.slice.call(arguments).join('-');},normalizeCssText:function(f,g){var h=[],i,j=a.tools.parseCssText(f,true,g);for(i in j)h.push(i+':'+j[i]);h.sort();return h.length?h.join(';')+';':'';},convertRgbToHex:function(f){return f.replace(/(?:rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\))/gi,function(g,h,i,j){var k=[h,i,j];for(var l=0;l<3;l++)k[l]=('0'+parseInt(k[l],10).toString(16)).slice(-2);return '#'+k.join('');});},parseCssText:function(f,g,h){var i={};if(h){var j=new d.element('span');j.setAttribute('style',f);f=a.tools.convertRgbToHex(j.getAttribute('style')||'');}if(!f||f==';')return i;f.replace(/&quot;/g,'"').replace(/\s*([^:;\s]+)\s*:\s*([^;]+)\s*(?=;|$)/g,function(k,l,m){if(g){l=l.toLowerCase();if(l=='font-family')m=m.toLowerCase().replace(/["']/g,'').replace(/\s*,\s*/g,',');m=a.tools.trim(m);}i[l]=m;});return i;}};})();var e=a.tools;a.dtd=(function(){var f=e.extend,g={isindex:1,fieldset:1},h={input:1,button:1,select:1,textarea:1,label:1},i=f({a:1},h),j=f({iframe:1},i),k={hr:1,ul:1,menu:1,div:1,section:1,header:1,footer:1,nav:1,article:1,aside:1,figure:1,dialog:1,hgroup:1,mark:1,time:1,meter:1,command:1,keygen:1,output:1,progress:1,audio:1,video:1,details:1,datagrid:1,datalist:1,blockquote:1,noscript:1,table:1,center:1,address:1,dir:1,pre:1,h5:1,dl:1,h4:1,noframes:1,h6:1,ol:1,h1:1,h3:1,h2:1},l={ins:1,del:1,script:1,style:1},m=f({b:1,acronym:1,bdo:1,'var':1,'#':1,abbr:1,code:1,br:1,i:1,cite:1,kbd:1,u:1,strike:1,s:1,tt:1,strong:1,q:1,samp:1,em:1,dfn:1,span:1,wbr:1},l),n=f({sub:1,img:1,object:1,sup:1,basefont:1,map:1,applet:1,font:1,big:1,small:1,mark:1},m),o=f({p:1},n),p=f({iframe:1},n,h),q={img:1,noscript:1,br:1,kbd:1,center:1,button:1,basefont:1,h5:1,h4:1,samp:1,h6:1,ol:1,h1:1,h3:1,h2:1,form:1,font:1,'#':1,select:1,menu:1,ins:1,abbr:1,label:1,code:1,table:1,script:1,cite:1,input:1,iframe:1,strong:1,textarea:1,noframes:1,big:1,small:1,span:1,hr:1,sub:1,bdo:1,'var':1,div:1,section:1,header:1,footer:1,nav:1,article:1,aside:1,figure:1,dialog:1,hgroup:1,mark:1,time:1,meter:1,menu:1,command:1,keygen:1,output:1,progress:1,audio:1,video:1,details:1,datagrid:1,datalist:1,object:1,sup:1,strike:1,dir:1,map:1,dl:1,applet:1,del:1,isindex:1,fieldset:1,ul:1,b:1,acronym:1,a:1,blockquote:1,i:1,u:1,s:1,tt:1,address:1,q:1,pre:1,p:1,em:1,dfn:1},r=f({a:1},p),s={tr:1},t={'#':1},u=f({param:1},q),v=f({form:1},g,j,k,o),w={li:1},x={style:1,script:1},y={base:1,link:1,meta:1,title:1},z=f(y,x),A={head:1,body:1},B={html:1},C={address:1,blockquote:1,center:1,dir:1,div:1,section:1,header:1,footer:1,nav:1,article:1,aside:1,figure:1,dialog:1,hgroup:1,time:1,meter:1,menu:1,command:1,keygen:1,output:1,progress:1,audio:1,video:1,details:1,datagrid:1,datalist:1,dl:1,fieldset:1,form:1,h1:1,h2:1,h3:1,h4:1,h5:1,h6:1,hr:1,isindex:1,noframes:1,ol:1,p:1,pre:1,table:1,ul:1};
return{$nonBodyContent:f(B,A,y),$block:C,$blockLimit:{body:1,div:1,section:1,header:1,footer:1,nav:1,article:1,aside:1,figure:1,dialog:1,hgroup:1,time:1,meter:1,menu:1,command:1,keygen:1,output:1,progress:1,audio:1,video:1,details:1,datagrid:1,datalist:1,td:1,th:1,caption:1,form:1},$inline:r,$body:f({script:1,style:1},C),$cdata:{script:1,style:1},$empty:{area:1,base:1,br:1,col:1,hr:1,img:1,input:1,link:1,meta:1,param:1,wbr:1},$listItem:{dd:1,dt:1,li:1},$list:{ul:1,ol:1,dl:1},$nonEditable:{applet:1,button:1,embed:1,iframe:1,map:1,object:1,option:1,script:1,textarea:1,param:1,audio:1,video:1},$captionBlock:{caption:1,legend:1},$removeEmpty:{abbr:1,acronym:1,address:1,b:1,bdo:1,big:1,cite:1,code:1,del:1,dfn:1,em:1,font:1,i:1,ins:1,label:1,kbd:1,q:1,s:1,samp:1,small:1,span:1,strike:1,strong:1,sub:1,sup:1,tt:1,u:1,'var':1,mark:1},$tabIndex:{a:1,area:1,button:1,input:1,object:1,select:1,textarea:1},$tableContent:{caption:1,col:1,colgroup:1,tbody:1,td:1,tfoot:1,th:1,thead:1,tr:1},html:A,head:z,style:t,script:t,body:v,base:{},link:{},meta:{},title:t,col:{},tr:{td:1,th:1},img:{},colgroup:{col:1},noscript:v,td:v,br:{},wbr:{},th:v,center:v,kbd:r,button:f(o,k),basefont:{},h5:r,h4:r,samp:r,h6:r,ol:w,h1:r,h3:r,option:t,h2:r,form:f(g,j,k,o),select:{optgroup:1,option:1},font:r,ins:r,menu:w,abbr:r,label:r,table:{thead:1,col:1,tbody:1,tr:1,colgroup:1,caption:1,tfoot:1},code:r,tfoot:s,cite:r,li:v,input:{},iframe:v,strong:r,textarea:t,noframes:v,big:r,small:r,span:r,hr:{},dt:r,sub:r,optgroup:{option:1},param:{},bdo:r,'var':r,div:v,object:u,sup:r,dd:v,strike:r,area:{},dir:w,map:f({area:1,form:1,p:1},g,l,k),applet:u,dl:{dt:1,dd:1},del:r,isindex:{},fieldset:f({legend:1},q),thead:s,ul:w,acronym:r,b:r,a:p,blockquote:v,caption:r,i:r,u:r,tbody:s,s:r,address:f(j,o),tt:r,legend:r,q:r,pre:f(m,i),p:r,em:r,dfn:r,section:v,header:v,footer:v,nav:v,article:v,aside:v,figure:v,dialog:v,hgroup:v,mark:r,time:r,meter:r,menu:r,command:r,keygen:r,output:r,progress:u,audio:u,video:u,details:u,datagrid:u,datalist:u};})();var f=a.dtd;d.event=function(g){this.$=g;};d.event.prototype={getKey:function(){return this.$.keyCode||this.$.which;},getKeystroke:function(){var h=this;var g=h.getKey();if(h.$.ctrlKey||h.$.metaKey)g+=1114112;if(h.$.shiftKey)g+=2228224;if(h.$.altKey)g+=4456448;return g;},preventDefault:function(g){var h=this.$;if(h.preventDefault)h.preventDefault();else h.returnValue=false;if(g)this.stopPropagation();},stopPropagation:function(){var g=this.$;if(g.stopPropagation)g.stopPropagation();else g.cancelBubble=true;
},getTarget:function(){var g=this.$.target||this.$.srcElement;return g?new d.node(g):null;},getPageOffset:function(){var j=this;var g=j.getTarget().getDocument().$,h=j.$.pageX||j.$.clientX+(g.documentElement.scrollLeft||g.body.scrollLeft),i=j.$.pageY||j.$.clientY+(g.documentElement.scrollTop||g.body.scrollTop);return{x:h,y:i};}};a.CTRL=1114112;a.SHIFT=2228224;a.ALT=4456448;d.domObject=function(g){if(g)this.$=g;};d.domObject.prototype=(function(){var g=function(h,i){return function(j){if(typeof a!='undefined')h.fire(i,new d.event(j));};};return{getPrivate:function(){var h;if(!(h=this.getCustomData('_')))this.setCustomData('_',h={});return h;},on:function(h){var k=this;var i=k.getCustomData('_cke_nativeListeners');if(!i){i={};k.setCustomData('_cke_nativeListeners',i);}if(!i[h]){var j=i[h]=g(k,h);if(k.$.addEventListener)k.$.addEventListener(h,j,!!a.event.useCapture);else if(k.$.attachEvent)k.$.attachEvent('on'+h,j);}return a.event.prototype.on.apply(k,arguments);},removeListener:function(h){var k=this;a.event.prototype.removeListener.apply(k,arguments);if(!k.hasListeners(h)){var i=k.getCustomData('_cke_nativeListeners'),j=i&&i[h];if(j){if(k.$.removeEventListener)k.$.removeEventListener(h,j,false);else if(k.$.detachEvent)k.$.detachEvent('on'+h,j);delete i[h];}}},removeAllListeners:function(){var k=this;var h=k.getCustomData('_cke_nativeListeners');for(var i in h){var j=h[i];if(k.$.detachEvent)k.$.detachEvent('on'+i,j);else if(k.$.removeEventListener)k.$.removeEventListener(i,j,false);delete h[i];}}};})();(function(g){var h={};a.on('reset',function(){h={};});g.equals=function(i){return i&&i.$===this.$;};g.setCustomData=function(i,j){var k=this.getUniqueId(),l=h[k]||(h[k]={});l[i]=j;return this;};g.getCustomData=function(i){var j=this.$['data-cke-expando'],k=j&&h[j];return k&&k[i];};g.removeCustomData=function(i){var j=this.$['data-cke-expando'],k=j&&h[j],l=k&&k[i];if(typeof l!='undefined')delete k[i];return l||null;};g.clearCustomData=function(){this.removeAllListeners();var i=this.$['data-cke-expando'];i&&delete h[i];};g.getUniqueId=function(){return this.$['data-cke-expando']||(this.$['data-cke-expando']=e.getNextNumber());};a.event.implementOn(g);})(d.domObject.prototype);d.window=function(g){d.domObject.call(this,g);};d.window.prototype=new d.domObject();e.extend(d.window.prototype,{focus:function(){if(b.webkit&&this.$.parent)this.$.parent.focus();this.$.focus();},getViewPaneSize:function(){var g=this.$.document,h=g.compatMode=='CSS1Compat';return{width:(h?g.documentElement.clientWidth:g.body.clientWidth)||0,height:(h?g.documentElement.clientHeight:g.body.clientHeight)||0};
},getScrollPosition:function(){var g=this.$;if('pageXOffset' in g)return{x:g.pageXOffset||0,y:g.pageYOffset||0};else{var h=g.document;return{x:h.documentElement.scrollLeft||h.body.scrollLeft||0,y:h.documentElement.scrollTop||h.body.scrollTop||0};}}});d.document=function(g){d.domObject.call(this,g);};var g=d.document;g.prototype=new d.domObject();e.extend(g.prototype,{appendStyleSheet:function(h){if(this.$.createStyleSheet)this.$.createStyleSheet(h);else{var i=new d.element('link');i.setAttributes({rel:'stylesheet',type:'text/css',href:h});this.getHead().append(i);}},appendStyleText:function(h){var k=this;if(k.$.createStyleSheet){var i=k.$.createStyleSheet('');i.cssText=h;}else{var j=new d.element('style',k);j.append(new d.text(h,k));k.getHead().append(j);}},createElement:function(h,i){var j=new d.element(h,this);if(i){if(i.attributes)j.setAttributes(i.attributes);if(i.styles)j.setStyles(i.styles);}return j;},createText:function(h){return new d.text(h,this);},focus:function(){this.getWindow().focus();},getById:function(h){var i=this.$.getElementById(h);return i?new d.element(i):null;},getByAddress:function(h,i){var j=this.$.documentElement;for(var k=0;j&&k<h.length;k++){var l=h[k];if(!i){j=j.childNodes[l];continue;}var m=-1;for(var n=0;n<j.childNodes.length;n++){var o=j.childNodes[n];if(i===true&&o.nodeType==3&&o.previousSibling&&o.previousSibling.nodeType==3)continue;m++;if(m==l){j=o;break;}}}return j?new d.node(j):null;},getElementsByTag:function(h,i){if(!(c&&!(document.documentMode>8))&&i)h=i+':'+h;return new d.nodeList(this.$.getElementsByTagName(h));},getHead:function(){var h=this.$.getElementsByTagName('head')[0];if(!h)h=this.getDocumentElement().append(new d.element('head'),true);else h=new d.element(h);return(this.getHead=function(){return h;})();},getBody:function(){var h=new d.element(this.$.body);return(this.getBody=function(){return h;})();},getDocumentElement:function(){var h=new d.element(this.$.documentElement);return(this.getDocumentElement=function(){return h;})();},getWindow:function(){var h=new d.window(this.$.parentWindow||this.$.defaultView);return(this.getWindow=function(){return h;})();},write:function(h){var i=this;i.$.open('text/html','replace');b.isCustomDomain()&&(i.$.domain=document.domain);i.$.write(h);i.$.close();}});d.node=function(h){if(h){var i=h.nodeType==9?'document':h.nodeType==1?'element':h.nodeType==3?'text':h.nodeType==8?'comment':'domObject';return new d[i](h);}return this;};d.node.prototype=new d.domObject();a.NODE_ELEMENT=1;
a.NODE_DOCUMENT=9;a.NODE_TEXT=3;a.NODE_COMMENT=8;a.NODE_DOCUMENT_FRAGMENT=11;a.POSITION_IDENTICAL=0;a.POSITION_DISCONNECTED=1;a.POSITION_FOLLOWING=2;a.POSITION_PRECEDING=4;a.POSITION_IS_CONTAINED=8;a.POSITION_CONTAINS=16;e.extend(d.node.prototype,{appendTo:function(h,i){h.append(this,i);return h;},clone:function(h,i){var j=this.$.cloneNode(h),k=function(l){if(l.nodeType!=1)return;if(!i)l.removeAttribute('id',false);l['data-cke-expando']=undefined;if(h){var m=l.childNodes;for(var n=0;n<m.length;n++)k(m[n]);}};k(j);return new d.node(j);},hasPrevious:function(){return!!this.$.previousSibling;},hasNext:function(){return!!this.$.nextSibling;},insertAfter:function(h){h.$.parentNode.insertBefore(this.$,h.$.nextSibling);return h;},insertBefore:function(h){h.$.parentNode.insertBefore(this.$,h.$);return h;},insertBeforeMe:function(h){this.$.parentNode.insertBefore(h.$,this.$);return h;},getAddress:function(h){var i=[],j=this.getDocument().$.documentElement,k=this.$;while(k&&k!=j){var l=k.parentNode;if(l)i.unshift(this.getIndex.call({$:k},h));k=l;}return i;},getDocument:function(){return new g(this.$.ownerDocument||this.$.parentNode.ownerDocument);},getIndex:function(h){var i=this.$,j=0;while(i=i.previousSibling){if(h&&i.nodeType==3&&(!i.nodeValue.length||i.previousSibling&&i.previousSibling.nodeType==3))continue;j++;}return j;},getNextSourceNode:function(h,i,j){if(j&&!j.call){var k=j;j=function(n){return!n.equals(k);};}var l=!h&&this.getFirst&&this.getFirst(),m;if(!l){if(this.type==1&&j&&j(this,true)===false)return null;l=this.getNext();}while(!l&&(m=(m||this).getParent())){if(j&&j(m,true)===false)return null;l=m.getNext();}if(!l)return null;if(j&&j(l)===false)return null;if(i&&i!=l.type)return l.getNextSourceNode(false,i,j);return l;},getPreviousSourceNode:function(h,i,j){if(j&&!j.call){var k=j;j=function(n){return!n.equals(k);};}var l=!h&&this.getLast&&this.getLast(),m;if(!l){if(this.type==1&&j&&j(this,true)===false)return null;l=this.getPrevious();}while(!l&&(m=(m||this).getParent())){if(j&&j(m,true)===false)return null;l=m.getPrevious();}if(!l)return null;if(j&&j(l)===false)return null;if(i&&l.type!=i)return l.getPreviousSourceNode(false,i,j);return l;},getPrevious:function(h){var i=this.$,j;do{i=i.previousSibling;j=i&&i.nodeType!=10&&new d.node(i);}while(j&&h&&!h(j));return j;},getNext:function(h){var i=this.$,j;do{i=i.nextSibling;j=i&&new d.node(i);}while(j&&h&&!h(j));return j;},getParent:function(){var h=this.$.parentNode;return h&&h.nodeType==1?new d.node(h):null;
},getParents:function(h){var i=this,j=[];do j[h?'push':'unshift'](i);while(i=i.getParent());return j;},getCommonAncestor:function(h){var j=this;if(h.equals(j))return j;if(h.contains&&h.contains(j))return h;var i=j.contains?j:j.getParent();do{if(i.contains(h))return i;}while(i=i.getParent());return null;},getPosition:function(h){var i=this.$,j=h.$;if(i.compareDocumentPosition)return i.compareDocumentPosition(j);if(i==j)return 0;if(this.type==1&&h.type==1){if(i.contains){if(i.contains(j))return 16+4;if(j.contains(i))return 8+2;}if('sourceIndex' in i)return i.sourceIndex<0||j.sourceIndex<0?1:i.sourceIndex<j.sourceIndex?4:2;}var k=this.getAddress(),l=h.getAddress(),m=Math.min(k.length,l.length);for(var n=0;n<=m-1;n++){if(k[n]!=l[n]){if(n<m)return k[n]<l[n]?4:2;break;}}return k.length<l.length?16+4:8+2;},getAscendant:function(h,i){var j=this.$,k;if(!i)j=j.parentNode;while(j){if(j.nodeName&&(k=j.nodeName.toLowerCase(),typeof h=='string'?k==h:k in h))return new d.node(j);j=j.parentNode;}return null;},hasAscendant:function(h,i){var j=this.$;if(!i)j=j.parentNode;while(j){if(j.nodeName&&j.nodeName.toLowerCase()==h)return true;j=j.parentNode;}return false;},move:function(h,i){h.append(this.remove(),i);},remove:function(h){var i=this.$,j=i.parentNode;if(j){if(h)for(var k;k=i.firstChild;)j.insertBefore(i.removeChild(k),i);j.removeChild(i);}return this;},replace:function(h){this.insertBefore(h);h.remove();},trim:function(){this.ltrim();this.rtrim();},ltrim:function(){var k=this;var h;while(k.getFirst&&(h=k.getFirst())){if(h.type==3){var i=e.ltrim(h.getText()),j=h.getLength();if(!i){h.remove();continue;}else if(i.length<j){h.split(j-i.length);k.$.removeChild(k.$.firstChild);}}break;}},rtrim:function(){var k=this;var h;while(k.getLast&&(h=k.getLast())){if(h.type==3){var i=e.rtrim(h.getText()),j=h.getLength();if(!i){h.remove();continue;}else if(i.length<j){h.split(i.length);k.$.lastChild.parentNode.removeChild(k.$.lastChild);}}break;}if(!c&&!b.opera){h=k.$.lastChild;if(h&&h.type==1&&h.nodeName.toLowerCase()=='br')h.parentNode.removeChild(h);}},isReadOnly:function(){var h=this;if(this.type!=1)h=this.getParent();if(h&&typeof h.$.isContentEditable!='undefined')return!(h.$.isContentEditable||h.data('cke-editable'));else{var i=h;while(i){if(i.is('body')||!!i.data('cke-editable'))break;if(i.getAttribute('contentEditable')=='false')return true;else if(i.getAttribute('contentEditable')=='true')break;i=i.getParent();}return false;}}});d.nodeList=function(h){this.$=h;};d.nodeList.prototype={count:function(){return this.$.length;
},getItem:function(h){var i=this.$[h];return i?new d.node(i):null;}};d.element=function(h,i){if(typeof h=='string')h=(i?i.$:document).createElement(h);d.domObject.call(this,h);};var h=d.element;h.get=function(i){return i&&(i.$?i:new h(i));};h.prototype=new d.node();h.createFromHtml=function(i,j){var k=new h('div',j);k.setHtml(i);return k.getFirst().remove();};h.setMarker=function(i,j,k,l){var m=j.getCustomData('list_marker_id')||j.setCustomData('list_marker_id',e.getNextNumber()).getCustomData('list_marker_id'),n=j.getCustomData('list_marker_names')||j.setCustomData('list_marker_names',{}).getCustomData('list_marker_names');i[m]=j;n[k]=1;return j.setCustomData(k,l);};h.clearAllMarkers=function(i){for(var j in i)h.clearMarkers(i,i[j],1);};h.clearMarkers=function(i,j,k){var l=j.getCustomData('list_marker_names'),m=j.getCustomData('list_marker_id');for(var n in l)j.removeCustomData(n);j.removeCustomData('list_marker_names');if(k){j.removeCustomData('list_marker_id');delete i[m];}};(function(){e.extend(h.prototype,{type:1,addClass:function(l){var m=this.$.className;if(m){var n=new RegExp('(?:^|\\s)'+l+'(?:\\s|$)','');if(!n.test(m))m+=' '+l;}this.$.className=m||l;},removeClass:function(l){var m=this.getAttribute('class');if(m){var n=new RegExp('(?:^|\\s+)'+l+'(?=\\s|$)','i');if(n.test(m)){m=m.replace(n,'').replace(/^\s+/,'');if(m)this.setAttribute('class',m);else this.removeAttribute('class');}}},hasClass:function(l){var m=new RegExp('(?:^|\\s+)'+l+'(?=\\s|$)','');return m.test(this.getAttribute('class'));},append:function(l,m){var n=this;if(typeof l=='string')l=n.getDocument().createElement(l);if(m)n.$.insertBefore(l.$,n.$.firstChild);else n.$.appendChild(l.$);return l;},appendHtml:function(l){var n=this;if(!n.$.childNodes.length)n.setHtml(l);else{var m=new h('div',n.getDocument());m.setHtml(l);m.moveChildren(n);}},appendText:function(l){if(this.$.text!=undefined)this.$.text+=l;else this.append(new d.text(l));},appendBogus:function(){var n=this;var l=n.getLast();while(l&&l.type==3&&!e.rtrim(l.getText()))l=l.getPrevious();if(!l||!l.is||!l.is('br')){var m=b.opera?n.getDocument().createText(''):n.getDocument().createElement('br');b.gecko&&m.setAttribute('type','_moz');n.append(m);}},breakParent:function(l){var o=this;var m=new d.range(o.getDocument());m.setStartAfter(o);m.setEndAfter(l);var n=m.extractContents();m.insertNode(o.remove());n.insertAfterNode(o);},contains:c||b.webkit?function(l){var m=this.$;return l.type!=1?m.contains(l.getParent().$):m!=l.$&&m.contains(l.$);
}:function(l){return!!(this.$.compareDocumentPosition(l.$)&16);},focus:(function(){function l(){try{this.$.focus();}catch(m){}};return function(m){if(m)e.setTimeout(l,100,this);else l.call(this);};})(),getHtml:function(){var l=this.$.innerHTML;return c?l.replace(/<\?[^>]*>/g,''):l;},getOuterHtml:function(){var m=this;if(m.$.outerHTML)return m.$.outerHTML.replace(/<\?[^>]*>/,'');var l=m.$.ownerDocument.createElement('div');l.appendChild(m.$.cloneNode(true));return l.innerHTML;},setHtml:function(l){return this.$.innerHTML=l;},setText:function(l){h.prototype.setText=this.$.innerText!=undefined?function(m){return this.$.innerText=m;}:function(m){return this.$.textContent=m;};return this.setText(l);},getAttribute:(function(){var l=function(m){return this.$.getAttribute(m,2);};if(c&&(b.ie7Compat||b.ie6Compat))return function(m){var q=this;switch(m){case 'class':m='className';break;case 'http-equiv':m='httpEquiv';break;case 'name':return q.$.name;case 'tabindex':var n=l.call(q,m);if(n!==0&&q.$.tabIndex===0)n=null;return n;break;case 'checked':var o=q.$.attributes.getNamedItem(m),p=o.specified?o.nodeValue:q.$.checked;return p?'checked':null;case 'hspace':case 'value':return q.$[m];case 'style':return q.$.style.cssText;case 'contenteditable':case 'contentEditable':return q.$.attributes.getNamedItem('contentEditable').specified?q.$.getAttribute('contentEditable'):null;}return l.call(q,m);};else return l;})(),getChildren:function(){return new d.nodeList(this.$.childNodes);},getComputedStyle:c?function(l){return this.$.currentStyle[e.cssStyleToDomStyle(l)];}:function(l){var m=this.getWindow().$.getComputedStyle(this.$,null);return m?m.getPropertyValue(l):'';},getDtd:function(){var l=f[this.getName()];this.getDtd=function(){return l;};return l;},getElementsByTag:g.prototype.getElementsByTag,getTabIndex:c?function(){var l=this.$.tabIndex;if(l===0&&!f.$tabIndex[this.getName()]&&parseInt(this.getAttribute('tabindex'),10)!==0)l=-1;return l;}:b.webkit?function(){var l=this.$.tabIndex;if(l==undefined){l=parseInt(this.getAttribute('tabindex'),10);if(isNaN(l))l=-1;}return l;}:function(){return this.$.tabIndex;},getText:function(){return this.$.textContent||this.$.innerText||'';},getWindow:function(){return this.getDocument().getWindow();},getId:function(){return this.$.id||null;},getNameAtt:function(){return this.$.name||null;},getName:function(){var l=this.$.nodeName.toLowerCase();if(c&&!(document.documentMode>8)){var m=this.$.scopeName;if(m!='HTML')l=m.toLowerCase()+':'+l;}return(this.getName=function(){return l;
})();},getValue:function(){return this.$.value;},getFirst:function(l){var m=this.$.firstChild,n=m&&new d.node(m);if(n&&l&&!l(n))n=n.getNext(l);return n;},getLast:function(l){var m=this.$.lastChild,n=m&&new d.node(m);if(n&&l&&!l(n))n=n.getPrevious(l);return n;},getStyle:function(l){return this.$.style[e.cssStyleToDomStyle(l)];},is:function(){var l=this.getName();for(var m=0;m<arguments.length;m++){if(arguments[m]==l)return true;}return false;},isEditable:function(l){var o=this;var m=o.getName();if(o.isReadOnly()||o.getComputedStyle('display')=='none'||o.getComputedStyle('visibility')=='hidden'||o.is('a')&&o.data('cke-saved-name')&&!o.getChildCount()||f.$nonEditable[m]||f.$empty[m])return false;if(l!==false){var n=f[m]||f.span;return n&&n['#'];}return true;},isIdentical:function(l){if(this.getName()!=l.getName())return false;var m=this.$.attributes,n=l.$.attributes,o=m.length,p=n.length;for(var q=0;q<o;q++){var r=m[q];if(r.nodeName=='_moz_dirty')continue;if((!c||r.specified&&r.nodeName!='data-cke-expando')&&r.nodeValue!=l.getAttribute(r.nodeName))return false;}if(c)for(q=0;q<p;q++){r=n[q];if(r.specified&&r.nodeName!='data-cke-expando'&&r.nodeValue!=this.getAttribute(r.nodeName))return false;}return true;},isVisible:function(){var o=this;var l=(o.$.offsetHeight||o.$.offsetWidth)&&o.getComputedStyle('visibility')!='hidden',m,n;if(l&&(b.webkit||b.opera)){m=o.getWindow();if(!m.equals(a.document.getWindow())&&(n=m.$.frameElement))l=new h(n).isVisible();}return!!l;},isEmptyInlineRemoveable:function(){if(!f.$removeEmpty[this.getName()])return false;var l=this.getChildren();for(var m=0,n=l.count();m<n;m++){var o=l.getItem(m);if(o.type==1&&o.data('cke-bookmark'))continue;if(o.type==1&&!o.isEmptyInlineRemoveable()||o.type==3&&e.trim(o.getText()))return false;}return true;},hasAttributes:c&&(b.ie7Compat||b.ie6Compat)?function(){var l=this.$.attributes;for(var m=0;m<l.length;m++){var n=l[m];switch(n.nodeName){case 'class':if(this.getAttribute('class'))return true;case 'data-cke-expando':continue;default:if(n.specified)return true;}}return false;}:function(){var l=this.$.attributes,m=l.length,n={'data-cke-expando':1,_moz_dirty:1};return m>0&&(m>2||!n[l[0].nodeName]||m==2&&!n[l[1].nodeName]);},hasAttribute:(function(){function l(m){var n=this.$.attributes.getNamedItem(m);return!!(n&&n.specified);};return c&&b.version<8?function(m){if(m=='name')return!!this.$.name;return l.call(this,m);}:l;})(),hide:function(){this.setStyle('display','none');},moveChildren:function(l,m){var n=this.$;
l=l.$;if(n==l)return;var o;if(m)while(o=n.lastChild)l.insertBefore(n.removeChild(o),l.firstChild);else while(o=n.firstChild)l.appendChild(n.removeChild(o));},mergeSiblings:(function(){function l(m,n,o){if(n&&n.type==1){var p=[];while(n.data('cke-bookmark')||n.isEmptyInlineRemoveable()){p.push(n);n=o?n.getNext():n.getPrevious();if(!n||n.type!=1)return;}if(m.isIdentical(n)){var q=o?m.getLast():m.getFirst();while(p.length)p.shift().move(m,!o);n.moveChildren(m,!o);n.remove();if(q&&q.type==1)q.mergeSiblings();}}};return function(m){var n=this;if(!(m===false||f.$removeEmpty[n.getName()]||n.is('a')))return;l(n,n.getNext(),true);l(n,n.getPrevious());};})(),show:function(){this.setStyles({display:'',visibility:''});},setAttribute:(function(){var l=function(m,n){this.$.setAttribute(m,n);return this;};if(c&&(b.ie7Compat||b.ie6Compat))return function(m,n){var o=this;if(m=='class')o.$.className=n;else if(m=='style')o.$.style.cssText=n;else if(m=='tabindex')o.$.tabIndex=n;else if(m=='checked')o.$.checked=n;else if(m=='contenteditable')l.call(o,'contentEditable',n);else l.apply(o,arguments);return o;};else if(b.ie8Compat&&b.secure)return function(m,n){if(m=='src'&&n.match(/^http:\/\//))try{l.apply(this,arguments);}catch(o){}else l.apply(this,arguments);return this;};else return l;})(),setAttributes:function(l){for(var m in l)this.setAttribute(m,l[m]);return this;},setValue:function(l){this.$.value=l;return this;},removeAttribute:(function(){var l=function(m){this.$.removeAttribute(m);};if(c&&(b.ie7Compat||b.ie6Compat))return function(m){if(m=='class')m='className';else if(m=='tabindex')m='tabIndex';else if(m=='contenteditable')m='contentEditable';l.call(this,m);};else return l;})(),removeAttributes:function(l){if(e.isArray(l))for(var m=0;m<l.length;m++)this.removeAttribute(l[m]);else for(var n in l)l.hasOwnProperty(n)&&this.removeAttribute(n);},removeStyle:function(l){var p=this;var m=p.$.style;if(!m.removeProperty&&(l=='border'||l=='margin'||l=='padding')){var n=j(l);for(var o=0;o<n.length;o++)p.removeStyle(n[o]);return;}m.removeProperty?m.removeProperty(l):m.removeAttribute(e.cssStyleToDomStyle(l));if(!p.$.style.cssText)p.removeAttribute('style');},setStyle:function(l,m){this.$.style[e.cssStyleToDomStyle(l)]=m;return this;},setStyles:function(l){for(var m in l)this.setStyle(m,l[m]);return this;},setOpacity:function(l){if(c&&b.version<9){l=Math.round(l*100);this.setStyle('filter',l>=100?'':'progid:DXImageTransform.Microsoft.Alpha(opacity='+l+')');}else this.setStyle('opacity',l);
},unselectable:b.gecko?function(){this.$.style.MozUserSelect='none';this.on('dragstart',function(l){l.data.preventDefault();});}:b.webkit?function(){this.$.style.KhtmlUserSelect='none';this.on('dragstart',function(l){l.data.preventDefault();});}:function(){if(c||b.opera){var l=this.$,m=l.getElementsByTagName('*'),n,o=0;l.unselectable='on';while(n=m[o++])switch(n.tagName.toLowerCase()){case 'iframe':case 'textarea':case 'input':case 'select':break;default:n.unselectable='on';}}},getPositionedAncestor:function(){var l=this;while(l.getName()!='html'){if(l.getComputedStyle('position')!='static')return l;l=l.getParent();}return null;},getDocumentPosition:function(l){var G=this;var m=0,n=0,o=G.getDocument(),p=o.getBody(),q=o.$.compatMode=='BackCompat';if(document.documentElement.getBoundingClientRect){var r=G.$.getBoundingClientRect(),s=o.$,t=s.documentElement,u=t.clientTop||p.$.clientTop||0,v=t.clientLeft||p.$.clientLeft||0,w=true;if(c){var x=o.getDocumentElement().contains(G),y=o.getBody().contains(G);w=q&&y||!q&&x;}if(w){m=r.left+(!q&&t.scrollLeft||p.$.scrollLeft);m-=v;n=r.top+(!q&&t.scrollTop||p.$.scrollTop);n-=u;}}else{var z=G,A=null,B;while(z&&!(z.getName()=='body'||z.getName()=='html')){m+=z.$.offsetLeft-z.$.scrollLeft;n+=z.$.offsetTop-z.$.scrollTop;if(!z.equals(G)){m+=z.$.clientLeft||0;n+=z.$.clientTop||0;}var C=A;while(C&&!C.equals(z)){m-=C.$.scrollLeft;n-=C.$.scrollTop;C=C.getParent();}A=z;z=(B=z.$.offsetParent)?new h(B):null;}}if(l){var D=G.getWindow(),E=l.getWindow();if(!D.equals(E)&&D.$.frameElement){var F=new h(D.$.frameElement).getDocumentPosition(l);m+=F.x;n+=F.y;}}if(!document.documentElement.getBoundingClientRect)if(b.gecko&&!q){m+=G.$.clientLeft?1:0;n+=G.$.clientTop?1:0;}return{x:m,y:n};},scrollIntoView:function(l){var m=this.getParent();if(!m)return;do{var n=m.$.clientWidth&&m.$.clientWidth<m.$.scrollWidth||m.$.clientHeight&&m.$.clientHeight<m.$.scrollHeight;if(n)this.scrollIntoParent(m,l,1);if(m.is('html')){var o=m.getWindow();try{var p=o.$.frameElement;p&&(m=new h(p));}catch(q){}}}while(m=m.getParent());},scrollIntoParent:function(l,m,n){!l&&(l=this.getWindow());var o=l.getDocument(),p=o.$.compatMode=='BackCompat';if(l instanceof d.window)l=p?o.getBody():o.getDocumentElement();function q(C,D){if(/body|html/.test(l.getName()))l.getWindow().$.scrollBy(C,D);else{l.$.scrollLeft+=C;l.$.scrollTop+=D;}};function r(C,D){var E={x:0,y:0};if(!C.is(p?'body':'html')){var F=C.$.getBoundingClientRect();E.x=F.left,E.y=F.top;}var G=C.getWindow();if(!G.equals(D)){var H=r(h.get(G.$.frameElement),D);
E.x+=H.x,E.y+=H.y;}return E;};function s(C,D){return parseInt(C.getComputedStyle('margin-'+D)||0,10)||0;};var t=l.getWindow(),u=r(this,t),v=r(l,t),w=this.$.offsetHeight,x=this.$.offsetWidth,y=l.$.clientHeight,z=l.$.clientWidth,A,B;A={x:u.x-s(this,'left')-v.x||0,y:u.y-s(this,'top')-v.y||0};B={x:u.x+x+s(this,'right')-(v.x+z)||0,y:u.y+w+s(this,'bottom')-(v.y+y)||0};if(A.y<0||B.y>0)q(0,m===true?A.y:m===false?B.y:A.y<0?A.y:B.y);if(n&&(A.x<0||B.x>0))q(A.x<0?A.x:B.x,0);},setState:function(l){var m=this;switch(l){case 1:m.addClass('cke_on');m.removeClass('cke_off');m.removeClass('cke_disabled');break;case 0:m.addClass('cke_disabled');m.removeClass('cke_off');m.removeClass('cke_on');break;default:m.addClass('cke_off');m.removeClass('cke_on');m.removeClass('cke_disabled');break;}},getFrameDocument:function(){var l=this.$;try{l.contentWindow.document;}catch(m){l.src=l.src;if(c&&b.version<7)window.showModalDialog('javascript:document.write("<script>window.setTimeout(function(){window.close();},50);</script>")');}return l&&new g(l.contentWindow.document);},copyAttributes:function(l,m){var s=this;var n=s.$.attributes;m=m||{};for(var o=0;o<n.length;o++){var p=n[o],q=p.nodeName.toLowerCase(),r;if(q in m)continue;if(q=='checked'&&(r=s.getAttribute(q)))l.setAttribute(q,r);else if(p.specified||c&&p.nodeValue&&q=='value'){r=s.getAttribute(q);if(r===null)r=p.nodeValue;l.setAttribute(q,r);}}if(s.$.style.cssText!=='')l.$.style.cssText=s.$.style.cssText;},renameNode:function(l){var o=this;if(o.getName()==l)return;var m=o.getDocument(),n=new h(l,m);o.copyAttributes(n);o.moveChildren(n);o.getParent()&&o.$.parentNode.replaceChild(n.$,o.$);n.$['data-cke-expando']=o.$['data-cke-expando'];o.$=n.$;},getChild:function(l){var m=this.$;if(!l.slice)m=m.childNodes[l];else while(l.length>0&&m)m=m.childNodes[l.shift()];return m?new d.node(m):null;},getChildCount:function(){return this.$.childNodes.length;},disableContextMenu:function(){this.on('contextmenu',function(l){if(!l.data.getTarget().hasClass('cke_enable_context_menu'))l.data.preventDefault();});},getDirection:function(l){var m=this;return l?m.getComputedStyle('direction')||m.getDirection()||m.getDocument().$.dir||m.getDocument().getBody().getDirection(1):m.getStyle('direction')||m.getAttribute('dir');},data:function(l,m){l='data-'+l;if(m===undefined)return this.getAttribute(l);else if(m===false)this.removeAttribute(l);else this.setAttribute(l,m);return null;}});var i={width:['border-left-width','border-right-width','padding-left','padding-right'],height:['border-top-width','border-bottom-width','padding-top','padding-bottom']};
function j(l){var m=['top','left','right','bottom'],n;if(l=='border')n=['color','style','width'];var o=[];for(var p=0;p<m.length;p++){if(n)for(var q=0;q<n.length;q++)o.push([l,m[p],n[q]].join('-'));else o.push([l,m[p]].join('-'));}return o;};function k(l){var m=0;for(var n=0,o=i[l].length;n<o;n++)m+=parseInt(this.getComputedStyle(i[l][n])||0,10)||0;return m;};h.prototype.setSize=function(l,m,n){if(typeof m=='number'){if(n&&!(c&&b.quirks))m-=k.call(this,l);this.setStyle(l,m+'px');}};h.prototype.getSize=function(l,m){var n=Math.max(this.$['offset'+e.capitalize(l)],this.$['client'+e.capitalize(l)])||0;if(m)n-=k.call(this,l);return n;};})();a.command=function(i,j){this.uiItems=[];this.exec=function(k){var l=this;if(l.state==0)return false;if(l.editorFocus)i.focus();if(l.fire('exec')===true)return true;return j.exec.call(l,i,k)!==false;};this.refresh=function(){if(this.fire('refresh')===true)return true;return j.refresh&&j.refresh.apply(this,arguments)!==false;};e.extend(this,j,{modes:{wysiwyg:1},editorFocus:1,state:2});a.event.call(this);};a.command.prototype={enable:function(){var i=this;if(i.state==0)i.setState(!i.preserveState||typeof i.previousState=='undefined'?2:i.previousState);},disable:function(){this.setState(0);},setState:function(i){var j=this;if(j.state==i)return false;j.previousState=j.state;j.state=i;j.fire('state');return true;},toggleState:function(){var i=this;if(i.state==2)i.setState(1);else if(i.state==1)i.setState(2);}};a.event.implementOn(a.command.prototype,true);a.ENTER_P=1;a.ENTER_BR=2;a.ENTER_DIV=3;a.config={customConfig:'config.js',autoUpdateElement:true,baseHref:'',contentsCss:a.basePath+'contents.css',contentsLangDirection:'ui',contentsLanguage:'',language:'',defaultLanguage:'en',enterMode:1,forceEnterMode:false,shiftEnterMode:2,corePlugins:'',docType:'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',bodyId:'',bodyClass:'',fullPage:false,height:200,plugins:'about,a11yhelp,basicstyles,bidi,blockquote,button,clipboard,colorbutton,colordialog,contextmenu,dialogadvtab,div,elementspath,enterkey,entities,filebrowser,find,flash,font,format,forms,horizontalrule,htmldataprocessor,iframe,image,indent,justify,keystrokes,link,list,liststyle,maximize,newpage,pagebreak,pastefromword,pastetext,popup,preview,print,removeformat,resize,save,scayt,showblocks,showborders,smiley,sourcearea,specialchar,stylescombo,tab,table,tabletools,templates,toolbar,undo,wsc,wysiwygarea',extraPlugins:'',removePlugins:'',protectedSource:[],tabIndex:0,theme:'default',skin:'kama',width:'',baseFloatZIndex:10000};
var i=a.config;a.focusManager=function(j){if(j.focusManager)return j.focusManager;this.hasFocus=false;this._={editor:j};return this;};a.focusManager.prototype={focus:function(){var k=this;if(k._.timer)clearTimeout(k._.timer);if(!k.hasFocus){if(a.currentInstance)a.currentInstance.focusManager.forceBlur();var j=k._.editor;j.container.getChild(1).addClass('cke_focus');k.hasFocus=true;j.fire('focus');}},blur:function(){var j=this;if(j._.timer)clearTimeout(j._.timer);j._.timer=setTimeout(function(){delete j._.timer;j.forceBlur();},100);},forceBlur:function(){if(this.hasFocus){var j=this._.editor;j.container.getChild(1).removeClass('cke_focus');this.hasFocus=false;j.fire('blur');}}};(function(){var j={};a.lang={languages:{af:1,ar:1,bg:1,bn:1,bs:1,ca:1,cs:1,cy:1,da:1,de:1,el:1,'en-au':1,'en-ca':1,'en-gb':1,en:1,eo:1,es:1,et:1,eu:1,fa:1,fi:1,fo:1,'fr-ca':1,fr:1,gl:1,gu:1,he:1,hi:1,hr:1,hu:1,is:1,it:1,ja:1,ka:1,km:1,ko:1,ku:1,lt:1,lv:1,mn:1,ms:1,nb:1,nl:1,no:1,pl:1,'pt-br':1,pt:1,ro:1,ru:1,sk:1,sl:1,'sr-latn':1,sr:1,sv:1,th:1,tr:1,ug:1,uk:1,vi:1,'zh-cn':1,zh:1},load:function(k,l,m){if(!k||!a.lang.languages[k])k=this.detect(l,k);if(!this[k])a.scriptLoader.load(a.getUrl('lang/'+k+'.js'),function(){m(k,this[k]);},this);else m(k,this[k]);},detect:function(k,l){var m=this.languages;l=l||navigator.userLanguage||navigator.language||k;var n=l.toLowerCase().match(/([a-z]+)(?:-([a-z]+))?/),o=n[1],p=n[2];if(m[o+'-'+p])o=o+'-'+p;else if(!m[o])o=null;a.lang.detect=o?function(){return o;}:function(q){return q;};return o||k;}};})();a.scriptLoader=(function(){var j={},k={};return{load:function(l,m,n,o){var p=typeof l=='string';if(p)l=[l];if(!n)n=a;var q=l.length,r=[],s=[],t=function(y){if(m)if(p)m.call(n,y);else m.call(n,r,s);};if(q===0){t(true);return;}var u=function(y,z){(z?r:s).push(y);if(--q<=0){o&&a.document.getDocumentElement().removeStyle('cursor');t(z);}},v=function(y,z){j[y]=1;var A=k[y];delete k[y];for(var B=0;B<A.length;B++)A[B](y,z);},w=function(y){if(j[y]){u(y,true);return;}var z=k[y]||(k[y]=[]);z.push(u);if(z.length>1)return;var A=new h('script');A.setAttributes({type:'text/javascript',src:y});if(m)if(c)A.$.onreadystatechange=function(){if(A.$.readyState=='loaded'||A.$.readyState=='complete'){A.$.onreadystatechange=null;v(y,true);}};else{A.$.onload=function(){setTimeout(function(){v(y,true);},0);};A.$.onerror=function(){v(y,false);};}A.appendTo(a.document.getHead());};o&&a.document.getDocumentElement().setStyle('cursor','wait');for(var x=0;x<q;x++)w(l[x]);}};})();a.resourceManager=function(j,k){var l=this;
l.basePath=j;l.fileName=k;l.registered={};l.loaded={};l.externals={};l._={waitingList:{}};};a.resourceManager.prototype={add:function(j,k){if(this.registered[j])throw '[CKEDITOR.resourceManager.add] The resource name "'+j+'" is already registered.';a.fire(j+e.capitalize(this.fileName)+'Ready',this.registered[j]=k||{});},get:function(j){return this.registered[j]||null;},getPath:function(j){var k=this.externals[j];return a.getUrl(k&&k.dir||this.basePath+j+'/');},getFilePath:function(j){var k=this.externals[j];return a.getUrl(this.getPath(j)+(k&&typeof k.file=='string'?k.file:this.fileName+'.js'));},addExternal:function(j,k,l){j=j.split(',');for(var m=0;m<j.length;m++){var n=j[m];this.externals[n]={dir:k,file:l};}},load:function(j,k,l){if(!e.isArray(j))j=j?[j]:[];var m=this.loaded,n=this.registered,o=[],p={},q={};for(var r=0;r<j.length;r++){var s=j[r];if(!s)continue;if(!m[s]&&!n[s]){var t=this.getFilePath(s);o.push(t);if(!(t in p))p[t]=[];p[t].push(s);}else q[s]=this.get(s);}a.scriptLoader.load(o,function(u,v){if(v.length)throw '[CKEDITOR.resourceManager.load] Resource name "'+p[v[0]].join(',')+'" was not found at "'+v[0]+'".';for(var w=0;w<u.length;w++){var x=p[u[w]];for(var y=0;y<x.length;y++){var z=x[y];q[z]=this.get(z);m[z]=1;}}k.call(l,q);},this);}};a.plugins=new a.resourceManager('plugins/','plugin');var j=a.plugins;j.load=e.override(j.load,function(k){return function(l,m,n){var o={},p=function(q){k.call(this,q,function(r){e.extend(o,r);var s=[];for(var t in r){var u=r[t],v=u&&u.requires;if(v)for(var w=0;w<v.length;w++){if(!o[v[w]])s.push(v[w]);}}if(s.length)p.call(this,s);else{for(t in o){u=o[t];if(u.onLoad&&!u.onLoad._called){u.onLoad();u.onLoad._called=1;}}if(m)m.call(n||window,o);}},this);};p.call(this,l);};});j.setLang=function(k,l,m){var n=this.get(k),o=n.langEntries||(n.langEntries={}),p=n.lang||(n.lang=[]);if(e.indexOf(p,l)==-1)p.push(l);o[l]=m;};a.skins=(function(){var k={},l={},m=function(n,o,p,q){var r=k[o];if(!n.skin){n.skin=r;if(r.init)r.init(n);}var s=function(B){for(var C=0;C<B.length;C++)B[C]=a.getUrl(l[o]+B[C]);};function t(B,C){return B.replace(/url\s*\(([\s'"]*)(.*?)([\s"']*)\)/g,function(D,E,F,G){if(/^\/|^\w?:/.test(F))return D;else return 'url('+C+E+F+G+')';});};p=r[p];var u=!p||!!p._isLoaded;if(u)q&&q();else{var v=p._pending||(p._pending=[]);v.push(q);if(v.length>1)return;var w=!p.css||!p.css.length,x=!p.js||!p.js.length,y=function(){if(w&&x){p._isLoaded=1;for(var B=0;B<v.length;B++){if(v[B])v[B]();}}};if(!w){var z=p.css;if(e.isArray(z)){s(z);
for(var A=0;A<z.length;A++)a.document.appendStyleSheet(z[A]);}else{z=t(z,a.getUrl(l[o]));a.document.appendStyleText(z);}p.css=z;w=1;}if(!x){s(p.js);a.scriptLoader.load(p.js,function(){x=1;y();});}y();}};return{add:function(n,o){k[n]=o;o.skinPath=l[n]||(l[n]=a.getUrl('skins/'+n+'/'));},load:function(n,o,p){var q=n.skinName,r=n.skinPath;if(k[q])m(n,q,o,p);else{l[q]=r;a.scriptLoader.load(a.getUrl(r+'skin.js'),function(){m(n,q,o,p);});}}};})();a.themes=new a.resourceManager('themes/','theme');a.ui=function(k){if(k.ui)return k.ui;this._={handlers:{},items:{},editor:k};return this;};var k=a.ui;k.prototype={add:function(l,m,n){this._.items[l]={type:m,command:n.command||null,args:Array.prototype.slice.call(arguments,2)};},create:function(l){var q=this;var m=q._.items[l],n=m&&q._.handlers[m.type],o=m&&m.command&&q._.editor.getCommand(m.command),p=n&&n.create.apply(q,m.args);m&&(p=e.extend(p,q._.editor.skin[m.type],true));if(o)o.uiItems.push(p);return p;},addHandler:function(l,m){this._.handlers[l]=m;}};a.event.implementOn(k);(function(){var l=0,m=function(){var x='editor'+ ++l;return a.instances&&a.instances[x]?m():x;},n={},o=function(x){var y=x.config.customConfig;if(!y)return false;y=a.getUrl(y);var z=n[y]||(n[y]={});if(z.fn){z.fn.call(x,x.config);if(a.getUrl(x.config.customConfig)==y||!o(x))x.fireOnce('customConfigLoaded');}else a.scriptLoader.load(y,function(){if(a.editorConfig)z.fn=a.editorConfig;else z.fn=function(){};o(x);});return true;},p=function(x,y){x.on('customConfigLoaded',function(){if(y){if(y.on)for(var z in y.on)x.on(z,y.on[z]);e.extend(x.config,y,true);delete x.config.on;}q(x);});if(y&&y.customConfig!=undefined)x.config.customConfig=y.customConfig;if(!o(x))x.fireOnce('customConfigLoaded');},q=function(x){var y=x.config.skin.split(','),z=y[0],A=a.getUrl(y[1]||'skins/'+z+'/');x.skinName=z;x.skinPath=A;x.skinClass='cke_skin_'+z;x.tabIndex=x.config.tabIndex||x.element.getAttribute('tabindex')||0;x.readOnly=!!(x.config.readOnly||x.element.getAttribute('disabled'));x.fireOnce('configLoaded');t(x);},r=function(x){a.lang.load(x.config.language,x.config.defaultLanguage,function(y,z){x.langCode=y;x.lang=e.prototypedCopy(z);if(b.gecko&&b.version<10900&&x.lang.dir=='rtl')x.lang.dir='ltr';x.fire('langLoaded');var A=x.config;A.contentsLangDirection=='ui'&&(A.contentsLangDirection=x.lang.dir);s(x);});},s=function(x){var y=x.config,z=y.plugins,A=y.extraPlugins,B=y.removePlugins;if(A){var C=new RegExp('(?:^|,)(?:'+A.replace(/\s*,\s*/g,'|')+')(?=,|$)','g');z=z.replace(C,'');
z+=','+A;}if(B){C=new RegExp('(?:^|,)(?:'+B.replace(/\s*,\s*/g,'|')+')(?=,|$)','g');z=z.replace(C,'');}b.air&&(z+=',adobeair');j.load(z.split(','),function(D){var E=[],F=[],G=[];x.plugins=D;for(var H in D){var I=D[H],J=I.lang,K=j.getPath(H),L=null;I.path=K;if(J){L=e.indexOf(J,x.langCode)>=0?x.langCode:J[0];if(!I.langEntries||!I.langEntries[L])G.push(a.getUrl(K+'lang/'+L+'.js'));else{e.extend(x.lang,I.langEntries[L]);L=null;}}F.push(L);E.push(I);}a.scriptLoader.load(G,function(){var M=['beforeInit','init','afterInit'];for(var N=0;N<M.length;N++)for(var O=0;O<E.length;O++){var P=E[O];if(N===0&&F[O]&&P.lang)e.extend(x.lang,P.langEntries[F[O]]);if(P[M[N]])P[M[N]](x);}x.fire('pluginsLoaded');u(x);});});},t=function(x){a.skins.load(x,'editor',function(){r(x);});},u=function(x){var y=x.config.theme;a.themes.load(y,function(){var z=x.theme=a.themes.get(y);z.path=a.themes.getPath(y);z.build(x);if(x.config.autoUpdateElement)v(x);});},v=function(x){var y=x.element;if(x.elementMode==1&&y.is('textarea')){var z=y.$.form&&new h(y.$.form);if(z){function A(){x.updateElement();};z.on('submit',A);if(!z.$.submit.nodeName&&!z.$.submit.length)z.$.submit=e.override(z.$.submit,function(B){return function(){x.updateElement();if(B.apply)B.apply(this,arguments);else B();};});x.on('destroy',function(){z.removeListener('submit',A);});}}};function w(){var x,y=this._.commands,z=this.mode;if(!z)return;for(var A in y){x=y[A];x[x.startDisabled?'disable':this.readOnly&&!x.readOnly?'disable':x.modes[z]?'enable':'disable']();}};a.editor.prototype._init=function(){var z=this;var x=h.get(z._.element),y=z._.instanceConfig;delete z._.element;delete z._.instanceConfig;z._.commands={};z._.styles=[];z.element=x;z.name=x&&z.elementMode==1&&(x.getId()||x.getNameAtt())||m();if(z.name in a.instances)throw '[CKEDITOR.editor] The instance "'+z.name+'" already exists.';z.id=e.getNextId();z.config=e.prototypedCopy(i);z.ui=new k(z);z.focusManager=new a.focusManager(z);a.fire('instanceCreated',null,z);z.on('mode',w,null,null,1);z.on('readOnly',w,null,null,1);p(z,y);};})();e.extend(a.editor.prototype,{addCommand:function(l,m){return this._.commands[l]=new a.command(this,m);},addCss:function(l){this._.styles.push(l);},destroy:function(l){var m=this;if(!l)m.updateElement();m.fire('destroy');m.theme&&m.theme.destroy(m);a.remove(m);a.fire('instanceDestroyed',null,m);},execCommand:function(l,m){var n=this.getCommand(l),o={name:l,commandData:m,command:n};if(n&&n.state!=0)if(this.fire('beforeCommandExec',o)!==true){o.returnValue=n.exec(o.commandData);
if(!n.async&&this.fire('afterCommandExec',o)!==true)return o.returnValue;}return false;},getCommand:function(l){return this._.commands[l];},getData:function(){var n=this;n.fire('beforeGetData');var l=n._.data;if(typeof l!='string'){var m=n.element;if(m&&n.elementMode==1)l=m.is('textarea')?m.getValue():m.getHtml();else l='';}l={dataValue:l};n.fire('getData',l);return l.dataValue;},getSnapshot:function(){var l=this.fire('getSnapshot');if(typeof l!='string'){var m=this.element;if(m&&this.elementMode==1)l=m.is('textarea')?m.getValue():m.getHtml();}return l;},loadSnapshot:function(l){this.fire('loadSnapshot',l);},setData:function(l,m,n){if(m)this.on('dataReady',function(p){p.removeListener();m.call(p.editor);});var o={dataValue:l};!n&&this.fire('setData',o);this._.data=o.dataValue;!n&&this.fire('afterSetData',o);},setReadOnly:function(l){l=l==undefined||l;if(this.readOnly!=l){this.readOnly=l;this.fire('readOnly');}},insertHtml:function(l){this.fire('insertHtml',l);},insertText:function(l){this.fire('insertText',l);},insertElement:function(l){this.fire('insertElement',l);},checkDirty:function(){return this.mayBeDirty&&this._.previousValue!==this.getSnapshot();},resetDirty:function(){if(this.mayBeDirty)this._.previousValue=this.getSnapshot();},updateElement:function(){var n=this;var l=n.element;if(l&&n.elementMode==1){var m=n.getData();if(n.config.htmlEncodeOutput)m=e.htmlEncode(m);if(l.is('textarea'))l.setValue(m);else l.setHtml(m);}}});a.on('loaded',function(){var l=a.editor._pending;if(l){delete a.editor._pending;for(var m=0;m<l.length;m++)l[m]._init();}});a.htmlParser=function(){this._={htmlPartsRegex:new RegExp("<(?:(?:\\/([^>]+)>)|(?:!--([\\S|\\s]*?)-->)|(?:([^\\s>]+)\\s*((?:(?:\"[^\"]*\")|(?:'[^']*')|[^\"'>])*)\\/?>))",'g')};};(function(){var l=/([\w\-:.]+)(?:(?:\s*=\s*(?:(?:"([^"]*)")|(?:'([^']*)')|([^\s>]+)))|(?=\s|$))/g,m={checked:1,compact:1,declare:1,defer:1,disabled:1,ismap:1,multiple:1,nohref:1,noresize:1,noshade:1,nowrap:1,readonly:1,selected:1};a.htmlParser.prototype={onTagOpen:function(){},onTagClose:function(){},onText:function(){},onCDATA:function(){},onComment:function(){},parse:function(n){var A=this;var o,p,q=0,r;while(o=A._.htmlPartsRegex.exec(n)){var s=o.index;if(s>q){var t=n.substring(q,s);if(r)r.push(t);else A.onText(t);}q=A._.htmlPartsRegex.lastIndex;if(p=o[1]){p=p.toLowerCase();if(r&&f.$cdata[p]){A.onCDATA(r.join(''));r=null;}if(!r){A.onTagClose(p);continue;}}if(r){r.push(o[0]);continue;}if(p=o[3]){p=p.toLowerCase();if(/="/.test(p))continue;
var u={},v,w=o[4],x=!!(w&&w.charAt(w.length-1)=='/');if(w)while(v=l.exec(w)){var y=v[1].toLowerCase(),z=v[2]||v[3]||v[4]||'';if(!z&&m[y])u[y]=y;else u[y]=z;}A.onTagOpen(p,u,x);if(!r&&f.$cdata[p])r=[];continue;}if(p=o[2])A.onComment(p);}if(n.length>q)A.onText(n.substring(q,n.length));}};})();a.htmlParser.comment=function(l){this.value=l;this._={isBlockLike:false};};a.htmlParser.comment.prototype={type:8,writeHtml:function(l,m){var n=this.value;if(m){if(!(n=m.onComment(n,this)))return;if(typeof n!='string'){n.parent=this.parent;n.writeHtml(l,m);return;}}l.comment(n);}};(function(){a.htmlParser.text=function(l){this.value=l;this._={isBlockLike:false};};a.htmlParser.text.prototype={type:3,writeHtml:function(l,m){var n=this.value;if(m&&!(n=m.onText(n,this)))return;l.text(n);}};})();(function(){a.htmlParser.cdata=function(l){this.value=l;};a.htmlParser.cdata.prototype={type:3,writeHtml:function(l){l.write(this.value);}};})();a.htmlParser.fragment=function(){this.children=[];this.parent=null;this._={isBlockLike:true,hasInlineStarted:false};};(function(){var l=e.extend({table:1,ul:1,ol:1,dl:1},f.table,f.ul,f.ol,f.dl),m=c&&b.version<8?{dd:1,dt:1}:{},n={ol:1,ul:1},o=e.extend({},{html:1},f.html,f.body,f.head,{style:1,script:1});function p(q){return q.name=='a'&&q.attributes.href||f.$removeEmpty[q.name];};a.htmlParser.fragment.fromHtml=function(q,r,s){var t=new a.htmlParser(),u=s||new a.htmlParser.fragment(),v=[],w=[],x=u,y=false,z=false;function A(D){var E;if(v.length>0)for(var F=0;F<v.length;F++){var G=v[F],H=G.name,I=f[H],J=x.name&&f[x.name];if((!J||J[H])&&(!D||!I||I[D]||!f[D])){if(!E){B();E=1;}G=G.clone();G.parent=x;x=G;v.splice(F,1);F--;}else if(H==x.name)C(x,x.parent,1),F--;}};function B(){while(w.length)C(w.shift(),x);};function C(D,E,F){if(D.previous!==undefined)return;E=E||x||u;var G=x;if(r&&(!E.type||E.name=='body')){var H,I;if(D.attributes&&(I=D.attributes['data-cke-real-element-type']))H=I;else H=D.name;if(H&&!(H in f.$body||H=='body'||D.isOrphan)){x=E;t.onTagOpen(r,{});D.returnPoint=E=x;}}if(D._.isBlockLike&&D.name!='pre'&&D.name!='textarea'){var J=D.children.length,K=D.children[J-1],L;if(K&&K.type==3)if(!(L=e.rtrim(K.value)))D.children.length=J-1;else K.value=L;}E.add(D);if(D.name=='pre')z=false;if(D.name=='textarea')y=false;if(D.returnPoint){x=D.returnPoint;delete D.returnPoint;}else x=F?E:G;};t.onTagOpen=function(D,E,F,G){var H=new a.htmlParser.element(D,E);if(H.isUnknown&&F)H.isEmpty=true;H.isOptionalClose=D in m||G;if(p(H)){v.push(H);return;}else if(D=='pre')z=true;
else if(D=='br'&&z){x.add(new a.htmlParser.text('\n'));return;}else if(D=='textarea')y=true;if(D=='br'){w.push(H);return;}while(1){var I=x.name,J=I?f[I]||(x._.isBlockLike?f.div:f.span):o;if(!H.isUnknown&&!x.isUnknown&&!J[D]){if(x.isOptionalClose)t.onTagClose(I);else if(D in n&&I in n){var K=x.children,L=K[K.length-1];if(!(L&&L.name=='li'))C(L=new a.htmlParser.element('li'),x);!H.returnPoint&&(H.returnPoint=x);x=L;}else if(D in f.$listItem&&I!=D)t.onTagOpen(D=='li'?'ul':'dl',{},0,1);else if(I in l&&I!=D){!H.returnPoint&&(H.returnPoint=x);x=x.parent;}else{if(I in f.$inline)v.unshift(x);if(x.parent)C(x,x.parent,1);else{H.isOrphan=1;break;}}}else break;}A(D);B();H.parent=x;if(H.isEmpty)C(H);else x=H;};t.onTagClose=function(D){for(var E=v.length-1;E>=0;E--){if(D==v[E].name){v.splice(E,1);return;}}var F=[],G=[],H=x;while(H!=u&&H.name!=D){if(!H._.isBlockLike)G.unshift(H);F.push(H);H=H.returnPoint||H.parent;}if(H!=u){for(E=0;E<F.length;E++){var I=F[E];C(I,I.parent);}x=H;if(H._.isBlockLike)B();C(H,H.parent);if(H==x)x=x.parent;v=v.concat(G);}if(D=='body')r=false;};t.onText=function(D){if((!x._.hasInlineStarted||w.length)&&!z&&!y){D=e.ltrim(D);if(D.length===0)return;}var E=x.name,F=E?f[E]||(x._.isBlockLike?f.div:f.span):o;if(!y&&!F['#']&&E in l){t.onTagOpen(E in n?'li':E=='dl'?'dd':E=='table'?'tr':E=='tr'?'td':'');t.onText(D);return;}B();A();if(r&&(!x.type||x.name=='body')&&e.trim(D))this.onTagOpen(r,{},0,1);if(!z&&!y)D=D.replace(/[\t\r\n ]{2,}|[\t\r\n]/g,' ');x.add(new a.htmlParser.text(D));};t.onCDATA=function(D){x.add(new a.htmlParser.cdata(D));};t.onComment=function(D){B();A();x.add(new a.htmlParser.comment(D));};t.parse(q);B(!c&&1);while(x!=u)C(x,x.parent,1);return u;};a.htmlParser.fragment.prototype={add:function(q,r){var t=this;isNaN(r)&&(r=t.children.length);var s=r>0?t.children[r-1]:null;if(s){if(q._.isBlockLike&&s.type==3){s.value=e.rtrim(s.value);if(s.value.length===0){t.children.pop();t.add(q);return;}}s.next=q;}q.previous=s;q.parent=t;t.children.splice(r,0,q);t._.hasInlineStarted=q.type==3||q.type==1&&!q._.isBlockLike;},writeHtml:function(q,r){var s;this.filterChildren=function(){var t=new a.htmlParser.basicWriter();this.writeChildrenHtml.call(this,t,r,true);var u=t.getHtml();this.children=new a.htmlParser.fragment.fromHtml(u).children;s=1;};!this.name&&r&&r.onFragment(this);this.writeChildrenHtml(q,s?null:r);},writeChildrenHtml:function(q,r){for(var s=0;s<this.children.length;s++)this.children[s].writeHtml(q,r);}};})();a.htmlParser.element=function(l,m){var q=this;
q.name=l;q.attributes=m||{};q.children=[];var n=l||'',o=n.match(/^cke:(.*)/);o&&(n=o[1]);var p=!!(f.$nonBodyContent[n]||f.$block[n]||f.$listItem[n]||f.$tableContent[n]||f.$nonEditable[n]||n=='br');q.isEmpty=!!f.$empty[l];q.isUnknown=!f[l];q._={isBlockLike:p,hasInlineStarted:q.isEmpty||!p};};a.htmlParser.cssStyle=function(){var l,m=arguments[0],n={};l=m instanceof a.htmlParser.element?m.attributes.style:m;(l||'').replace(/&quot;/g,'"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g,function(o,p,q){p=='font-family'&&(q=q.replace(/["']/g,''));n[p.toLowerCase()]=q;});return{rules:n,populate:function(o){var p=this.toString();if(p)o instanceof h?o.setAttribute('style',p):o instanceof a.htmlParser.element?o.attributes.style=p:o.style=p;},'toString':function(){var o=[];for(var p in n)n[p]&&o.push(p,':',n[p],';');return o.join('');}};};(function(){var l=function(m,n){m=m[0];n=n[0];return m<n?-1:m>n?1:0;};a.htmlParser.element.prototype={type:1,add:a.htmlParser.fragment.prototype.add,clone:function(){return new a.htmlParser.element(this.name,this.attributes);},writeHtml:function(m,n){var o=this.attributes,p=this,q=p.name,r,s,t,u;p.filterChildren=function(){if(!u){var B=new a.htmlParser.basicWriter();a.htmlParser.fragment.prototype.writeChildrenHtml.call(p,B,n);p.children=new a.htmlParser.fragment.fromHtml(B.getHtml(),0,p.clone()).children;u=1;}};if(n){for(;;){if(!(q=n.onElementName(q)))return;p.name=q;if(!(p=n.onElement(p)))return;p.parent=this.parent;if(p.name==q)break;if(p.type!=1){p.writeHtml(m,n);return;}q=p.name;if(!q){for(var v=0,w=this.children.length;v<w;v++)this.children[v].parent=p.parent;this.writeChildrenHtml.call(p,m,u?null:n);return;}}o=p.attributes;}m.openTag(q,o);var x=[];for(var y=0;y<2;y++)for(r in o){s=r;t=o[r];if(y==1)x.push([r,t]);else if(n){for(;;){if(!(s=n.onAttributeName(r))){delete o[r];break;}else if(s!=r){delete o[r];r=s;continue;}else break;}if(s)if((t=n.onAttribute(p,s,t))===false)delete o[s];else o[s]=t;}}if(m.sortAttributes)x.sort(l);var z=x.length;for(y=0;y<z;y++){var A=x[y];m.attribute(A[0],A[1]);}m.openTagClose(q,p.isEmpty);if(!p.isEmpty){this.writeChildrenHtml.call(p,m,u?null:n);m.closeTag(q);}},writeChildrenHtml:function(m,n){a.htmlParser.fragment.prototype.writeChildrenHtml.apply(this,arguments);}};})();(function(){a.htmlParser.filter=e.createClass({$:function(q){this._={elementNames:[],attributeNames:[],elements:{$length:0},attributes:{$length:0}};if(q)this.addRules(q,10);},proto:{addRules:function(q,r){var s=this;if(typeof r!='number')r=10;
m(s._.elementNames,q.elementNames,r);m(s._.attributeNames,q.attributeNames,r);n(s._.elements,q.elements,r);n(s._.attributes,q.attributes,r);s._.text=o(s._.text,q.text,r)||s._.text;s._.comment=o(s._.comment,q.comment,r)||s._.comment;s._.root=o(s._.root,q.root,r)||s._.root;},onElementName:function(q){return l(q,this._.elementNames);},onAttributeName:function(q){return l(q,this._.attributeNames);},onText:function(q){var r=this._.text;return r?r.filter(q):q;},onComment:function(q,r){var s=this._.comment;return s?s.filter(q,r):q;},onFragment:function(q){var r=this._.root;return r?r.filter(q):q;},onElement:function(q){var v=this;var r=[v._.elements['^'],v._.elements[q.name],v._.elements.$],s,t;for(var u=0;u<3;u++){s=r[u];if(s){t=s.filter(q,v);if(t===false)return null;if(t&&t!=q)return v.onNode(t);if(q.parent&&!q.name)break;}}return q;},onNode:function(q){var r=q.type;return r==1?this.onElement(q):r==3?new a.htmlParser.text(this.onText(q.value)):r==8?new a.htmlParser.comment(this.onComment(q.value)):null;},onAttribute:function(q,r,s){var t=this._.attributes[r];if(t){var u=t.filter(s,q,this);if(u===false)return false;if(typeof u!='undefined')return u;}return s;}}});function l(q,r){for(var s=0;q&&s<r.length;s++){var t=r[s];q=q.replace(t[0],t[1]);}return q;};function m(q,r,s){if(typeof r=='function')r=[r];var t,u,v=q.length,w=r&&r.length;if(w){for(t=0;t<v&&q[t].pri<s;t++){}for(u=w-1;u>=0;u--){var x=r[u];if(x){x.pri=s;q.splice(t,0,x);}}}};function n(q,r,s){if(r)for(var t in r){var u=q[t];q[t]=o(u,r[t],s);if(!u)q.$length++;}};function o(q,r,s){if(r){r.pri=s;if(q){if(!q.splice){if(q.pri>s)q=[r,q];else q=[q,r];q.filter=p;}else m(q,r,s);return q;}else{r.filter=r;return r;}}};function p(q){var r=q.type||q instanceof a.htmlParser.fragment;for(var s=0;s<this.length;s++){if(r)var t=q.type,u=q.name;var v=this[s],w=v.apply(window,arguments);if(w===false)return w;if(r){if(w&&(w.name!=u||w.type!=t))return w;}else if(typeof w!='string')return w;w!=undefined&&(q=w);}return q;};})();a.htmlParser.basicWriter=e.createClass({$:function(){this._={output:[]};},proto:{openTag:function(l,m){this._.output.push('<',l);},openTagClose:function(l,m){if(m)this._.output.push(' />');else this._.output.push('>');},attribute:function(l,m){if(typeof m=='string')m=e.htmlEncodeAttr(m);this._.output.push(' ',l,'="',m,'"');},closeTag:function(l){this._.output.push('</',l,'>');},text:function(l){this._.output.push(l);},comment:function(l){this._.output.push('<!--',l,'-->');},write:function(l){this._.output.push(l);
},reset:function(){this._.output=[];this._.indent=false;},getHtml:function(l){var m=this._.output.join('');if(l)this.reset();return m;}}});delete a.loadFullCore;a.instances={};a.document=new g(document);a.add=function(l){a.instances[l.name]=l;l.on('focus',function(){if(a.currentInstance!=l){a.currentInstance=l;a.fire('currentInstance');}});l.on('blur',function(){if(a.currentInstance==l){a.currentInstance=null;a.fire('currentInstance');}});};a.remove=function(l){delete a.instances[l.name];};a.on('instanceDestroyed',function(){if(e.isEmpty(this.instances))a.fire('reset');});a.TRISTATE_ON=1;a.TRISTATE_OFF=2;a.TRISTATE_DISABLED=0;d.comment=function(l,m){if(typeof l=='string')l=(m?m.$:document).createComment(l);d.domObject.call(this,l);};d.comment.prototype=new d.node();e.extend(d.comment.prototype,{type:8,getOuterHtml:function(){return '<!--'+this.$.nodeValue+'-->';}});(function(){var l={address:1,blockquote:1,dl:1,h1:1,h2:1,h3:1,h4:1,h5:1,h6:1,p:1,pre:1,li:1,dt:1,dd:1,legend:1,caption:1},m={body:1,div:1,table:1,tbody:1,tr:1,td:1,th:1,form:1,fieldset:1},n=function(o){var p=o.getChildren();for(var q=0,r=p.count();q<r;q++){var s=p.getItem(q);if(s.type==1&&f.$block[s.getName()])return true;}return false;};d.elementPath=function(o){var u=this;var p=null,q=null,r=[],s=o;while(s){if(s.type==1){if(!u.lastElement)u.lastElement=s;var t=s.getName();if(!q){if(!p&&l[t])p=s;if(m[t])if(!p&&t=='div'&&!n(s))p=s;else q=s;}r.push(s);if(t=='body')break;}s=s.getParent();}u.block=p;u.blockLimit=q;u.elements=r;};})();d.elementPath.prototype={compare:function(l){var m=this.elements,n=l&&l.elements;if(!n||m.length!=n.length)return false;for(var o=0;o<m.length;o++){if(!m[o].equals(n[o]))return false;}return true;},contains:function(l){var m=this.elements;for(var n=0;n<m.length;n++){if(m[n].getName() in l)return m[n];}return null;}};d.text=function(l,m){if(typeof l=='string')l=(m?m.$:document).createTextNode(l);this.$=l;};d.text.prototype=new d.node();e.extend(d.text.prototype,{type:3,getLength:function(){return this.$.nodeValue.length;},getText:function(){return this.$.nodeValue;},setText:function(l){this.$.nodeValue=l;},split:function(l){var q=this;if(c&&l==q.getLength()){var m=q.getDocument().createText('');m.insertAfter(q);return m;}var n=q.getDocument(),o=new d.text(q.$.splitText(l),n);if(b.ie8){var p=new d.text('',n);p.insertAfter(o);p.remove();}return o;},substring:function(l,m){if(typeof m!='number')return this.$.nodeValue.substr(l);else return this.$.nodeValue.substring(l,m);}});
d.documentFragment=function(l){l=l||a.document;this.$=l.$.createDocumentFragment();};e.extend(d.documentFragment.prototype,h.prototype,{type:11,insertAfterNode:function(l){l=l.$;l.parentNode.insertBefore(this.$,l.nextSibling);}},true,{append:1,appendBogus:1,getFirst:1,getLast:1,appendTo:1,moveChildren:1,insertBefore:1,insertAfterNode:1,replace:1,trim:1,type:1,ltrim:1,rtrim:1,getDocument:1,getChildCount:1,getChild:1,getChildren:1});(function(){function l(s,t){var u=this.range;if(this._.end)return null;if(!this._.start){this._.start=1;if(u.collapsed){this.end();return null;}u.optimize();}var v,w=u.startContainer,x=u.endContainer,y=u.startOffset,z=u.endOffset,A,B=this.guard,C=this.type,D=s?'getPreviousSourceNode':'getNextSourceNode';if(!s&&!this._.guardLTR){var E=x.type==1?x:x.getParent(),F=x.type==1?x.getChild(z):x.getNext();this._.guardLTR=function(J,K){return(!K||!E.equals(J))&&(!F||!J.equals(F))&&(J.type!=1||!K||J.getName()!='body');};}if(s&&!this._.guardRTL){var G=w.type==1?w:w.getParent(),H=w.type==1?y?w.getChild(y-1):null:w.getPrevious();this._.guardRTL=function(J,K){return(!K||!G.equals(J))&&(!H||!J.equals(H))&&(J.type!=1||!K||J.getName()!='body');};}var I=s?this._.guardRTL:this._.guardLTR;if(B)A=function(J,K){if(I(J,K)===false)return false;return B(J,K);};else A=I;if(this.current)v=this.current[D](false,C,A);else{if(s){v=x;if(v.type==1)if(z>0)v=v.getChild(z-1);else v=A(v,true)===false?null:v.getPreviousSourceNode(true,C,A);}else{v=w;if(v.type==1)if(!(v=v.getChild(y)))v=A(w,true)===false?null:w.getNextSourceNode(true,C,A);}if(v&&A(v)===false)v=null;}while(v&&!this._.end){this.current=v;if(!this.evaluator||this.evaluator(v)!==false){if(!t)return v;}else if(t&&this.evaluator)return false;v=v[D](false,C,A);}this.end();return this.current=null;};function m(s){var t,u=null;while(t=l.call(this,s))u=t;return u;};d.walker=e.createClass({$:function(s){this.range=s;this._={};},proto:{end:function(){this._.end=1;},next:function(){return l.call(this);},previous:function(){return l.call(this,1);},checkForward:function(){return l.call(this,0,1)!==false;},checkBackward:function(){return l.call(this,1,1)!==false;},lastForward:function(){return m.call(this);},lastBackward:function(){return m.call(this,1);},reset:function(){delete this.current;this._={};}}});var n={block:1,'list-item':1,table:1,'table-row-group':1,'table-header-group':1,'table-footer-group':1,'table-row':1,'table-column-group':1,'table-column':1,'table-cell':1,'table-caption':1};h.prototype.isBlockBoundary=function(s){var t=s?e.extend({},f.$block,s||{}):f.$block;
return this.getComputedStyle('float')=='none'&&n[this.getComputedStyle('display')]||t[this.getName()];};d.walker.blockBoundary=function(s){return function(t,u){return!(t.type==1&&t.isBlockBoundary(s));};};d.walker.listItemBoundary=function(){return this.blockBoundary({br:1});};d.walker.bookmark=function(s,t){function u(v){return v&&v.getName&&v.getName()=='span'&&v.data('cke-bookmark');};return function(v){var w,x;w=v&&!v.getName&&(x=v.getParent())&&u(x);w=s?w:w||u(v);return!!(t^w);};};d.walker.whitespaces=function(s){return function(t){var u;if(t&&t.type==3)u=!e.trim(t.getText())||b.webkit&&t.getText()=='​';return!!(s^u);};};d.walker.invisible=function(s){var t=d.walker.whitespaces();return function(u){var v;if(t(u))v=1;else{if(u.type==3)u=u.getParent();v=!u.$.offsetHeight;}return!!(s^v);};};d.walker.nodeType=function(s,t){return function(u){return!!(t^u.type==s);};};d.walker.bogus=function(s){function t(u){return!p(u)&&!q(u);};return function(u){var v=!c?u.is&&u.is('br'):u.getText&&o.test(u.getText());if(v){var w=u.getParent(),x=u.getNext(t);v=w.isBlockBoundary()&&(!x||x.type==1&&x.isBlockBoundary());}return!!(s^v);};};var o=/^[\t\r\n ]*(?:&nbsp;|\xa0)$/,p=d.walker.whitespaces(),q=d.walker.bookmark(),r=function(s){return q(s)||p(s)||s.type==1&&s.getName() in f.$inline&&!(s.getName() in f.$empty);};h.prototype.getBogus=function(){var s=this;do s=s.getPreviousSourceNode();while(r(s));if(s&&(!c?s.is&&s.is('br'):s.getText&&o.test(s.getText())))return s;return false;};})();d.range=function(l){var m=this;m.startContainer=null;m.startOffset=null;m.endContainer=null;m.endOffset=null;m.collapsed=true;m.document=l;};(function(){var l=function(v){v.collapsed=v.startContainer&&v.endContainer&&v.startContainer.equals(v.endContainer)&&v.startOffset==v.endOffset;},m=function(v,w,x,y){v.optimizeBookmark();var z=v.startContainer,A=v.endContainer,B=v.startOffset,C=v.endOffset,D,E;if(A.type==3)A=A.split(C);else if(A.getChildCount()>0)if(C>=A.getChildCount()){A=A.append(v.document.createText(''));E=true;}else A=A.getChild(C);if(z.type==3){z.split(B);if(z.equals(A))A=z.getNext();}else if(!B){z=z.getFirst().insertBeforeMe(v.document.createText(''));D=true;}else if(B>=z.getChildCount()){z=z.append(v.document.createText(''));D=true;}else z=z.getChild(B).getPrevious();var F=z.getParents(),G=A.getParents(),H,I,J;for(H=0;H<F.length;H++){I=F[H];J=G[H];if(!I.equals(J))break;}var K=x,L,M,N,O;for(var P=H;P<F.length;P++){L=F[P];if(K&&!L.equals(z))M=K.append(L.clone());N=L.getNext();while(N){if(N.equals(G[P])||N.equals(A))break;
O=N.getNext();if(w==2)K.append(N.clone(true));else{N.remove();if(w==1)K.append(N);}N=O;}if(K)K=M;}K=x;for(var Q=H;Q<G.length;Q++){L=G[Q];if(w>0&&!L.equals(A))M=K.append(L.clone());if(!F[Q]||L.$.parentNode!=F[Q].$.parentNode){N=L.getPrevious();while(N){if(N.equals(F[Q])||N.equals(z))break;O=N.getPrevious();if(w==2)K.$.insertBefore(N.$.cloneNode(true),K.$.firstChild);else{N.remove();if(w==1)K.$.insertBefore(N.$,K.$.firstChild);}N=O;}}if(K)K=M;}if(w==2){var R=v.startContainer;if(R.type==3){R.$.data+=R.$.nextSibling.data;R.$.parentNode.removeChild(R.$.nextSibling);}var S=v.endContainer;if(S.type==3&&S.$.nextSibling){S.$.data+=S.$.nextSibling.data;S.$.parentNode.removeChild(S.$.nextSibling);}}else{if(I&&J&&(z.$.parentNode!=I.$.parentNode||A.$.parentNode!=J.$.parentNode)){var T=J.getIndex();if(D&&J.$.parentNode==z.$.parentNode)T--;if(y&&I.type==1){var U=h.createFromHtml('<span data-cke-bookmark="1" style="display:none">&nbsp;</span>',v.document);U.insertAfter(I);I.mergeSiblings(false);v.moveToBookmark({startNode:U});}else v.setStart(J.getParent(),T);}v.collapse(true);}if(D)z.remove();if(E&&A.$.parentNode)A.remove();},n={abbr:1,acronym:1,b:1,bdo:1,big:1,cite:1,code:1,del:1,dfn:1,em:1,font:1,i:1,ins:1,label:1,kbd:1,q:1,samp:1,small:1,span:1,strike:1,strong:1,sub:1,sup:1,tt:1,u:1,'var':1};function o(){var v=false,w=d.walker.whitespaces(),x=d.walker.bookmark(true),y=d.walker.bogus();return function(z){if(x(z)||w(z))return true;if(y(z)&&!v){v=true;return true;}if(z.type==3&&(z.hasAscendant('pre')||e.trim(z.getText()).length))return false;if(z.type==1&&!n[z.getName()])return false;return true;};};var p=d.walker.bogus();function q(v){var w=d.walker.whitespaces(),x=d.walker.bookmark(1);return function(y){if(x(y)||w(y))return true;return!v&&p(y)||y.type==1&&y.getName() in f.$removeEmpty;};};var r=new d.walker.whitespaces(),s=new d.walker.bookmark(),t=/^[\t\r\n ]*(?:&nbsp;|\xa0)$/;function u(v){return!r(v)&&!s(v);};d.range.prototype={clone:function(){var w=this;var v=new d.range(w.document);v.startContainer=w.startContainer;v.startOffset=w.startOffset;v.endContainer=w.endContainer;v.endOffset=w.endOffset;v.collapsed=w.collapsed;return v;},collapse:function(v){var w=this;if(v){w.endContainer=w.startContainer;w.endOffset=w.startOffset;}else{w.startContainer=w.endContainer;w.startOffset=w.endOffset;}w.collapsed=true;},cloneContents:function(){var v=new d.documentFragment(this.document);if(!this.collapsed)m(this,2,v);return v;},deleteContents:function(v){if(this.collapsed)return;
m(this,0,null,v);},extractContents:function(v){var w=new d.documentFragment(this.document);if(!this.collapsed)m(this,1,w,v);return w;},createBookmark:function(v){var B=this;var w,x,y,z,A=B.collapsed;w=B.document.createElement('span');w.data('cke-bookmark',1);w.setStyle('display','none');w.setHtml('&nbsp;');if(v){y='cke_bm_'+e.getNextNumber();w.setAttribute('id',y+(A?'C':'S'));}if(!A){x=w.clone();x.setHtml('&nbsp;');if(v)x.setAttribute('id',y+'E');z=B.clone();z.collapse();z.insertNode(x);}z=B.clone();z.collapse(true);z.insertNode(w);if(x){B.setStartAfter(w);B.setEndBefore(x);}else B.moveToPosition(w,4);return{startNode:v?y+(A?'C':'S'):w,endNode:v?y+'E':x,serializable:v,collapsed:A};},createBookmark2:function(v){var D=this;var w=D.startContainer,x=D.endContainer,y=D.startOffset,z=D.endOffset,A=D.collapsed,B,C;if(!w||!x)return{start:0,end:0};if(v){if(w.type==1){B=w.getChild(y);if(B&&B.type==3&&y>0&&B.getPrevious().type==3){w=B;y=0;}if(B&&B.type==1)y=B.getIndex(1);}while(w.type==3&&(C=w.getPrevious())&&C.type==3){w=C;y+=C.getLength();}if(!A){if(x.type==1){B=x.getChild(z);if(B&&B.type==3&&z>0&&B.getPrevious().type==3){x=B;z=0;}if(B&&B.type==1)z=B.getIndex(1);}while(x.type==3&&(C=x.getPrevious())&&C.type==3){x=C;z+=C.getLength();}}}return{start:w.getAddress(v),end:A?null:x.getAddress(v),startOffset:y,endOffset:z,normalized:v,collapsed:A,is2:true};},moveToBookmark:function(v){var D=this;if(v.is2){var w=D.document.getByAddress(v.start,v.normalized),x=v.startOffset,y=v.end&&D.document.getByAddress(v.end,v.normalized),z=v.endOffset;D.setStart(w,x);if(y)D.setEnd(y,z);else D.collapse(true);}else{var A=v.serializable,B=A?D.document.getById(v.startNode):v.startNode,C=A?D.document.getById(v.endNode):v.endNode;D.setStartBefore(B);B.remove();if(C){D.setEndBefore(C);C.remove();}else D.collapse(true);}},getBoundaryNodes:function(){var A=this;var v=A.startContainer,w=A.endContainer,x=A.startOffset,y=A.endOffset,z;if(v.type==1){z=v.getChildCount();if(z>x)v=v.getChild(x);else if(z<1)v=v.getPreviousSourceNode();else{v=v.$;while(v.lastChild)v=v.lastChild;v=new d.node(v);v=v.getNextSourceNode()||v;}}if(w.type==1){z=w.getChildCount();if(z>y)w=w.getChild(y).getPreviousSourceNode(true);else if(z<1)w=w.getPreviousSourceNode();else{w=w.$;while(w.lastChild)w=w.lastChild;w=new d.node(w);}}if(v.getPosition(w)&2)v=w;return{startNode:v,endNode:w};},getCommonAncestor:function(v,w){var A=this;var x=A.startContainer,y=A.endContainer,z;if(x.equals(y)){if(v&&x.type==1&&A.startOffset==A.endOffset-1)z=x.getChild(A.startOffset);
else z=x;}else z=x.getCommonAncestor(y);return w&&!z.is?z.getParent():z;},optimize:function(){var x=this;var v=x.startContainer,w=x.startOffset;if(v.type!=1)if(!w)x.setStartBefore(v);else if(w>=v.getLength())x.setStartAfter(v);v=x.endContainer;w=x.endOffset;if(v.type!=1)if(!w)x.setEndBefore(v);else if(w>=v.getLength())x.setEndAfter(v);},optimizeBookmark:function(){var x=this;var v=x.startContainer,w=x.endContainer;if(v.is&&v.is('span')&&v.data('cke-bookmark'))x.setStartAt(v,3);if(w&&w.is&&w.is('span')&&w.data('cke-bookmark'))x.setEndAt(w,4);},trim:function(v,w){var D=this;var x=D.startContainer,y=D.startOffset,z=D.collapsed;if((!v||z)&&x&&x.type==3){if(!y){y=x.getIndex();x=x.getParent();}else if(y>=x.getLength()){y=x.getIndex()+1;x=x.getParent();}else{var A=x.split(y);y=x.getIndex()+1;x=x.getParent();if(D.startContainer.equals(D.endContainer))D.setEnd(A,D.endOffset-D.startOffset);else if(x.equals(D.endContainer))D.endOffset+=1;}D.setStart(x,y);if(z){D.collapse(true);return;}}var B=D.endContainer,C=D.endOffset;if(!(w||z)&&B&&B.type==3){if(!C){C=B.getIndex();B=B.getParent();}else if(C>=B.getLength()){C=B.getIndex()+1;B=B.getParent();}else{B.split(C);C=B.getIndex()+1;B=B.getParent();}D.setEnd(B,C);}},enlarge:function(v,w){switch(v){case 1:if(this.collapsed)return;var x=this.getCommonAncestor(),y=this.document.getBody(),z,A,B,C,D,E=false,F,G,H=this.startContainer,I=this.startOffset;if(H.type==3){if(I){H=!e.trim(H.substring(0,I)).length&&H;E=!!H;}if(H)if(!(C=H.getPrevious()))B=H.getParent();}else{if(I)C=H.getChild(I-1)||H.getLast();if(!C)B=H;}while(B||C){if(B&&!C){if(!D&&B.equals(x))D=true;if(!y.contains(B))break;if(!E||B.getComputedStyle('display')!='inline'){E=false;if(D)z=B;else this.setStartBefore(B);}C=B.getPrevious();}while(C){F=false;if(C.type==8){C=C.getPrevious();continue;}else if(C.type==3){G=C.getText();if(/[^\s\ufeff]/.test(G))C=null;F=/[\s\ufeff]$/.test(G);}else if((C.$.offsetWidth>0||w&&C.is('br'))&&!C.data('cke-bookmark'))if(E&&f.$removeEmpty[C.getName()]){G=C.getText();if(/[^\s\ufeff]/.test(G))C=null;else{var J=C.$.getElementsByTagName('*');for(var K=0,L;L=J[K++];){if(!f.$removeEmpty[L.nodeName.toLowerCase()]){C=null;break;}}}if(C)F=!!G.length;}else C=null;if(F)if(E){if(D)z=B;else if(B)this.setStartBefore(B);}else E=true;if(C){var M=C.getPrevious();if(!B&&!M){B=C;C=null;break;}C=M;}else B=null;}if(B)B=B.getParent();}H=this.endContainer;I=this.endOffset;B=C=null;D=E=false;if(H.type==3){H=!e.trim(H.substring(I)).length&&H;E=!(H&&H.getLength());if(H)if(!(C=H.getNext()))B=H.getParent();
}else{C=H.getChild(I);if(!C)B=H;}while(B||C){if(B&&!C){if(!D&&B.equals(x))D=true;if(!y.contains(B))break;if(!E||B.getComputedStyle('display')!='inline'){E=false;if(D)A=B;else if(B)this.setEndAfter(B);}C=B.getNext();}while(C){F=false;if(C.type==3){G=C.getText();if(/[^\s\ufeff]/.test(G))C=null;F=/^[\s\ufeff]/.test(G);}else if(C.type==1){if((C.$.offsetWidth>0||w&&C.is('br'))&&!C.data('cke-bookmark'))if(E&&f.$removeEmpty[C.getName()]){G=C.getText();if(/[^\s\ufeff]/.test(G))C=null;else{J=C.$.getElementsByTagName('*');for(K=0;L=J[K++];){if(!f.$removeEmpty[L.nodeName.toLowerCase()]){C=null;break;}}}if(C)F=!!G.length;}else C=null;}else F=1;if(F)if(E)if(D)A=B;else this.setEndAfter(B);if(C){M=C.getNext();if(!B&&!M){B=C;C=null;break;}C=M;}else B=null;}if(B)B=B.getParent();}if(z&&A){x=z.contains(A)?A:z;this.setStartBefore(x);this.setEndAfter(x);}break;case 2:case 3:var N=new d.range(this.document);y=this.document.getBody();N.setStartAt(y,1);N.setEnd(this.startContainer,this.startOffset);var O=new d.walker(N),P,Q,R=d.walker.blockBoundary(v==3?{br:1}:null),S=function(Y){var Z=R(Y);if(!Z)P=Y;return Z;},T=function(Y){var Z=S(Y);if(!Z&&Y.is&&Y.is('br'))Q=Y;return Z;};O.guard=S;B=O.lastBackward();P=P||y;this.setStartAt(P,!P.is('br')&&(!B&&this.checkStartOfBlock()||B&&P.contains(B))?1:4);if(v==3){var U=this.clone();O=new d.walker(U);var V=d.walker.whitespaces(),W=d.walker.bookmark();O.evaluator=function(Y){return!V(Y)&&!W(Y);};var X=O.previous();if(X&&X.type==1&&X.is('br'))return;}N=this.clone();N.collapse();N.setEndAt(y,2);O=new d.walker(N);O.guard=v==3?T:S;P=null;B=O.lastForward();P=P||y;this.setEndAt(P,!B&&this.checkEndOfBlock()||B&&P.contains(B)?2:3);if(Q)this.setEndAfter(Q);}},shrink:function(v,w){if(!this.collapsed){v=v||2;var x=this.clone(),y=this.startContainer,z=this.endContainer,A=this.startOffset,B=this.endOffset,C=this.collapsed,D=1,E=1;if(y&&y.type==3)if(!A)x.setStartBefore(y);else if(A>=y.getLength())x.setStartAfter(y);else{x.setStartBefore(y);D=0;}if(z&&z.type==3)if(!B)x.setEndBefore(z);else if(B>=z.getLength())x.setEndAfter(z);else{x.setEndAfter(z);E=0;}var F=new d.walker(x),G=d.walker.bookmark();F.evaluator=function(K){return K.type==(v==1?1:3);};var H;F.guard=function(K,L){if(G(K))return true;if(v==1&&K.type==3)return false;if(L&&K.equals(H))return false;if(!L&&K.type==1)H=K;return true;};if(D){var I=F[v==1?'lastForward':'next']();I&&this.setStartAt(I,w?1:3);}if(E){F.reset();var J=F[v==1?'lastBackward':'previous']();J&&this.setEndAt(J,w?2:4);}return!!(D||E);
}},insertNode:function(v){var z=this;z.optimizeBookmark();z.trim(false,true);var w=z.startContainer,x=z.startOffset,y=w.getChild(x);if(y)v.insertBefore(y);else w.append(v);if(v.getParent().equals(z.endContainer))z.endOffset++;z.setStartBefore(v);},moveToPosition:function(v,w){this.setStartAt(v,w);this.collapse(true);},selectNodeContents:function(v){this.setStart(v,0);this.setEnd(v,v.type==3?v.getLength():v.getChildCount());},setStart:function(v,w){var x=this;if(v.type==1&&f.$empty[v.getName()])w=v.getIndex(),v=v.getParent();x.startContainer=v;x.startOffset=w;if(!x.endContainer){x.endContainer=v;x.endOffset=w;}l(x);},setEnd:function(v,w){var x=this;if(v.type==1&&f.$empty[v.getName()])w=v.getIndex()+1,v=v.getParent();x.endContainer=v;x.endOffset=w;if(!x.startContainer){x.startContainer=v;x.startOffset=w;}l(x);},setStartAfter:function(v){this.setStart(v.getParent(),v.getIndex()+1);},setStartBefore:function(v){this.setStart(v.getParent(),v.getIndex());},setEndAfter:function(v){this.setEnd(v.getParent(),v.getIndex()+1);},setEndBefore:function(v){this.setEnd(v.getParent(),v.getIndex());},setStartAt:function(v,w){var x=this;switch(w){case 1:x.setStart(v,0);break;case 2:if(v.type==3)x.setStart(v,v.getLength());else x.setStart(v,v.getChildCount());break;case 3:x.setStartBefore(v);break;case 4:x.setStartAfter(v);}l(x);},setEndAt:function(v,w){var x=this;switch(w){case 1:x.setEnd(v,0);break;case 2:if(v.type==3)x.setEnd(v,v.getLength());else x.setEnd(v,v.getChildCount());break;case 3:x.setEndBefore(v);break;case 4:x.setEndAfter(v);}l(x);},fixBlock:function(v,w){var z=this;var x=z.createBookmark(),y=z.document.createElement(w);z.collapse(v);z.enlarge(2);z.extractContents().appendTo(y);y.trim();if(!c)y.appendBogus();z.insertNode(y);z.moveToBookmark(x);return y;},splitBlock:function(v){var F=this;var w=new d.elementPath(F.startContainer),x=new d.elementPath(F.endContainer),y=w.blockLimit,z=x.blockLimit,A=w.block,B=x.block,C=null;if(!y.equals(z))return null;if(v!='br'){if(!A){A=F.fixBlock(true,v);B=new d.elementPath(F.endContainer).block;}if(!B)B=F.fixBlock(false,v);}var D=A&&F.checkStartOfBlock(),E=B&&F.checkEndOfBlock();F.deleteContents();if(A&&A.equals(B))if(E){C=new d.elementPath(F.startContainer);F.moveToPosition(B,4);B=null;}else if(D){C=new d.elementPath(F.startContainer);F.moveToPosition(A,3);A=null;}else{B=F.splitElement(A);if(!c&&!A.is('ul','ol'))A.appendBogus();}return{previousBlock:A,nextBlock:B,wasStartOfBlock:D,wasEndOfBlock:E,elementPath:C};},splitElement:function(v){var y=this;
if(!y.collapsed)return null;y.setEndAt(v,2);var w=y.extractContents(),x=v.clone(false);w.appendTo(x);x.insertAfter(v);y.moveToPosition(v,4);return x;},checkBoundaryOfElement:function(v,w){var x=w==1,y=this.clone();y.collapse(x);y[x?'setStartAt':'setEndAt'](v,x?1:2);var z=new d.walker(y);z.evaluator=q(x);return z[x?'checkBackward':'checkForward']();},checkStartOfBlock:function(){var B=this;var v=B.startContainer,w=B.startOffset;if(c&&w&&v.type==3){var x=e.ltrim(v.substring(0,w));if(t.test(x))B.trim(0,1);}var y=new d.elementPath(B.startContainer),z=B.clone();z.collapse(true);z.setStartAt(y.block||y.blockLimit,1);var A=new d.walker(z);A.evaluator=o();return A.checkBackward();},checkEndOfBlock:function(){var B=this;var v=B.endContainer,w=B.endOffset;if(c&&v.type==3){var x=e.rtrim(v.substring(w));if(t.test(x))B.trim(1,0);}var y=new d.elementPath(B.endContainer),z=B.clone();z.collapse(false);z.setEndAt(y.block||y.blockLimit,2);var A=new d.walker(z);A.evaluator=o();return A.checkForward();},getPreviousNode:function(v,w,x){var y=this.clone();y.collapse(1);y.setStartAt(x||this.document.getBody(),1);var z=new d.walker(y);z.evaluator=v;z.guard=w;return z.previous();},getNextNode:function(v,w,x){var y=this.clone();y.collapse();y.setEndAt(x||this.document.getBody(),2);var z=new d.walker(y);z.evaluator=v;z.guard=w;return z.next();},checkReadOnly:(function(){function v(w,x){while(w){if(w.type==1)if(w.getAttribute('contentEditable')=='false'&&!w.data('cke-editable'))return 0;else if(w.is('html')||w.getAttribute('contentEditable')=='true'&&(w.contains(x)||w.equals(x)))break;w=w.getParent();}return 1;};return function(){var w=this.startContainer,x=this.endContainer;return!(v(w,x)&&v(x,w));};})(),moveToElementEditablePosition:function(v,w){function x(z,A){var B;if(z.type==1&&z.isEditable(false))B=z[w?'getLast':'getFirst'](u);if(!A&&!B)B=z[w?'getPrevious':'getNext'](u);return B;};if(v.type==1&&!v.isEditable(false)){this.moveToPosition(v,w?4:3);return true;}var y=0;while(v){if(v.type==3){if(w&&this.checkEndOfBlock()&&t.test(v.getText()))this.moveToPosition(v,3);else this.moveToPosition(v,w?4:3);y=1;break;}if(v.type==1)if(v.isEditable()){this.moveToPosition(v,w?2:1);y=1;}else if(w&&v.is('br')&&this.checkEndOfBlock())this.moveToPosition(v,3);v=x(v,y);}return!!y;},moveToElementEditStart:function(v){return this.moveToElementEditablePosition(v);},moveToElementEditEnd:function(v){return this.moveToElementEditablePosition(v,true);},getEnclosedNode:function(){var v=this.clone();v.optimize();
if(v.startContainer.type!=1||v.endContainer.type!=1)return null;var w=new d.walker(v),x=d.walker.bookmark(true),y=d.walker.whitespaces(true),z=function(B){return y(B)&&x(B);};v.evaluator=z;var A=w.next();w.reset();return A&&A.equals(w.previous())?A:null;},getTouchedStartNode:function(){var v=this.startContainer;if(this.collapsed||v.type!=1)return v;return v.getChild(this.startOffset)||v;},getTouchedEndNode:function(){var v=this.endContainer;if(this.collapsed||v.type!=1)return v;return v.getChild(this.endOffset-1)||v;}};})();a.POSITION_AFTER_START=1;a.POSITION_BEFORE_END=2;a.POSITION_BEFORE_START=3;a.POSITION_AFTER_END=4;a.ENLARGE_ELEMENT=1;a.ENLARGE_BLOCK_CONTENTS=2;a.ENLARGE_LIST_ITEM_CONTENTS=3;a.START=1;a.END=2;a.STARTEND=3;a.SHRINK_ELEMENT=1;a.SHRINK_TEXT=2;(function(){d.rangeList=function(n){if(n instanceof d.rangeList)return n;if(!n)n=[];else if(n instanceof d.range)n=[n];return e.extend(n,l);};var l={createIterator:function(){var n=this,o=d.walker.bookmark(),p=function(s){return!(s.is&&s.is('tr'));},q=[],r;return{getNextRange:function(s){r=r==undefined?0:r+1;var t=n[r];if(t&&n.length>1){if(!r)for(var u=n.length-1;u>=0;u--)q.unshift(n[u].createBookmark(true));if(s){var v=0;while(n[r+v+1]){var w=t.document,x=0,y=w.getById(q[v].endNode),z=w.getById(q[v+1].startNode),A;while(1){A=y.getNextSourceNode(false);if(!z.equals(A)){if(o(A)||A.type==1&&A.isBlockBoundary()){y=A;continue;}}else x=1;break;}if(!x)break;v++;}}t.moveToBookmark(q.shift());while(v--){A=n[++r];A.moveToBookmark(q.shift());t.setEnd(A.endContainer,A.endOffset);}}return t;}};},createBookmarks:function(n){var s=this;var o=[],p;for(var q=0;q<s.length;q++){o.push(p=s[q].createBookmark(n,true));for(var r=q+1;r<s.length;r++){s[r]=m(p,s[r]);s[r]=m(p,s[r],true);}}return o;},createBookmarks2:function(n){var o=[];for(var p=0;p<this.length;p++)o.push(this[p].createBookmark2(n));return o;},moveToBookmarks:function(n){for(var o=0;o<this.length;o++)this[o].moveToBookmark(n[o]);}};function m(n,o,p){var q=n.serializable,r=o[p?'endContainer':'startContainer'],s=p?'endOffset':'startOffset',t=q?o.document.getById(n.startNode):n.startNode,u=q?o.document.getById(n.endNode):n.endNode;if(r.equals(t.getPrevious())){o.startOffset=o.startOffset-r.getLength()-u.getPrevious().getLength();r=u.getNext();}else if(r.equals(u.getPrevious())){o.startOffset=o.startOffset-r.getLength();r=u.getNext();}r.equals(t.getParent())&&o[s]++;r.equals(u.getParent())&&o[s]++;o[p?'endContainer':'startContainer']=r;return o;};})();(function(){if(b.webkit){b.hc=false;
return;}var l=h.createFromHtml('<div style="width:0px;height:0px;position:absolute;left:-10000px;border: 1px solid;border-color: red blue;"></div>',a.document);l.appendTo(a.document.getHead());try{b.hc=l.getComputedStyle('border-top-color')==l.getComputedStyle('border-right-color');}catch(m){b.hc=false;}if(b.hc)b.cssClass+=' cke_hc';l.remove();})();j.load(i.corePlugins.split(','),function(){a.status='loaded';a.fire('loaded');var l=a._.pending;if(l){delete a._.pending;for(var m=0;m<l.length;m++)a.add(l[m]);}});if(c)try{document.execCommand('BackgroundImageCache',false,true);}catch(l){}a.skins.add('kama',(function(){var m='cke_ui_color';return{editor:{css:['editor.css']},dialog:{css:['dialog.css']},richcombo:{canGroup:false},templates:{css:['templates.css']},margins:[0,0,0,0],init:function(n){if(n.config.width&&!isNaN(n.config.width))n.config.width-=12;var o=[],p=/\$color/g,q='/* UI Color Support */.cke_skin_kama .cke_menuitem .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_label,.cke_skin_kama .cke_menuitem a:focus .cke_label,.cke_skin_kama .cke_menuitem a:active .cke_label{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_label{\tbackground-color: transparent !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuseparator{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover,.cke_skin_kama .cke_menuitem a:focus,.cke_skin_kama .cke_menuitem a:active{\tbackground-color: $color !important;}';if(b.webkit){q=q.split('}').slice(0,-1);for(var r=0;r<q.length;r++)q[r]=q[r].split('{');}function s(v){var w=v.getById(m);if(!w){w=v.getHead().append('style');w.setAttribute('id',m);
w.setAttribute('type','text/css');}return w;};function t(v,w,x){var y,z,A;for(var B=0;B<v.length;B++){if(b.webkit)for(z=0;z<w.length;z++){A=w[z][1];for(y=0;y<x.length;y++)A=A.replace(x[y][0],x[y][1]);v[B].$.sheet.addRule(w[z][0],A);}else{A=w;for(y=0;y<x.length;y++)A=A.replace(x[y][0],x[y][1]);if(c)v[B].$.styleSheet.cssText+=A;else v[B].$.innerHTML+=A;}}};var u=/\$color/g;e.extend(n,{uiColor:null,getUiColor:function(){return this.uiColor;},setUiColor:function(v){var w,x=s(a.document),y='.'+n.id,z=[y+' .cke_wrapper',y+'_dialog .cke_dialog_contents',y+'_dialog a.cke_dialog_tab',y+'_dialog .cke_dialog_footer'].join(','),A='background-color: $color !important;';if(b.webkit)w=[[z,A]];else w=z+'{'+A+'}';return(this.setUiColor=function(B){var C=[[u,B]];n.uiColor=B;t([x],w,C);t(o,q,C);})(v);}});n.on('menuShow',function(v){var w=v.data[0],x=w.element.getElementsByTag('iframe').getItem(0).getFrameDocument();if(!x.getById('cke_ui_color')){var y=s(x);o.push(y);var z=n.getUiColor();if(z)t([y],q,[[u,z]]);}});if(n.config.uiColor)n.setUiColor(n.config.uiColor);}};})());(function(){a.dialog?m():a.on('dialogPluginReady',m);function m(){a.dialog.on('resize',function(n){var o=n.data,p=o.width,q=o.height,r=o.dialog,s=r.parts.contents;if(o.skin!='kama')return;s.setStyles({width:p+'px',height:q+'px'});});};})();j.add('about',{requires:['dialog'],init:function(m){var n=m.addCommand('about',new a.dialogCommand('about'));n.modes={wysiwyg:1,source:1};n.canUndo=false;n.readOnly=1;m.ui.addButton('About',{label:m.lang.about.title,command:'about'});a.dialog.add('about',this.path+'dialogs/about.js');}});(function(){var m='a11yhelp',n='a11yHelp';j.add(m,{requires:['dialog'],availableLangs:{cs:1,cy:1,da:1,de:1,el:1,en:1,eo:1,fa:1,fi:1,fr:1,gu:1,he:1,it:1,ku:1,mk:1,nb:1,nl:1,no:1,'pt-br':1,ro:1,tr:1,ug:1,vi:1,'zh-cn':1},init:function(o){var p=this;o.addCommand(n,{exec:function(){var q=o.langCode;q=p.availableLangs[q]?q:'en';a.scriptLoader.load(a.getUrl(p.path+'lang/'+q+'.js'),function(){e.extend(o.lang,p.langEntries[q]);o.openDialog(n);});},modes:{wysiwyg:1,source:1},readOnly:1,canUndo:false});a.dialog.add(n,this.path+'dialogs/a11yhelp.js');}});})();j.add('basicstyles',{requires:['styles','button'],init:function(m){var n=function(q,r,s,t){var u=new a.style(t);m.attachStyleStateChange(u,function(v){!m.readOnly&&m.getCommand(s).setState(v);});m.addCommand(s,new a.styleCommand(u));m.ui.addButton(q,{label:r,command:s});},o=m.config,p=m.lang;n('Bold',p.bold,'bold',o.coreStyles_bold);n('Italic',p.italic,'italic',o.coreStyles_italic);
n('Underline',p.underline,'underline',o.coreStyles_underline);n('Strike',p.strike,'strike',o.coreStyles_strike);n('Subscript',p.subscript,'subscript',o.coreStyles_subscript);n('Superscript',p.superscript,'superscript',o.coreStyles_superscript);}});i.coreStyles_bold={element:'strong',overrides:'b'};i.coreStyles_italic={element:'em',overrides:'i'};i.coreStyles_underline={element:'u'};i.coreStyles_strike={element:'strike'};i.coreStyles_subscript={element:'sub'};i.coreStyles_superscript={element:'sup'};(function(){var m={table:1,ul:1,ol:1,blockquote:1,div:1},n={},o={};e.extend(n,m,{tr:1,p:1,div:1,li:1});e.extend(o,n,{td:1});function p(B){q(B);r(B);};function q(B){var C=B.editor,D=B.data.path;if(C.readOnly)return;var E=C.config.useComputedState,F;E=E===undefined||E;if(!E)F=s(D.lastElement);F=F||D.block||D.blockLimit;if(F.is('body')){var G=C.getSelection().getRanges()[0].getEnclosedNode();G&&G.type==1&&(F=G);}if(!F)return;var H=E?F.getComputedStyle('direction'):F.getStyle('direction')||F.getAttribute('dir');C.getCommand('bidirtl').setState(H=='rtl'?1:2);C.getCommand('bidiltr').setState(H=='ltr'?1:2);};function r(B){var C=B.editor,D=B.data.path.block||B.data.path.blockLimit;C.fire('contentDirChanged',D?D.getComputedStyle('direction'):C.lang.dir);};function s(B){while(B&&!(B.getName() in o||B.is('body'))){var C=B.getParent();if(!C)break;B=C;}return B;};function t(B,C,D,E){if(B.isReadOnly())return;h.setMarker(E,B,'bidi_processed',1);var F=B;while((F=F.getParent())&&!F.is('body')){if(F.getCustomData('bidi_processed')){B.removeStyle('direction');B.removeAttribute('dir');return;}}var G='useComputedState' in D.config?D.config.useComputedState:1,H=G?B.getComputedStyle('direction'):B.getStyle('direction')||B.hasAttribute('dir');if(H==C)return;B.removeStyle('direction');if(G){B.removeAttribute('dir');if(C!=B.getComputedStyle('direction'))B.setAttribute('dir',C);}else B.setAttribute('dir',C);D.forceNextSelectionCheck();};function u(B,C,D){var E=B.getCommonAncestor(false,true);B=B.clone();B.enlarge(D==2?3:2);if(B.checkBoundaryOfElement(E,1)&&B.checkBoundaryOfElement(E,2)){var F;while(E&&E.type==1&&(F=E.getParent())&&F.getChildCount()==1&&!(E.getName() in C))E=F;return E.type==1&&E.getName() in C&&E;}};function v(B){return function(C){var D=C.getSelection(),E=C.config.enterMode,F=D.getRanges();if(F&&F.length){var G={},H=D.createBookmarks(),I=F.createIterator(),J,K=0;while(J=I.getNextRange(1)){var L=J.getEnclosedNode();if(!L||L&&!(L.type==1&&L.getName() in n))L=u(J,m,E);L&&t(L,B,C,G);
var M,N,O=new d.walker(J),P=H[K].startNode,Q=H[K++].endNode;O.evaluator=function(R){return!!(R.type==1&&R.getName() in m&&!(R.getName()==(E==1?'p':'div')&&R.getParent().type==1&&R.getParent().getName()=='blockquote')&&R.getPosition(P)&2&&(R.getPosition(Q)&4+16)==4);};while(N=O.next())t(N,B,C,G);M=J.createIterator();M.enlargeBr=E!=2;while(N=M.getNextParagraph(E==1?'p':'div'))t(N,B,C,G);}h.clearAllMarkers(G);C.forceNextSelectionCheck();D.selectBookmarks(H);C.focus();}};};j.add('bidi',{requires:['styles','button'],init:function(B){var C=function(E,F,G,H){B.addCommand(G,new a.command(B,{exec:H}));B.ui.addButton(E,{label:F,command:G});},D=B.lang.bidi;C('BidiLtr',D.ltr,'bidiltr',v('ltr'));C('BidiRtl',D.rtl,'bidirtl',v('rtl'));B.on('selectionChange',p);B.on('contentDom',function(){B.document.on('dirChanged',function(E){B.fire('dirChanged',{node:E.data,dir:E.data.getDirection(1)});});});}});function w(B){var C=B.getDocument().getBody().getParent();while(B){if(B.equals(C))return false;B=B.getParent();}return true;};function x(B){var C=B==y.setAttribute,D=B==y.removeAttribute,E=/\bdirection\s*:\s*(.*?)\s*(:?$|;)/;return function(F,G){var J=this;if(!J.getDocument().equals(a.document)){var H;if((F==(C||D?'dir':'direction')||F=='style'&&(D||E.test(G)))&&!w(J)){H=J.getDirection(1);var I=B.apply(J,arguments);if(H!=J.getDirection(1)){J.getDocument().fire('dirChanged',J);return I;}}}return B.apply(J,arguments);};};var y=h.prototype,z=['setStyle','removeStyle','setAttribute','removeAttribute'];for(var A=0;A<z.length;A++)y[z[A]]=e.override(y[z[A]],x);})();(function(){function m(q,r){var s=r.block||r.blockLimit;if(!s||s.getName()=='body')return 2;if(s.getAscendant('blockquote',true))return 1;return 2;};function n(q){var r=q.editor;if(r.readOnly)return;var s=r.getCommand('blockquote');s.state=m(r,q.data.path);s.fire('state');};function o(q){for(var r=0,s=q.getChildCount(),t;r<s&&(t=q.getChild(r));r++){if(t.type==1&&t.isBlockBoundary())return false;}return true;};var p={exec:function(q){var r=q.getCommand('blockquote').state,s=q.getSelection(),t=s&&s.getRanges(true)[0];if(!t)return;var u=s.createBookmarks();if(c){var v=u[0].startNode,w=u[0].endNode,x;if(v&&v.getParent().getName()=='blockquote'){x=v;while(x=x.getNext()){if(x.type==1&&x.isBlockBoundary()){v.move(x,true);break;}}}if(w&&w.getParent().getName()=='blockquote'){x=w;while(x=x.getPrevious()){if(x.type==1&&x.isBlockBoundary()){w.move(x);break;}}}}var y=t.createIterator(),z;y.enlargeBr=q.config.enterMode!=2;if(r==2){var A=[];
while(z=y.getNextParagraph())A.push(z);if(A.length<1){var B=q.document.createElement(q.config.enterMode==1?'p':'div'),C=u.shift();t.insertNode(B);B.append(new d.text('\ufeff',q.document));t.moveToBookmark(C);t.selectNodeContents(B);t.collapse(true);C=t.createBookmark();A.push(B);u.unshift(C);}var D=A[0].getParent(),E=[];for(var F=0;F<A.length;F++){z=A[F];D=D.getCommonAncestor(z.getParent());}var G={table:1,tbody:1,tr:1,ol:1,ul:1};while(G[D.getName()])D=D.getParent();var H=null;while(A.length>0){z=A.shift();while(!z.getParent().equals(D))z=z.getParent();if(!z.equals(H))E.push(z);H=z;}while(E.length>0){z=E.shift();if(z.getName()=='blockquote'){var I=new d.documentFragment(q.document);while(z.getFirst()){I.append(z.getFirst().remove());A.push(I.getLast());}I.replace(z);}else A.push(z);}var J=q.document.createElement('blockquote');J.insertBefore(A[0]);while(A.length>0){z=A.shift();J.append(z);}}else if(r==1){var K=[],L={};while(z=y.getNextParagraph()){var M=null,N=null;while(z.getParent()){if(z.getParent().getName()=='blockquote'){M=z.getParent();N=z;break;}z=z.getParent();}if(M&&N&&!N.getCustomData('blockquote_moveout')){K.push(N);h.setMarker(L,N,'blockquote_moveout',true);}}h.clearAllMarkers(L);var O=[],P=[];L={};while(K.length>0){var Q=K.shift();J=Q.getParent();if(!Q.getPrevious())Q.remove().insertBefore(J);else if(!Q.getNext())Q.remove().insertAfter(J);else{Q.breakParent(Q.getParent());P.push(Q.getNext());}if(!J.getCustomData('blockquote_processed')){P.push(J);h.setMarker(L,J,'blockquote_processed',true);}O.push(Q);}h.clearAllMarkers(L);for(F=P.length-1;F>=0;F--){J=P[F];if(o(J))J.remove();}if(q.config.enterMode==2){var R=true;while(O.length){Q=O.shift();if(Q.getName()=='div'){I=new d.documentFragment(q.document);var S=R&&Q.getPrevious()&&!(Q.getPrevious().type==1&&Q.getPrevious().isBlockBoundary());if(S)I.append(q.document.createElement('br'));var T=Q.getNext()&&!(Q.getNext().type==1&&Q.getNext().isBlockBoundary());while(Q.getFirst())Q.getFirst().remove().appendTo(I);if(T)I.append(q.document.createElement('br'));I.replace(Q);R=false;}}}}s.selectBookmarks(u);q.focus();}};j.add('blockquote',{init:function(q){q.addCommand('blockquote',p);q.ui.addButton('Blockquote',{label:q.lang.blockquote,command:'blockquote'});q.on('selectionChange',n);},requires:['domiterator']});})();j.add('button',{beforeInit:function(m){m.ui.addHandler('button',k.button.handler);}});a.UI_BUTTON='button';k.button=function(m){e.extend(this,m,{title:m.label,className:m.className||m.command&&'cke_button_'+m.command||'',click:m.click||(function(n){n.execCommand(m.command);
})});this._={};};k.button.handler={create:function(m){return new k.button(m);}};(function(){k.button.prototype={render:function(m,n){var o=b,p=this._.id=e.getNextId(),q='',r=this.command,s;this._.editor=m;var t={id:p,button:this,editor:m,focus:function(){var z=a.document.getById(p);z.focus();},execute:function(){if(c&&b.version<7)e.setTimeout(function(){this.button.click(m);},0,this);else this.button.click(m);}},u=e.addFunction(function(z){if(t.onkey){z=new d.event(z);return t.onkey(t,z.getKeystroke())!==false;}}),v=e.addFunction(function(z){var A;if(t.onfocus)A=t.onfocus(t,new d.event(z))!==false;if(b.gecko&&b.version<10900)z.preventBubble();return A;});t.clickFn=s=e.addFunction(t.execute,t);if(this.modes){var w={};function x(){var z=m.mode;if(z){var A=this.modes[z]?w[z]!=undefined?w[z]:2:0;this.setState(m.readOnly&&!this.readOnly?0:A);}};m.on('beforeModeUnload',function(){if(m.mode&&this._.state!=0)w[m.mode]=this._.state;},this);m.on('mode',x,this);!this.readOnly&&m.on('readOnly',x,this);}else if(r){r=m.getCommand(r);if(r){r.on('state',function(){this.setState(r.state);},this);q+='cke_'+(r.state==1?'on':r.state==0?'disabled':'off');}}if(!r)q+='cke_off';if(this.className)q+=' '+this.className;n.push('<span class="cke_button'+(this.icon&&this.icon.indexOf('.png')==-1?' cke_noalphafix':'')+'">','<a id="',p,'" class="',q,'"',o.gecko&&o.version>=10900&&!o.hc?'':'" href="javascript:void(\''+(this.title||'').replace("'",'')+"')\"",' title="',this.title,'" tabindex="-1" hidefocus="true" role="button" aria-labelledby="'+p+'_label"'+(this.hasArrow?' aria-haspopup="true"':''));if(o.opera||o.gecko&&o.mac)n.push(' onkeypress="return false;"');if(o.gecko)n.push(' onblur="this.style.cssText = this.style.cssText;"');n.push(' onkeydown="return CKEDITOR.tools.callFunction(',u,', event);" onfocus="return CKEDITOR.tools.callFunction(',v,', event);" '+(c?'onclick="return false;" onmouseup':'onclick')+'="CKEDITOR.tools.callFunction(',s,', this); return false;"><span class="cke_icon"');if(this.icon){var y=(this.iconOffset||0)*-16;n.push(' style="background-image:url(',a.getUrl(this.icon),');background-position:0 '+y+'px;"');}n.push('>&nbsp;</span><span id="',p,'_label" class="cke_label">',this.label,'</span>');if(this.hasArrow)n.push('<span class="cke_buttonarrow">'+(b.hc?'&#9660;':'&nbsp;')+'</span>');n.push('</a>','</span>');if(this.onRender)this.onRender();return t;},setState:function(m){if(this._.state==m)return false;this._.state=m;var n=a.document.getById(this._.id);if(n){n.setState(m);
m==0?n.setAttribute('aria-disabled',true):n.removeAttribute('aria-disabled');m==1?n.setAttribute('aria-pressed',true):n.removeAttribute('aria-pressed');return true;}else return false;}};})();k.prototype.addButton=function(m,n){this.add(m,'button',n);};(function(){var m=function(y,z){var A=y.document,B=A.getBody(),C=false,D=function(){C=true;};B.on(z,D);(b.version>7?A.$:A.$.selection.createRange()).execCommand(z);B.removeListener(z,D);return C;},n=c?function(y,z){return m(y,z);}:function(y,z){try{return y.document.$.execCommand(z,false,null);}catch(A){return false;}},o=function(y){var z=this;z.type=y;z.canUndo=z.type=='cut';z.startDisabled=true;};o.prototype={exec:function(y,z){this.type=='cut'&&t(y);var A=n(y,this.type);if(!A)alert(y.lang.clipboard[this.type+'Error']);return A;}};var p={canUndo:false,exec:c?function(y){y.focus();if(!y.document.getBody().fire('beforepaste')&&!m(y,'paste')){y.fire('pasteDialog');return false;}}:function(y){try{if(!y.document.getBody().fire('beforepaste')&&!y.document.$.execCommand('Paste',false,null))throw 0;}catch(z){setTimeout(function(){y.fire('pasteDialog');},0);return false;}}},q=function(y){if(this.mode!='wysiwyg')return;switch(y.data.keyCode){case 1114112+86:case 2228224+45:var z=this.document.getBody();if(b.opera||b.gecko)z.fire('paste');return;case 1114112+88:case 2228224+46:var A=this;this.fire('saveSnapshot');setTimeout(function(){A.fire('saveSnapshot');},0);}};function r(y){y.cancel();};function s(y,z,A){var B=this.document;if(B.getById('cke_pastebin'))return;if(z=='text'&&y.data&&y.data.$.clipboardData){var C=y.data.$.clipboardData.getData('text/plain');if(C){y.data.preventDefault();A(C);return;}}var D=this.getSelection(),E=new d.range(B),F=new h(z=='text'?'textarea':b.webkit?'body':'div',B);F.setAttribute('id','cke_pastebin');b.webkit&&F.append(B.createText('\xa0'));B.getBody().append(F);F.setStyles({position:'absolute',top:D.getStartElement().getDocumentPosition().y+'px',width:'1px',height:'1px',overflow:'hidden'});F.setStyle(this.config.contentsLangDirection=='ltr'?'left':'right','-1000px');var G=D.createBookmarks();this.on('selectionChange',r,null,null,0);if(z=='text')F.$.focus();else{E.setStartAt(F,1);E.setEndAt(F,2);E.select(true);}var H=this;window.setTimeout(function(){H.document.getBody().focus();H.removeListener('selectionChange',r);if(b.ie7Compat){D.selectBookmarks(G);F.remove();}else{F.remove();D.selectBookmarks(G);}var I;F=b.webkit&&(I=F.getFirst())&&I.is&&I.hasClass('Apple-style-span')?I:F;A(F['get'+(z=='text'?'Value':'Html')]());
},0);};function t(y){if(!c||b.quirks)return;var z=y.getSelection(),A;if(z.getType()==3&&(A=z.getSelectedElement())){var B=z.getRanges()[0],C=y.document.createText('');C.insertBefore(A);B.setStartBefore(C);B.setEndAfter(A);z.selectRanges([B]);setTimeout(function(){if(A.getParent()){C.remove();z.selectElement(A);}},0);}};var u,v;function w(y,z){var A;if(v&&y in {Paste:1,Cut:1})return 0;if(y=='Paste'){c&&(u=1);try{A=z.document.$.queryCommandEnabled(y)||b.webkit;}catch(D){}u=0;}else{var B=z.getSelection(),C=B&&B.getRanges();A=B&&!(C.length==1&&C[0].collapsed);}return A?2:0;};function x(){var z=this;if(z.mode!='wysiwyg')return;var y=w('Paste',z);z.getCommand('cut').setState(w('Cut',z));z.getCommand('copy').setState(w('Copy',z));z.getCommand('paste').setState(y);z.fire('pasteState',y);};j.add('clipboard',{requires:['dialog','htmldataprocessor'],init:function(y){y.on('paste',function(A){var B=A.data;if(B.html)y.insertHtml(B.html);else if(B.text)y.insertText(B.text);setTimeout(function(){y.fire('afterPaste');},0);},null,null,1000);y.on('pasteDialog',function(A){setTimeout(function(){y.openDialog('paste');},0);});y.on('pasteState',function(A){y.getCommand('paste').setState(A.data);});function z(A,B,C,D){var E=y.lang[B];y.addCommand(B,C);y.ui.addButton(A,{label:E,command:B});if(y.addMenuItems)y.addMenuItem(B,{label:E,command:B,group:'clipboard',order:D});};z('Cut','cut',new o('cut'),1);z('Copy','copy',new o('copy'),4);z('Paste','paste',p,8);a.dialog.add('paste',a.getUrl(this.path+'dialogs/paste.js'));y.on('key',q,y);y.on('contentDom',function(){var A=y.document.getBody();A.on(!c?'paste':'beforepaste',function(B){if(u)return;var C=B.data&&B.data.$;if(c&&C&&!C.ctrlKey)return;var D={mode:'html'};y.fire('beforePaste',D);s.call(y,B,D.mode,function(E){if(!(E=e.trim(E.replace(/<span[^>]+data-cke-bookmark[^<]*?<\/span>/ig,''))))return;var F={};F[D.mode]=E;y.fire('paste',F);});});if(c){A.on('contextmenu',function(){u=1;setTimeout(function(){u=0;},0);});A.on('paste',function(B){if(!y.document.getById('cke_pastebin')){B.data.preventDefault();u=0;p.exec(y);}});}A.on('beforecut',function(){!u&&t(y);});A.on('mouseup',function(){setTimeout(function(){x.call(y);},0);},y);A.on('keyup',x,y);});y.on('selectionChange',function(A){v=A.data.selection.getRanges()[0].checkReadOnly();x.call(y);});if(y.contextMenu)y.contextMenu.addListener(function(A,B){var C=B.getRanges()[0].checkReadOnly();return{cut:w('Cut',y),copy:w('Copy',y),paste:w('Paste',y)};});}});})();j.add('colorbutton',{requires:['panelbutton','floatpanel','styles'],init:function(m){var n=m.config,o=m.lang.colorButton,p;
if(!b.hc){q('TextColor','fore',o.textColorTitle);q('BGColor','back',o.bgColorTitle);}function q(t,u,v){var w=e.getNextId()+'_colorBox';m.ui.add(t,'panelbutton',{label:v,title:v,className:'cke_button_'+t.toLowerCase(),modes:{wysiwyg:1},panel:{css:m.skin.editor.css,attributes:{role:'listbox','aria-label':o.panelTitle}},onBlock:function(x,y){y.autoSize=true;y.element.addClass('cke_colorblock');y.element.setHtml(r(x,u,w));y.element.getDocument().getBody().setStyle('overflow','hidden');k.fire('ready',this);var z=y.keys,A=m.lang.dir=='rtl';z[A?37:39]='next';z[40]='next';z[9]='next';z[A?39:37]='prev';z[38]='prev';z[2228224+9]='prev';z[32]='click';},onOpen:function(){var x=m.getSelection(),y=x&&x.getStartElement(),z=new d.elementPath(y),A;y=z.block||z.blockLimit||m.document.getBody();do A=y&&y.getComputedStyle(u=='back'?'background-color':'color')||'transparent';while(u=='back'&&A=='transparent'&&y&&(y=y.getParent()));if(!A||A=='transparent')A='#ffffff';this._.panel._.iframe.getFrameDocument().getById(w).setStyle('background-color',A);}});};function r(t,u,v){var w=[],x=n.colorButton_colors.split(','),y=e.addFunction(function(E,F){if(E=='?'){var G=arguments.callee;function H(J){this.removeListener('ok',H);this.removeListener('cancel',H);J.name=='ok'&&G(this.getContentElement('picker','selectedColor').getValue(),F);};m.openDialog('colordialog',function(){this.on('ok',H);this.on('cancel',H);});return;}m.focus();t.hide(false);m.fire('saveSnapshot');new a.style(n['colorButton_'+F+'Style'],{color:'inherit'}).remove(m.document);if(E){var I=n['colorButton_'+F+'Style'];I.childRule=F=='back'?function(J){return s(J);}:function(J){return!(J.is('a')||J.getElementsByTag('a').count())||s(J);};new a.style(I,{color:E}).apply(m.document);}m.fire('saveSnapshot');});w.push('<a class="cke_colorauto" _cke_focus=1 hidefocus=true title="',o.auto,'" onclick="CKEDITOR.tools.callFunction(',y,",null,'",u,"');return false;\" href=\"javascript:void('",o.auto,'\')" role="option"><table role="presentation" cellspacing=0 cellpadding=0 width="100%"><tr><td><span class="cke_colorbox" id="',v,'"></span></td><td colspan=7 align=center>',o.auto,'</td></tr></table></a><table role="presentation" cellspacing=0 cellpadding=0 width="100%">');for(var z=0;z<x.length;z++){if(z%8===0)w.push('</tr><tr>');var A=x[z].split('/'),B=A[0],C=A[1]||B;if(!A[1])B='#'+B.replace(/^(.)(.)(.)$/,'$1$1$2$2$3$3');var D=m.lang.colors[C]||C;w.push('<td><a class="cke_colorbox" _cke_focus=1 hidefocus=true title="',D,'" onclick="CKEDITOR.tools.callFunction(',y,",'",B,"','",u,"'); return false;\" href=\"javascript:void('",D,'\')" role="option"><span class="cke_colorbox" style="background-color:#',C,'"></span></a></td>');
}if(n.colorButton_enableMore===undefined||n.colorButton_enableMore)w.push('</tr><tr><td colspan=8 align=center><a class="cke_colormore" _cke_focus=1 hidefocus=true title="',o.more,'" onclick="CKEDITOR.tools.callFunction(',y,",'?','",u,"');return false;\" href=\"javascript:void('",o.more,"')\"",' role="option">',o.more,'</a></td>');w.push('</tr></table>');return w.join('');};function s(t){return t.getAttribute('contentEditable')=='false'||t.getAttribute('data-nostyle');};}});i.colorButton_colors='000,800000,8B4513,2F4F4F,008080,000080,4B0082,696969,B22222,A52A2A,DAA520,006400,40E0D0,0000CD,800080,808080,F00,FF8C00,FFD700,008000,0FF,00F,EE82EE,A9A9A9,FFA07A,FFA500,FFFF00,00FF00,AFEEEE,ADD8E6,DDA0DD,D3D3D3,FFF0F5,FAEBD7,FFFFE0,F0FFF0,F0FFFF,F0F8FF,E6E6FA,FFF';i.colorButton_foreStyle={element:'span',styles:{color:'#(color)'},overrides:[{element:'font',attributes:{color:null}}]};i.colorButton_backStyle={element:'span',styles:{'background-color':'#(color)'}};j.colordialog={requires:['dialog'],init:function(m){m.addCommand('colordialog',new a.dialogCommand('colordialog'));a.dialog.add('colordialog',this.path+'dialogs/colordialog.js');}};j.add('colordialog',j.colordialog);j.add('contextmenu',{requires:['menu'],onLoad:function(){j.contextMenu=e.createClass({base:a.menu,$:function(m){this.base.call(this,m,{panel:{className:m.skinClass+' cke_contextmenu',attributes:{'aria-label':m.lang.contextmenu.options}}});},proto:{addTarget:function(m,n){if(b.opera&&!('oncontextmenu' in document.body)){var o;m.on('mousedown',function(s){s=s.data;if(s.$.button!=2){if(s.getKeystroke()==1114112+1)m.fire('contextmenu',s);return;}if(n&&(b.mac?s.$.metaKey:s.$.ctrlKey))return;var t=s.getTarget();if(!o){var u=t.getDocument();o=u.createElement('input');o.$.type='button';u.getBody().append(o);}o.setAttribute('style','position:absolute;top:'+(s.$.clientY-2)+'px;left:'+(s.$.clientX-2)+'px;width:5px;height:5px;opacity:0.01');});m.on('mouseup',function(s){if(o){o.remove();o=undefined;m.fire('contextmenu',s.data);}});}m.on('contextmenu',function(s){var t=s.data;if(n&&(b.webkit?p:b.mac?t.$.metaKey:t.$.ctrlKey))return;t.preventDefault();var u=t.getTarget().getDocument().getDocumentElement(),v=t.$.clientX,w=t.$.clientY;e.setTimeout(function(){this.open(u,null,v,w);},c?200:0,this);},this);if(b.opera)m.on('keypress',function(s){var t=s.data;if(t.$.keyCode===0)t.preventDefault();});if(b.webkit){var p,q=function(s){p=b.mac?s.data.$.metaKey:s.data.$.ctrlKey;},r=function(){p=0;};m.on('keydown',q);m.on('keyup',r);
m.on('contextmenu',r);}},open:function(m,n,o,p){this.editor.focus();m=m||a.document.getDocumentElement();this.show(m,n,o,p);}}});},beforeInit:function(m){m.contextMenu=new j.contextMenu(m);m.addCommand('contextMenu',{exec:function(){m.contextMenu.open(m.document.getBody());}});}});(function(){function m(o){var p=this.att,q=o&&o.hasAttribute(p)&&o.getAttribute(p)||'';if(q!==undefined)this.setValue(q);};function n(){var o;for(var p=0;p<arguments.length;p++){if(arguments[p] instanceof h){o=arguments[p];break;}}if(o){var q=this.att,r=this.getValue();if(r)o.setAttribute(q,r);else o.removeAttribute(q,r);}};j.add('dialogadvtab',{createAdvancedTab:function(o,p){if(!p)p={id:1,dir:1,classes:1,styles:1};var q=o.lang.common,r={id:'advanced',label:q.advancedTab,title:q.advancedTab,elements:[{type:'vbox',padding:1,children:[]}]},s=[];if(p.id||p.dir){if(p.id)s.push({id:'advId',att:'id',type:'text',label:q.id,setup:m,commit:n});if(p.dir)s.push({id:'advLangDir',att:'dir',type:'select',label:q.langDir,'default':'',style:'width:100%',items:[[q.notSet,''],[q.langDirLTR,'ltr'],[q.langDirRTL,'rtl']],setup:m,commit:n});r.elements[0].children.push({type:'hbox',widths:['50%','50%'],children:[].concat(s)});}if(p.styles||p.classes){s=[];if(p.styles)s.push({id:'advStyles',att:'style',type:'text',label:q.styles,'default':'',validate:a.dialog.validate.inlineStyle(q.invalidInlineStyle),onChange:function(){},getStyle:function(t,u){var v=this.getValue().match(new RegExp(t+'\\s*:\\s*([^;]*)','i'));return v?v[1]:u;},updateStyle:function(t,u){var v=this.getValue(),w=o.document.createElement('span');w.setAttribute('style',v);w.setStyle(t,u);v=e.normalizeCssText(w.getAttribute('style'));this.setValue(v,1);},setup:m,commit:n});if(p.classes)s.push({type:'hbox',widths:['45%','55%'],children:[{id:'advCSSClasses',att:'class',type:'text',label:q.cssClasses,'default':'',setup:m,commit:n}]});r.elements[0].children.push({type:'hbox',widths:['50%','50%'],children:[].concat(s)});}return r;}});})();(function(){j.add('div',{requires:['editingblock','dialog','domiterator','styles'],init:function(m){var n=m.lang.div;m.addCommand('creatediv',new a.dialogCommand('creatediv'));m.addCommand('editdiv',new a.dialogCommand('editdiv'));m.addCommand('removediv',{exec:function(o){var p=o.getSelection(),q=p&&p.getRanges(),r,s=p.createBookmarks(),t,u=[];function v(x){var y=new d.elementPath(x),z=y.blockLimit,A=z.is('div')&&z;if(A&&!A.data('cke-div-added')){u.push(A);A.data('cke-div-added');}};for(var w=0;w<q.length;w++){r=q[w];
if(r.collapsed)v(p.getStartElement());else{t=new d.walker(r);t.evaluator=v;t.lastForward();}}for(w=0;w<u.length;w++)u[w].remove(true);p.selectBookmarks(s);}});m.ui.addButton('CreateDiv',{label:n.toolbar,command:'creatediv'});if(m.addMenuItems){m.addMenuItems({editdiv:{label:n.edit,command:'editdiv',group:'div',order:1},removediv:{label:n.remove,command:'removediv',group:'div',order:5}});if(m.contextMenu)m.contextMenu.addListener(function(o,p){if(!o||o.isReadOnly())return null;var q=new d.elementPath(o),r=q.blockLimit;if(r&&r.getAscendant('div',true))return{editdiv:2,removediv:2};return null;});}a.dialog.add('creatediv',this.path+'dialogs/div.js');a.dialog.add('editdiv',this.path+'dialogs/div.js');}});})();(function(){var m={toolbarFocus:{editorFocus:false,readOnly:1,exec:function(o){var p=o._.elementsPath.idBase,q=a.document.getById(p+'0');q&&q.focus(c||b.air);}}},n='<span class="cke_empty">&nbsp;</span>';j.add('elementspath',{requires:['selection'],init:function(o){var p='cke_path_'+o.name,q,r=function(){if(!q)q=a.document.getById(p);return q;},s='cke_elementspath_'+e.getNextNumber()+'_';o._.elementsPath={idBase:s,filters:[]};o.on('themeSpace',function(x){if(x.data.space=='bottom')x.data.html+='<span id="'+p+'_label" class="cke_voice_label">'+o.lang.elementsPath.eleLabel+'</span>'+'<div id="'+p+'" class="cke_path" role="group" aria-labelledby="'+p+'_label">'+n+'</div>';});function t(x){o.focus();var y=o._.elementsPath.list[x];if(y.is('body')){var z=new d.range(o.document);z.selectNodeContents(y);z.select();}else o.getSelection().selectElement(y);};var u=e.addFunction(t),v=e.addFunction(function(x,y){var z=o._.elementsPath.idBase,A;y=new d.event(y);var B=o.lang.dir=='rtl';switch(y.getKeystroke()){case B?39:37:case 9:A=a.document.getById(z+(x+1));if(!A)A=a.document.getById(z+'0');A.focus();return false;case B?37:39:case 2228224+9:A=a.document.getById(z+(x-1));if(!A)A=a.document.getById(z+(o._.elementsPath.list.length-1));A.focus();return false;case 27:o.focus();return false;case 13:case 32:t(x);return false;}return true;});o.on('selectionChange',function(x){var y=b,z=x.data.selection,A=z.getStartElement(),B=[],C=x.editor,D=C._.elementsPath.list=[],E=C._.elementsPath.filters;while(A){var F=0,G;if(A.data('cke-display-name'))G=A.data('cke-display-name');else if(A.data('cke-real-element-type'))G=A.data('cke-real-element-type');else G=A.getName();for(var H=0;H<E.length;H++){var I=E[H](A,G);if(I===false){F=1;break;}G=I||G;}if(!F){var J=D.push(A)-1,K='';if(y.opera||y.gecko&&y.mac)K+=' onkeypress="return false;"';
if(y.gecko)K+=' onblur="this.style.cssText = this.style.cssText;"';var L=C.lang.elementsPath.eleTitle.replace(/%1/,G);B.unshift('<a id="',s,J,'" href="javascript:void(\'',G,'\')" tabindex="-1" title="',L,'"'+(b.gecko&&b.version<10900?' onfocus="event.preventBubble();"':'')+' hidefocus="true" '+' onkeydown="return CKEDITOR.tools.callFunction(',v,',',J,', event );"'+K,' onclick="CKEDITOR.tools.callFunction('+u,',',J,'); return false;"',' role="button" aria-labelledby="'+s+J+'_label">',G,'<span id="',s,J,'_label" class="cke_label">'+L+'</span>','</a>');}if(G=='body')break;A=A.getParent();}var M=r();M.setHtml(B.join('')+n);C.fire('elementsPathUpdate',{space:M});});function w(){q&&q.setHtml(n);delete o._.elementsPath.list;};o.on('readOnly',w);o.on('contentDomUnload',w);o.addCommand('elementsPathFocus',m.toolbarFocus);}});})();(function(){j.add('enterkey',{requires:['keystrokes','indent'],init:function(t){t.addCommand('enter',{modes:{wysiwyg:1},editorFocus:false,exec:function(v){r(v);}});t.addCommand('shiftEnter',{modes:{wysiwyg:1},editorFocus:false,exec:function(v){q(v);}});var u=t.keystrokeHandler.keystrokes;u[13]='enter';u[2228224+13]='shiftEnter';}});j.enterkey={enterBlock:function(t,u,v,w){v=v||s(t);if(!v)return;var x=v.document,y=v.checkStartOfBlock(),z=v.checkEndOfBlock(),A=new d.elementPath(v.startContainer),B=A.block;if(y&&z){if(B&&(B.is('li')||B.getParent().is('li'))){t.execCommand('outdent');return;}if(B&&B.getParent().is('blockquote')){B.breakParent(B.getParent());if(!B.getPrevious().getFirst(d.walker.invisible(1)))B.getPrevious().remove();if(!B.getNext().getFirst(d.walker.invisible(1)))B.getNext().remove();v.moveToElementEditStart(B);v.select();return;}}else if(B&&B.is('pre')){if(!z){n(t,u,v,w);return;}}else if(B&&f.$captionBlock[B.getName()]){n(t,u,v,w);return;}var C=u==3?'div':'p',D=v.splitBlock(C);if(!D)return;var E=D.previousBlock,F=D.nextBlock,G=D.wasStartOfBlock,H=D.wasEndOfBlock,I;if(F){I=F.getParent();if(I.is('li')){F.breakParent(I);F.move(F.getNext(),1);}}else if(E&&(I=E.getParent())&&I.is('li')){E.breakParent(I);I=E.getNext();v.moveToElementEditStart(I);E.move(E.getPrevious());}if(!G&&!H){if(F.is('li')&&(I=F.getFirst(d.walker.invisible(true)))&&I.is&&I.is('ul','ol'))(c?x.createText('\xa0'):x.createElement('br')).insertBefore(I);if(F)v.moveToElementEditStart(F);}else{var J,K;if(E){if(E.is('li')||!(p.test(E.getName())||E.is('pre')))J=E.clone();}else if(F)J=F.clone();if(!J){if(I&&I.is('li'))J=I;else{J=x.createElement(C);if(E&&(K=E.getDirection()))J.setAttribute('dir',K);
}}else if(w&&!J.is('li'))J.renameNode(C);var L=D.elementPath;if(L)for(var M=0,N=L.elements.length;M<N;M++){var O=L.elements[M];if(O.equals(L.block)||O.equals(L.blockLimit))break;if(f.$removeEmpty[O.getName()]){O=O.clone();J.moveChildren(O);J.append(O);}}if(!c)J.appendBogus();if(!J.getParent())v.insertNode(J);J.is('li')&&J.removeAttribute('value');if(c&&G&&(!H||!E.getChildCount())){v.moveToElementEditStart(H?E:J);v.select();}v.moveToElementEditStart(G&&!H?F:J);}if(!c)if(F){var P=x.createElement('span');P.setHtml('&nbsp;');v.insertNode(P);P.scrollIntoView();v.deleteContents();}else J.scrollIntoView();v.select();},enterBr:function(t,u,v,w){v=v||s(t);if(!v)return;var x=v.document,y=u==3?'div':'p',z=v.checkEndOfBlock(),A=new d.elementPath(t.getSelection().getStartElement()),B=A.block,C=B&&A.block.getName(),D=false;if(!w&&C=='li'){o(t,u,v,w);return;}if(!w&&z&&p.test(C)){var E,F;if(F=B.getDirection()){E=x.createElement('div');E.setAttribute('dir',F);E.insertAfter(B);v.setStart(E,0);}else{x.createElement('br').insertAfter(B);if(b.gecko)x.createText('').insertAfter(B);v.setStartAt(B.getNext(),c?3:1);}}else{var G;D=C=='pre';if(D&&!b.gecko)G=x.createText(c?'\r':'\n');else G=x.createElement('br');v.deleteContents();v.insertNode(G);if(c)v.setStartAt(G,4);else{x.createText('\ufeff').insertAfter(G);if(z)G.getParent().appendBogus();G.getNext().$.nodeValue='';v.setStartAt(G.getNext(),1);var H=null;if(!b.gecko){H=x.createElement('span');H.setHtml('&nbsp;');}else H=x.createElement('br');H.insertBefore(G.getNext());H.scrollIntoView();H.remove();}}v.collapse(true);v.select(D);}};var m=j.enterkey,n=m.enterBr,o=m.enterBlock,p=/^h[1-6]$/;function q(t){if(t.mode!='wysiwyg')return false;return r(t,t.config.shiftEnterMode,1);};function r(t,u,v){v=t.config.forceEnterMode||v;if(t.mode!='wysiwyg')return false;if(!u)u=t.config.enterMode;setTimeout(function(){t.fire('saveSnapshot');if(u==2)n(t,u,null,v);else o(t,u,null,v);t.fire('saveSnapshot');},0);return true;};function s(t){var u=t.getSelection().getRanges(true);for(var v=u.length-1;v>0;v--)u[v].deleteContents();return u[0];};})();(function(){var m='nbsp,gt,lt,amp',n='quot,iexcl,cent,pound,curren,yen,brvbar,sect,uml,copy,ordf,laquo,not,shy,reg,macr,deg,plusmn,sup2,sup3,acute,micro,para,middot,cedil,sup1,ordm,raquo,frac14,frac12,frac34,iquest,times,divide,fnof,bull,hellip,prime,Prime,oline,frasl,weierp,image,real,trade,alefsym,larr,uarr,rarr,darr,harr,crarr,lArr,uArr,rArr,dArr,hArr,forall,part,exist,empty,nabla,isin,notin,ni,prod,sum,minus,lowast,radic,prop,infin,ang,and,or,cap,cup,int,there4,sim,cong,asymp,ne,equiv,le,ge,sub,sup,nsub,sube,supe,oplus,otimes,perp,sdot,lceil,rceil,lfloor,rfloor,lang,rang,loz,spades,clubs,hearts,diams,circ,tilde,ensp,emsp,thinsp,zwnj,zwj,lrm,rlm,ndash,mdash,lsquo,rsquo,sbquo,ldquo,rdquo,bdquo,dagger,Dagger,permil,lsaquo,rsaquo,euro',o='Agrave,Aacute,Acirc,Atilde,Auml,Aring,AElig,Ccedil,Egrave,Eacute,Ecirc,Euml,Igrave,Iacute,Icirc,Iuml,ETH,Ntilde,Ograve,Oacute,Ocirc,Otilde,Ouml,Oslash,Ugrave,Uacute,Ucirc,Uuml,Yacute,THORN,szlig,agrave,aacute,acirc,atilde,auml,aring,aelig,ccedil,egrave,eacute,ecirc,euml,igrave,iacute,icirc,iuml,eth,ntilde,ograve,oacute,ocirc,otilde,ouml,oslash,ugrave,uacute,ucirc,uuml,yacute,thorn,yuml,OElig,oelig,Scaron,scaron,Yuml',p='Alpha,Beta,Gamma,Delta,Epsilon,Zeta,Eta,Theta,Iota,Kappa,Lambda,Mu,Nu,Xi,Omicron,Pi,Rho,Sigma,Tau,Upsilon,Phi,Chi,Psi,Omega,alpha,beta,gamma,delta,epsilon,zeta,eta,theta,iota,kappa,lambda,mu,nu,xi,omicron,pi,rho,sigmaf,sigma,tau,upsilon,phi,chi,psi,omega,thetasym,upsih,piv';
function q(r,s){var t={},u=[],v={nbsp:'\xa0',shy:'­',gt:'>',lt:'<',amp:'&',apos:"'",quot:'"'};r=r.replace(/\b(nbsp|shy|gt|lt|amp|apos|quot)(?:,|$)/g,function(A,B){var C=s?'&'+B+';':v[B],D=s?v[B]:'&'+B+';';t[C]=D;u.push(C);return '';});if(!s&&r){r=r.split(',');var w=document.createElement('div'),x;w.innerHTML='&'+r.join(';&')+';';x=w.innerHTML;w=null;for(var y=0;y<x.length;y++){var z=x.charAt(y);t[z]='&'+r[y]+';';u.push(z);}}t.regex=u.join(s?'|':'');return t;};j.add('entities',{afterInit:function(r){var s=r.config,t=r.dataProcessor,u=t&&t.htmlFilter;if(u){var v=[];if(s.basicEntities!==false)v.push(m);if(s.entities){if(v.length)v.push(n);if(s.entities_latin)v.push(o);if(s.entities_greek)v.push(p);if(s.entities_additional)v.push(s.entities_additional);}var w=q(v.join(',')),x=w.regex?'['+w.regex+']':'a^';delete w.regex;if(s.entities&&s.entities_processNumerical)x='[^ -~]|'+x;x=new RegExp(x,'g');function y(C){return s.entities_processNumerical=='force'||!w[C]?'&#'+C.charCodeAt(0)+';':w[C];};var z=q([m,'shy'].join(','),true),A=new RegExp(z.regex,'g');function B(C){return z[C];};u.addRules({text:function(C){return C.replace(A,B).replace(x,y);}});}}});})();i.basicEntities=true;i.entities=true;i.entities_latin=true;i.entities_greek=true;i.entities_additional='#39';(function(){function m(v,w){var x=[];if(!w)return v;else for(var y in w)x.push(y+'='+encodeURIComponent(w[y]));return v+(v.indexOf('?')!=-1?'&':'?')+x.join('&');};function n(v){v+='';var w=v.charAt(0).toUpperCase();return w+v.substr(1);};function o(v){var C=this;var w=C.getDialog(),x=w.getParentEditor();x._.filebrowserSe=C;var y=x.config['filebrowser'+n(w.getName())+'WindowWidth']||x.config.filebrowserWindowWidth||'80%',z=x.config['filebrowser'+n(w.getName())+'WindowHeight']||x.config.filebrowserWindowHeight||'70%',A=C.filebrowser.params||{};A.CKEditor=x.name;A.CKEditorFuncNum=x._.filebrowserFn;if(!A.langCode)A.langCode=x.langCode;var B=m(C.filebrowser.url,A);x.popup(B,y,z,x.config.filebrowserWindowFeatures||x.config.fileBrowserWindowFeatures);};function p(v){var y=this;var w=y.getDialog(),x=w.getParentEditor();x._.filebrowserSe=y;if(!w.getContentElement(y['for'][0],y['for'][1]).getInputElement().$.value)return false;if(!w.getContentElement(y['for'][0],y['for'][1]).getAction())return false;return true;};function q(v,w,x){var y=x.params||{};y.CKEditor=v.name;y.CKEditorFuncNum=v._.filebrowserFn;if(!y.langCode)y.langCode=v.langCode;w.action=m(x.url,y);w.filebrowser=x;};function r(v,w,x,y){var z,A;for(var B in y){z=y[B];
if(z.type=='hbox'||z.type=='vbox'||z.type=='fieldset')r(v,w,x,z.children);if(!z.filebrowser)continue;if(typeof z.filebrowser=='string'){var C={action:z.type=='fileButton'?'QuickUpload':'Browse',target:z.filebrowser};z.filebrowser=C;}if(z.filebrowser.action=='Browse'){var D=z.filebrowser.url;if(D===undefined){D=v.config['filebrowser'+n(w)+'BrowseUrl'];if(D===undefined)D=v.config.filebrowserBrowseUrl;}if(D){z.onClick=o;z.filebrowser.url=D;z.hidden=false;}}else if(z.filebrowser.action=='QuickUpload'&&z['for']){D=z.filebrowser.url;if(D===undefined){D=v.config['filebrowser'+n(w)+'UploadUrl'];if(D===undefined)D=v.config.filebrowserUploadUrl;}if(D){var E=z.onClick;z.onClick=function(F){var G=F.sender;if(E&&E.call(G,F)===false)return false;return p.call(G,F);};z.filebrowser.url=D;z.hidden=false;q(v,x.getContents(z['for'][0]).get(z['for'][1]),z.filebrowser);}}}};function s(v,w){var x=w.getDialog(),y=w.filebrowser.target||null;if(y){var z=y.split(':'),A=x.getContentElement(z[0],z[1]);if(A){A.setValue(v);x.selectPage(z[0]);}}};function t(v,w,x){if(x.indexOf(';')!==-1){var y=x.split(';');for(var z=0;z<y.length;z++){if(t(v,w,y[z]))return true;}return false;}var A=v.getContents(w).get(x).filebrowser;return A&&A.url;};function u(v,w){var A=this;var x=A._.filebrowserSe.getDialog(),y=A._.filebrowserSe['for'],z=A._.filebrowserSe.filebrowser.onSelect;if(y)x.getContentElement(y[0],y[1]).reset();if(typeof w=='function'&&w.call(A._.filebrowserSe)===false)return;if(z&&z.call(A._.filebrowserSe,v,w)===false)return;if(typeof w=='string'&&w)alert(w);if(v)s(v,A._.filebrowserSe);};j.add('filebrowser',{init:function(v,w){v._.filebrowserFn=e.addFunction(u,v);v.on('destroy',function(){e.removeFunction(this._.filebrowserFn);});}});a.on('dialogDefinition',function(v){var w=v.data.definition,x;for(var y in w.contents){if(x=w.contents[y]){r(v.editor,v.data.name,w,x.elements);if(x.hidden&&x.filebrowser)x.hidden=!t(w,x.id,x.filebrowser);}}});})();j.add('find',{requires:['dialog'],init:function(m){var n=j.find;m.ui.addButton('Find',{label:m.lang.findAndReplace.find,command:'find'});var o=m.addCommand('find',new a.dialogCommand('find'));o.canUndo=false;o.readOnly=1;m.ui.addButton('Replace',{label:m.lang.findAndReplace.replace,command:'replace'});var p=m.addCommand('replace',new a.dialogCommand('replace'));p.canUndo=false;a.dialog.add('find',this.path+'dialogs/find.js');a.dialog.add('replace',this.path+'dialogs/find.js');},requires:['styles']});i.find_highlight={element:'span',styles:{'background-color':'#004',color:'#fff'}};
(function(){var m=/\.swf(?:$|\?)/i;function n(p){var q=p.attributes;return q.type=='application/x-shockwave-flash'||m.test(q.src||'');};function o(p,q){return p.createFakeParserElement(q,'cke_flash','flash',true);};j.add('flash',{init:function(p){p.addCommand('flash',new a.dialogCommand('flash'));p.ui.addButton('Flash',{label:p.lang.common.flash,command:'flash'});a.dialog.add('flash',this.path+'dialogs/flash.js');p.addCss('img.cke_flash{background-image: url('+a.getUrl(this.path+'images/placeholder.png')+');'+'background-position: center center;'+'background-repeat: no-repeat;'+'border: 1px solid #a9a9a9;'+'width: 80px;'+'height: 80px;'+'}');if(p.addMenuItems)p.addMenuItems({flash:{label:p.lang.flash.properties,command:'flash',group:'flash'}});p.on('doubleclick',function(q){var r=q.data.element;if(r.is('img')&&r.data('cke-real-element-type')=='flash')q.data.dialog='flash';});if(p.contextMenu)p.contextMenu.addListener(function(q,r){if(q&&q.is('img')&&!q.isReadOnly()&&q.data('cke-real-element-type')=='flash')return{flash:2};});},afterInit:function(p){var q=p.dataProcessor,r=q&&q.dataFilter;if(r)r.addRules({elements:{'cke:object':function(s){var t=s.attributes,u=t.classid&&String(t.classid).toLowerCase();if(!u&&!n(s)){for(var v=0;v<s.children.length;v++){if(s.children[v].name=='cke:embed'){if(!n(s.children[v]))return null;return o(p,s);}}return null;}return o(p,s);},'cke:embed':function(s){if(!n(s))return null;return o(p,s);}}},5);},requires:['fakeobjects']});})();e.extend(i,{flashEmbedTagOnly:false,flashAddEmbedTag:true,flashConvertOnEdit:false});(function(){function m(n,o,p,q,r,s,t){var u=n.config,v=r.split(';'),w=[],x={};for(var y=0;y<v.length;y++){var z=v[y];if(z){z=z.split('/');var A={},B=v[y]=z[0];A[p]=w[y]=z[1]||B;x[B]=new a.style(t,A);x[B]._.definition.name=B;}else v.splice(y--,1);}n.ui.addRichCombo(o,{label:q.label,title:q.panelTitle,className:'cke_'+(p=='size'?'fontSize':'font'),panel:{css:n.skin.editor.css.concat(u.contentsCss),multiSelect:false,attributes:{'aria-label':q.panelTitle}},init:function(){this.startGroup(q.panelTitle);for(var C=0;C<v.length;C++){var D=v[C];this.add(D,x[D].buildPreview(),D);}},onClick:function(C){n.focus();n.fire('saveSnapshot');var D=x[C];if(this.getValue()==C)D.remove(n.document);else D.apply(n.document);n.fire('saveSnapshot');},onRender:function(){n.on('selectionChange',function(C){var D=this.getValue(),E=C.data.path,F=E.elements;for(var G=0,H;G<F.length;G++){H=F[G];for(var I in x){if(x[I].checkElementMatch(H,true)){if(I!=D)this.setValue(I);
return;}}}this.setValue('',s);},this);}});};j.add('font',{requires:['richcombo','styles'],init:function(n){var o=n.config;m(n,'Font','family',n.lang.font,o.font_names,o.font_defaultLabel,o.font_style);m(n,'FontSize','size',n.lang.fontSize,o.fontSize_sizes,o.fontSize_defaultLabel,o.fontSize_style);}});})();i.font_names='Arial/Arial, Helvetica, sans-serif;Comic Sans MS/Comic Sans MS, cursive;Courier New/Courier New, Courier, monospace;Georgia/Georgia, serif;Lucida Sans Unicode/Lucida Sans Unicode, Lucida Grande, sans-serif;Tahoma/Tahoma, Geneva, sans-serif;Times New Roman/Times New Roman, Times, serif;Trebuchet MS/Trebuchet MS, Helvetica, sans-serif;Verdana/Verdana, Geneva, sans-serif';i.font_defaultLabel='';i.font_style={element:'span',styles:{'font-family':'#(family)'},overrides:[{element:'font',attributes:{face:null}}]};i.fontSize_sizes='8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;72/72px';i.fontSize_defaultLabel='';i.fontSize_style={element:'span',styles:{'font-size':'#(size)'},overrides:[{element:'font',attributes:{size:null}}]};j.add('format',{requires:['richcombo','styles'],init:function(m){var n=m.config,o=m.lang.format,p=n.format_tags.split(';'),q={};for(var r=0;r<p.length;r++){var s=p[r];q[s]=new a.style(n['format_'+s]);q[s]._.enterMode=m.config.enterMode;}m.ui.addRichCombo('Format',{label:o.label,title:o.panelTitle,className:'cke_format',panel:{css:m.skin.editor.css.concat(n.contentsCss),multiSelect:false,attributes:{'aria-label':o.panelTitle}},init:function(){this.startGroup(o.panelTitle);for(var t in q){var u=o['tag_'+t];this.add(t,q[t].buildPreview(u),u);}},onClick:function(t){m.focus();m.fire('saveSnapshot');var u=q[t],v=new d.elementPath(m.getSelection().getStartElement());u[u.checkActive(v)?'remove':'apply'](m.document);setTimeout(function(){m.fire('saveSnapshot');},0);},onRender:function(){m.on('selectionChange',function(t){var u=this.getValue(),v=t.data.path;for(var w in q){if(q[w].checkActive(v)){if(w!=u)this.setValue(w,m.lang.format['tag_'+w]);return;}}this.setValue('');},this);}});}});i.format_tags='p;h1;h2;h3;h4;h5;h6;pre;address;div';i.format_p={element:'p'};i.format_div={element:'div'};i.format_pre={element:'pre'};i.format_address={element:'address'};i.format_h1={element:'h1'};i.format_h2={element:'h2'};i.format_h3={element:'h3'};i.format_h4={element:'h4'};i.format_h5={element:'h5'};i.format_h6={element:'h6'};j.add('forms',{requires:['dialog'],init:function(m){var n=m.lang;
m.addCss('form{border: 1px dotted #FF0000;padding: 2px;}\n');m.addCss('img.cke_hidden{background-image: url('+a.getUrl(this.path+'images/hiddenfield.gif')+');'+'background-position: center center;'+'background-repeat: no-repeat;'+'border: 1px solid #a9a9a9;'+'width: 16px !important;'+'height: 16px !important;'+'}');var o=function(q,r,s){m.addCommand(r,new a.dialogCommand(r));m.ui.addButton(q,{label:n.common[q.charAt(0).toLowerCase()+q.slice(1)],command:r});a.dialog.add(r,s);},p=this.path+'dialogs/';o('Form','form',p+'form.js');o('Checkbox','checkbox',p+'checkbox.js');o('Radio','radio',p+'radio.js');o('TextField','textfield',p+'textfield.js');o('Textarea','textarea',p+'textarea.js');o('Select','select',p+'select.js');o('Button','button',p+'button.js');o('ImageButton','imagebutton',j.getPath('image')+'dialogs/image.js');o('HiddenField','hiddenfield',p+'hiddenfield.js');if(m.addMenuItems)m.addMenuItems({form:{label:n.form.menu,command:'form',group:'form'},checkbox:{label:n.checkboxAndRadio.checkboxTitle,command:'checkbox',group:'checkbox'},radio:{label:n.checkboxAndRadio.radioTitle,command:'radio',group:'radio'},textfield:{label:n.textfield.title,command:'textfield',group:'textfield'},hiddenfield:{label:n.hidden.title,command:'hiddenfield',group:'hiddenfield'},imagebutton:{label:n.image.titleButton,command:'imagebutton',group:'imagebutton'},button:{label:n.button.title,command:'button',group:'button'},select:{label:n.select.title,command:'select',group:'select'},textarea:{label:n.textarea.title,command:'textarea',group:'textarea'}});if(m.contextMenu){m.contextMenu.addListener(function(q){if(q&&q.hasAscendant('form',true)&&!q.isReadOnly())return{form:2};});m.contextMenu.addListener(function(q){if(q&&!q.isReadOnly()){var r=q.getName();if(r=='select')return{select:2};if(r=='textarea')return{textarea:2};if(r=='input')switch(q.getAttribute('type')){case 'button':case 'submit':case 'reset':return{button:2};case 'checkbox':return{checkbox:2};case 'radio':return{radio:2};case 'image':return{imagebutton:2};default:return{textfield:2};}if(r=='img'&&q.data('cke-real-element-type')=='hiddenfield')return{hiddenfield:2};}});}m.on('doubleclick',function(q){var r=q.data.element;if(r.is('form'))q.data.dialog='form';else if(r.is('select'))q.data.dialog='select';else if(r.is('textarea'))q.data.dialog='textarea';else if(r.is('img')&&r.data('cke-real-element-type')=='hiddenfield')q.data.dialog='hiddenfield';else if(r.is('input'))switch(r.getAttribute('type')){case 'button':case 'submit':case 'reset':q.data.dialog='button';
break;case 'checkbox':q.data.dialog='checkbox';break;case 'radio':q.data.dialog='radio';break;case 'image':q.data.dialog='imagebutton';break;default:q.data.dialog='textfield';break;}});},afterInit:function(m){var n=m.dataProcessor,o=n&&n.htmlFilter,p=n&&n.dataFilter;if(c)o&&o.addRules({elements:{input:function(q){var r=q.attributes,s=r.type;if(!s)r.type='text';if(s=='checkbox'||s=='radio')r.value=='on'&&delete r.value;}}});if(p)p.addRules({elements:{input:function(q){if(q.attributes.type=='hidden')return m.createFakeParserElement(q,'cke_hidden','hiddenfield');}}});},requires:['image','fakeobjects']});if(c)h.prototype.hasAttribute=e.override(h.prototype.hasAttribute,function(m){return function(n){var q=this;var o=q.$.attributes.getNamedItem(n);if(q.getName()=='input')switch(n){case 'class':return q.$.className.length>0;case 'checked':return!!q.$.checked;case 'value':var p=q.getAttribute('type');return p=='checkbox'||p=='radio'?q.$.value!='on':q.$.value;}return m.apply(q,arguments);};});(function(){var m={canUndo:false,exec:function(o){var p=o.document.createElement('hr');o.insertElement(p);}},n='horizontalrule';j.add(n,{init:function(o){o.addCommand(n,m);o.ui.addButton('HorizontalRule',{label:o.lang.horizontalrule,command:n});}});})();(function(){var m=/^[\t\r\n ]*(?:&nbsp;|\xa0)$/,n='{cke_protected}';function o(U){var V=U.children.length,W=U.children[V-1];while(W&&W.type==3&&!e.trim(W.value))W=U.children[--V];return W;};function p(U){var V=U.parent;return V?e.indexOf(V.children,U):-1;};function q(U,V){var W=U.children,X=o(U);if(X){if((V||!c)&&X.type==1&&X.name=='br')W.pop();if(X.type==3&&m.test(X.value))W.pop();}};function r(U,V,W){if(!V&&(!W||typeof W=='function'&&W(U)===false))return false;if(V&&c&&(document.documentMode>7||U.name in f.tr||U.name in f.$listItem))return false;var X=o(U);return!X||X&&(X.type==1&&X.name=='br'||U.name=='form'&&X.name=='input');};function s(U,V){return function(W){q(W,!U);if(r(W,!U,V))if(U||c)W.add(new a.htmlParser.text('\xa0'));else W.add(new a.htmlParser.element('br',{}));};};var t=f,u=['caption','colgroup','col','thead','tfoot','tbody'],v=e.extend({},t.$block,t.$listItem,t.$tableContent);for(var w in v){if(!('br' in t[w]))delete v[w];}delete v.pre;var x={elements:{},attributeNames:[[/^on/,'data-cke-pa-on']]},y={elements:{}};for(w in v)y.elements[w]=s();var z={elementNames:[[/^cke:/,''],[/^\?xml:namespace$/,'']],attributeNames:[[/^data-cke-(saved|pa)-/,''],[/^data-cke-.*/,''],['hidefocus','']],elements:{$:function(U){var V=U.attributes;
if(V){if(V['data-cke-temp'])return false;var W=['name','href','src'],X;for(var Y=0;Y<W.length;Y++){X='data-cke-saved-'+W[Y];X in V&&delete V[W[Y]];}}return U;},table:function(U){var V=U.children.slice(0);V.sort(function(W,X){var Y,Z;if(W.type==1&&X.type==W.type){Y=e.indexOf(u,W.name);Z=e.indexOf(u,X.name);}if(!(Y>-1&&Z>-1&&Y!=Z)){Y=p(W);Z=p(X);}return Y>Z?1:-1;});},embed:function(U){var V=U.parent;if(V&&V.name=='object'){var W=V.attributes.width,X=V.attributes.height;W&&(U.attributes.width=W);X&&(U.attributes.height=X);}},param:function(U){U.children=[];U.isEmpty=true;return U;},a:function(U){if(!(U.children.length||U.attributes.name||U.attributes['data-cke-saved-name']))return false;},span:function(U){if(U.attributes['class']=='Apple-style-span')delete U.name;},pre:function(U){c&&q(U);},html:function(U){delete U.attributes.contenteditable;delete U.attributes['class'];},body:function(U){delete U.attributes.spellcheck;delete U.attributes.contenteditable;},style:function(U){var V=U.children[0];V&&V.value&&(V.value=e.trim(V.value));if(!U.attributes.type)U.attributes.type='text/css';},title:function(U){var V=U.children[0];V&&(V.value=U.attributes['data-cke-title']||'');}},attributes:{'class':function(U,V){return e.ltrim(U.replace(/(?:^|\s+)cke_[^\s]*/g,''))||false;}}};if(c)z.attributes.style=function(U,V){return U.replace(/(^|;)([^\:]+)/g,function(W){return W.toLowerCase();});};function A(U){var V=U.attributes;if(V.contenteditable!='false')V['data-cke-editable']=V.contenteditable?'true':1;V.contenteditable='false';};function B(U){var V=U.attributes;switch(V['data-cke-editable']){case 'true':V.contenteditable='true';break;case '1':delete V.contenteditable;break;}};for(w in {input:1,textarea:1}){x.elements[w]=A;z.elements[w]=B;}var C=/<(a|area|img|input|source)\b([^>]*)>/gi,D=/\b(on\w+|href|src|name)\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|(?:[^ "'>]+))/gi,E=/(?:<style(?=[ >])[^>]*>[\s\S]*<\/style>)|(?:<(:?link|meta|base)[^>]*>)/gi,F=/<cke:encoded>([^<]*)<\/cke:encoded>/gi,G=/(<\/?)((?:object|embed|param|html|body|head|title)[^>]*>)/gi,H=/(<\/?)cke:((?:html|body|head|title)[^>]*>)/gi,I=/<cke:(param|embed)([^>]*?)\/?>(?!\s*<\/cke:\1)/gi;function J(U){return U.replace(C,function(V,W,X){return '<'+W+X.replace(D,function(Y,Z){if(!/^on/.test(Z)&&X.indexOf('data-cke-saved-'+Z)==-1)return ' data-cke-saved-'+Y+' data-cke-'+a.rnd+'-'+Y;return Y;})+'>';});};function K(U){return U.replace(E,function(V){return '<cke:encoded>'+encodeURIComponent(V)+'</cke:encoded>';});};function L(U){return U.replace(F,function(V,W){return decodeURIComponent(W);
});};function M(U){return U.replace(G,'$1cke:$2');};function N(U){return U.replace(H,'$1$2');};function O(U){return U.replace(I,'<cke:$1$2></cke:$1>');};function P(U){return U.replace(/(<pre\b[^>]*>)(\r\n|\n)/g,'$1$2$2');};function Q(U){return U.replace(/<!--(?!{cke_protected})[\s\S]+?-->/g,function(V){return '<!--'+n+'{C}'+encodeURIComponent(V).replace(/--/g,'%2D%2D')+'-->';});};function R(U){return U.replace(/<!--\{cke_protected\}\{C\}([\s\S]+?)-->/g,function(V,W){return decodeURIComponent(W);});};function S(U,V){var W=V._.dataStore;return U.replace(/<!--\{cke_protected\}([\s\S]+?)-->/g,function(X,Y){return decodeURIComponent(Y);}).replace(/\{cke_protected_(\d+)\}/g,function(X,Y){return W&&W[Y]||'';});};function T(U,V){var W=[],X=V.config.protectedSource,Y=V._.dataStore||(V._.dataStore={id:1}),Z=/<\!--\{cke_temp(comment)?\}(\d*?)-->/g,aa=[/<script[\s\S]*?<\/script>/gi,/<noscript[\s\S]*?<\/noscript>/gi].concat(X);U=U.replace(/<!--[\s\S]*?-->/g,function(ac){return '<!--{cke_tempcomment}'+(W.push(ac)-1)+'-->';});for(var ab=0;ab<aa.length;ab++)U=U.replace(aa[ab],function(ac){ac=ac.replace(Z,function(ad,ae,af){return W[af];});return/cke_temp(comment)?/.test(ac)?ac:'<!--{cke_temp}'+(W.push(ac)-1)+'-->';});U=U.replace(Z,function(ac,ad,ae){return '<!--'+n+(ad?'{C}':'')+encodeURIComponent(W[ae]).replace(/--/g,'%2D%2D')+'-->';});return U.replace(/(['"]).*?\1/g,function(ac){return ac.replace(/<!--\{cke_protected\}([\s\S]+?)-->/g,function(ad,ae){Y[Y.id]=decodeURIComponent(ae);return '{cke_protected_'+Y.id++ +'}';});});};j.add('htmldataprocessor',{requires:['htmlwriter'],init:function(U){var V=U.dataProcessor=new a.htmlDataProcessor(U);V.writer.forceSimpleAmpersand=U.config.forceSimpleAmpersand;V.dataFilter.addRules(x);V.dataFilter.addRules(y);V.htmlFilter.addRules(z);var W={elements:{}};for(w in v)W.elements[w]=s(true,U.config.fillEmptyBlocks);V.htmlFilter.addRules(W);},onLoad:function(){!('fillEmptyBlocks' in i)&&(i.fillEmptyBlocks=1);}});a.htmlDataProcessor=function(U){var V=this;V.editor=U;V.writer=new a.htmlWriter();V.dataFilter=new a.htmlParser.filter();V.htmlFilter=new a.htmlParser.filter();};a.htmlDataProcessor.prototype={toHtml:function(U,V){U=T(U,this.editor);U=J(U);U=K(U);U=M(U);U=O(U);U=P(U);var W=new h('div');W.setHtml('a'+U);U=W.getHtml().substr(1);U=U.replace(new RegExp(' data-cke-'+a.rnd+'-','ig'),' ');U=N(U);U=L(U);U=R(U);var X=a.htmlParser.fragment.fromHtml(U,V),Y=new a.htmlParser.basicWriter();X.writeHtml(Y,this.dataFilter);U=Y.getHtml(true);U=Q(U);
return U;},toDataFormat:function(U,V){var W=this.writer,X=a.htmlParser.fragment.fromHtml(U,V);W.reset();X.writeHtml(W,this.htmlFilter);var Y=W.getHtml(true);Y=R(Y);Y=S(Y,this.editor);return Y;}};})();(function(){j.add('iframe',{requires:['dialog','fakeobjects'],init:function(m){var n='iframe',o=m.lang.iframe;a.dialog.add(n,this.path+'dialogs/iframe.js');m.addCommand(n,new a.dialogCommand(n));m.addCss('img.cke_iframe{background-image: url('+a.getUrl(this.path+'images/placeholder.png')+');'+'background-position: center center;'+'background-repeat: no-repeat;'+'border: 1px solid #a9a9a9;'+'width: 80px;'+'height: 80px;'+'}');m.ui.addButton('Iframe',{label:o.toolbar,command:n});m.on('doubleclick',function(p){var q=p.data.element;if(q.is('img')&&q.data('cke-real-element-type')=='iframe')p.data.dialog='iframe';});if(m.addMenuItems)m.addMenuItems({iframe:{label:o.title,command:'iframe',group:'image'}});if(m.contextMenu)m.contextMenu.addListener(function(p,q){if(p&&p.is('img')&&p.data('cke-real-element-type')=='iframe')return{iframe:2};});},afterInit:function(m){var n=m.dataProcessor,o=n&&n.dataFilter;if(o)o.addRules({elements:{iframe:function(p){return m.createFakeParserElement(p,'cke_iframe','iframe',true);}}});}});})();(function(){j.add('image',{requires:['dialog'],init:function(o){var p='image';a.dialog.add(p,this.path+'dialogs/image.js');o.addCommand(p,new a.dialogCommand(p));o.ui.addButton('Image',{label:o.lang.common.image,command:p});o.on('doubleclick',function(q){var r=q.data.element;if(r.is('img')&&!r.data('cke-realelement')&&!r.isReadOnly())q.data.dialog='image';});if(o.addMenuItems)o.addMenuItems({image:{label:o.lang.image.menu,command:'image',group:'image'}});if(o.contextMenu)o.contextMenu.addListener(function(q,r){if(m(o,q))return{image:2};});},afterInit:function(o){p('left');p('right');p('center');p('block');function p(q){var r=o.getCommand('justify'+q);if(r){if(q=='left'||q=='right')r.on('exec',function(s){var t=m(o),u;if(t){u=n(t);if(u==q){t.removeStyle('float');if(q==n(t))t.removeAttribute('align');}else t.setStyle('float',q);s.cancel();}});r.on('refresh',function(s){var t=m(o),u;if(t){u=n(t);this.setState(u==q?1:q=='right'||q=='left'?2:0);s.cancel();}});}};}});function m(o,p){if(!p){var q=o.getSelection();p=q.getType()==3&&q.getSelectedElement();}if(p&&p.is('img')&&!p.data('cke-realelement')&&!p.isReadOnly())return p;};function n(o){var p=o.getStyle('float');if(p=='inherit'||p=='none')p=0;if(!p)p=o.getAttribute('align');return p;};})();i.image_removeLinkByEmptyURL=true;
(function(){var m={ol:1,ul:1},n=d.walker.whitespaces(true),o=d.walker.bookmark(false,true);function p(t){var B=this;if(t.editor.readOnly)return null;var u=t.editor,v=t.data.path,w=v&&v.contains(m),x=v.block||v.blockLimit;if(w)return B.setState(2);if(!B.useIndentClasses&&B.name=='indent')return B.setState(2);if(!x)return B.setState(0);if(B.useIndentClasses){var y=x.$.className.match(B.classNameRegex),z=0;if(y){y=y[1];z=B.indentClassMap[y];}if(B.name=='outdent'&&!z||B.name=='indent'&&z==u.config.indentClasses.length)return B.setState(0);return B.setState(2);}else{var A=parseInt(x.getStyle(r(x)),10);if(isNaN(A))A=0;if(A<=0)return B.setState(0);return B.setState(2);}};function q(t,u){var w=this;w.name=u;w.useIndentClasses=t.config.indentClasses&&t.config.indentClasses.length>0;if(w.useIndentClasses){w.classNameRegex=new RegExp('(?:^|\\s+)('+t.config.indentClasses.join('|')+')(?=$|\\s)');w.indentClassMap={};for(var v=0;v<t.config.indentClasses.length;v++)w.indentClassMap[t.config.indentClasses[v]]=v+1;}w.startDisabled=u=='outdent';};function r(t,u){return(u||t.getComputedStyle('direction'))=='ltr'?'margin-left':'margin-right';};function s(t){return t.type==1&&t.is('li');};q.prototype={exec:function(t){var u=this,v={};function w(M){var N=C.startContainer,O=C.endContainer;while(N&&!N.getParent().equals(M))N=N.getParent();while(O&&!O.getParent().equals(M))O=O.getParent();if(!N||!O)return;var P=N,Q=[],R=false;while(!R){if(P.equals(O))R=true;Q.push(P);P=P.getNext();}if(Q.length<1)return;var S=M.getParents(true);for(var T=0;T<S.length;T++){if(S[T].getName&&m[S[T].getName()]){M=S[T];break;}}var U=u.name=='indent'?1:-1,V=Q[0],W=Q[Q.length-1],X=j.list.listToArray(M,v),Y=X[W.getCustomData('listarray_index')].indent;for(T=V.getCustomData('listarray_index');T<=W.getCustomData('listarray_index');T++){X[T].indent+=U;if(U>0){var Z=X[T].parent;X[T].parent=new h(Z.getName(),Z.getDocument());}}for(T=W.getCustomData('listarray_index')+1;T<X.length&&X[T].indent>Y;T++)X[T].indent+=U;var aa=j.list.arrayToList(X,v,null,t.config.enterMode,M.getDirection());if(u.name=='outdent'){var ab;if((ab=M.getParent())&&ab.is('li')){var ac=aa.listNode.getChildren(),ad=[],ae=ac.count(),af;for(T=ae-1;T>=0;T--){if((af=ac.getItem(T))&&af.is&&af.is('li'))ad.push(af);}}}if(aa)aa.listNode.replace(M);if(ad&&ad.length)for(T=0;T<ad.length;T++){var ag=ad[T],ah=ag;while((ah=ah.getNext())&&ah.is&&ah.getName() in m){if(c&&!ag.getFirst(function(ai){return n(ai)&&o(ai);}))ag.append(C.document.createText('\xa0'));ag.append(ah);
}ag.insertAfter(ab);}};function x(){var M=C.createIterator(),N=t.config.enterMode;M.enforceRealBlocks=true;M.enlargeBr=N!=2;var O;while(O=M.getNextParagraph(N==1?'p':'div'))y(O);};function y(M,N){if(M.getCustomData('indent_processed'))return false;if(u.useIndentClasses){var O=M.$.className.match(u.classNameRegex),P=0;if(O){O=O[1];P=u.indentClassMap[O];}if(u.name=='outdent')P--;else P++;if(P<0)return false;P=Math.min(P,t.config.indentClasses.length);P=Math.max(P,0);M.$.className=e.ltrim(M.$.className.replace(u.classNameRegex,''));if(P>0)M.addClass(t.config.indentClasses[P-1]);}else{var Q=r(M,N),R=parseInt(M.getStyle(Q),10);if(isNaN(R))R=0;var S=t.config.indentOffset||40;R+=(u.name=='indent'?1:-1)*S;if(R<0)return false;R=Math.max(R,0);R=Math.ceil(R/S)*S;M.setStyle(Q,R?R+(t.config.indentUnit||'px'):'');if(M.getAttribute('style')==='')M.removeAttribute('style');}h.setMarker(v,M,'indent_processed',1);return true;};var z=t.getSelection(),A=z.createBookmarks(1),B=z&&z.getRanges(1),C,D=B.createIterator();while(C=D.getNextRange()){var E=C.getCommonAncestor(),F=E;while(F&&!(F.type==1&&m[F.getName()]))F=F.getParent();if(!F){var G=C.getEnclosedNode();if(G&&G.type==1&&G.getName() in m){C.setStartAt(G,1);C.setEndAt(G,2);F=G;}}if(F&&C.startContainer.type==1&&C.startContainer.getName() in m){var H=new d.walker(C);H.evaluator=s;C.startContainer=H.next();}if(F&&C.endContainer.type==1&&C.endContainer.getName() in m){H=new d.walker(C);H.evaluator=s;C.endContainer=H.previous();}if(F){var I=F.getFirst(s),J=!!I.getNext(s),K=C.startContainer,L=I.equals(K)||I.contains(K);if(!(L&&(u.name=='indent'||u.useIndentClasses||parseInt(F.getStyle(r(F)),10))&&y(F,!J&&I.getDirection())))w(F);}else x();}h.clearAllMarkers(v);t.forceNextSelectionCheck();z.selectBookmarks(A);}};j.add('indent',{init:function(t){var u=t.addCommand('indent',new q(t,'indent')),v=t.addCommand('outdent',new q(t,'outdent'));t.ui.addButton('Indent',{label:t.lang.indent,command:'indent'});t.ui.addButton('Outdent',{label:t.lang.outdent,command:'outdent'});t.on('selectionChange',e.bind(p,u));t.on('selectionChange',e.bind(p,v));if(b.ie6Compat||b.ie7Compat)t.addCss('ul,ol{\tmargin-left: 0px;\tpadding-left: 40px;}');t.on('dirChanged',function(w){var x=new d.range(t.document);x.setStartBefore(w.data.node);x.setEndAfter(w.data.node);var y=new d.walker(x),z;while(z=y.next()){if(z.type==1){if(!z.equals(w.data.node)&&z.getDirection()){x.setStartAfter(z);y=new d.walker(x);continue;}var A=t.config.indentClasses;if(A){var B=w.data.dir=='ltr'?['_rtl','']:['','_rtl'];
for(var C=0;C<A.length;C++){if(z.hasClass(A[C]+B[0])){z.removeClass(A[C]+B[0]);z.addClass(A[C]+B[1]);}}}var D=z.getStyle('margin-right'),E=z.getStyle('margin-left');D?z.setStyle('margin-left',D):z.removeStyle('margin-left');E?z.setStyle('margin-right',E):z.removeStyle('margin-right');}}});},requires:['domiterator','list']});})();(function(){function m(q,r){r=r===undefined||r;var s;if(r)s=q.getComputedStyle('text-align');else{while(!q.hasAttribute||!(q.hasAttribute('align')||q.getStyle('text-align'))){var t=q.getParent();if(!t)break;q=t;}s=q.getStyle('text-align')||q.getAttribute('align')||'';}s&&(s=s.replace(/(?:-(?:moz|webkit)-)?(?:start|auto)/i,''));!s&&r&&(s=q.getComputedStyle('direction')=='rtl'?'right':'left');return s;};function n(q){if(q.editor.readOnly)return;q.editor.getCommand(this.name).refresh(q.data.path);};function o(q,r,s){var u=this;u.editor=q;u.name=r;u.value=s;var t=q.config.justifyClasses;if(t){switch(s){case 'left':u.cssClassName=t[0];break;case 'center':u.cssClassName=t[1];break;case 'right':u.cssClassName=t[2];break;case 'justify':u.cssClassName=t[3];break;}u.cssClassRegex=new RegExp('(?:^|\\s+)(?:'+t.join('|')+')(?=$|\\s)');}};function p(q){var r=q.editor,s=new d.range(r.document);s.setStartBefore(q.data.node);s.setEndAfter(q.data.node);var t=new d.walker(s),u;while(u=t.next()){if(u.type==1){if(!u.equals(q.data.node)&&u.getDirection()){s.setStartAfter(u);t=new d.walker(s);continue;}var v=r.config.justifyClasses;if(v)if(u.hasClass(v[0])){u.removeClass(v[0]);u.addClass(v[2]);}else if(u.hasClass(v[2])){u.removeClass(v[2]);u.addClass(v[0]);}var w='text-align',x=u.getStyle(w);if(x=='left')u.setStyle(w,'right');else if(x=='right')u.setStyle(w,'left');}}};o.prototype={exec:function(q){var C=this;var r=q.getSelection(),s=q.config.enterMode;if(!r)return;var t=r.createBookmarks(),u=r.getRanges(true),v=C.cssClassName,w,x,y=q.config.useComputedState;y=y===undefined||y;for(var z=u.length-1;z>=0;z--){w=u[z].createIterator();w.enlargeBr=s!=2;while(x=w.getNextParagraph(s==1?'p':'div')){x.removeAttribute('align');x.removeStyle('text-align');var A=v&&(x.$.className=e.ltrim(x.$.className.replace(C.cssClassRegex,''))),B=C.state==2&&(!y||m(x,true)!=C.value);if(v){if(B)x.addClass(v);else if(!A)x.removeAttribute('class');}else if(B)x.setStyle('text-align',C.value);}}q.focus();q.forceNextSelectionCheck();r.selectBookmarks(t);},refresh:function(q){var r=q.block||q.blockLimit;this.setState(r.getName()!='body'&&m(r,this.editor.config.useComputedState)==this.value?1:2);
}};j.add('justify',{init:function(q){var r=new o(q,'justifyleft','left'),s=new o(q,'justifycenter','center'),t=new o(q,'justifyright','right'),u=new o(q,'justifyblock','justify');q.addCommand('justifyleft',r);q.addCommand('justifycenter',s);q.addCommand('justifyright',t);q.addCommand('justifyblock',u);q.ui.addButton('JustifyLeft',{label:q.lang.justify.left,command:'justifyleft'});q.ui.addButton('JustifyCenter',{label:q.lang.justify.center,command:'justifycenter'});q.ui.addButton('JustifyRight',{label:q.lang.justify.right,command:'justifyright'});q.ui.addButton('JustifyBlock',{label:q.lang.justify.block,command:'justifyblock'});q.on('selectionChange',e.bind(n,r));q.on('selectionChange',e.bind(n,t));q.on('selectionChange',e.bind(n,s));q.on('selectionChange',e.bind(n,u));q.on('dirChanged',p);},requires:['domiterator']});})();j.add('keystrokes',{beforeInit:function(m){m.keystrokeHandler=new a.keystrokeHandler(m);m.specialKeys={};},init:function(m){var n=m.config.keystrokes,o=m.config.blockedKeystrokes,p=m.keystrokeHandler.keystrokes,q=m.keystrokeHandler.blockedKeystrokes;for(var r=0;r<n.length;r++)p[n[r][0]]=n[r][1];for(r=0;r<o.length;r++)q[o[r]]=1;}});a.keystrokeHandler=function(m){var n=this;if(m.keystrokeHandler)return m.keystrokeHandler;n.keystrokes={};n.blockedKeystrokes={};n._={editor:m};return n;};(function(){var m,n=function(p){p=p.data;var q=p.getKeystroke(),r=this.keystrokes[q],s=this._.editor;m=s.fire('key',{keyCode:q})===true;if(!m){if(r){var t={from:'keystrokeHandler'};m=s.execCommand(r,t)!==false;}if(!m){var u=s.specialKeys[q];m=u&&u(s)===true;if(!m)m=!!this.blockedKeystrokes[q];}}if(m)p.preventDefault(true);return!m;},o=function(p){if(m){m=false;p.data.preventDefault(true);}};a.keystrokeHandler.prototype={attach:function(p){p.on('keydown',n,this);if(b.opera||b.gecko&&b.mac)p.on('keypress',o,this);}};})();i.blockedKeystrokes=[1114112+66,1114112+73,1114112+85];i.keystrokes=[[4456448+121,'toolbarFocus'],[4456448+122,'elementsPathFocus'],[2228224+121,'contextMenu'],[1114112+2228224+121,'contextMenu'],[1114112+90,'undo'],[1114112+89,'redo'],[1114112+2228224+90,'redo'],[1114112+76,'link'],[1114112+66,'bold'],[1114112+73,'italic'],[1114112+85,'underline'],[4456448+(c||b.webkit?189:109),'toolbarCollapse'],[4456448+48,'a11yHelp']];j.add('link',{requires:['fakeobjects','dialog'],init:function(m){m.addCommand('link',new a.dialogCommand('link'));m.addCommand('anchor',new a.dialogCommand('anchor'));m.addCommand('unlink',new a.unlinkCommand());m.addCommand('removeAnchor',new a.removeAnchorCommand());
m.ui.addButton('Link',{label:m.lang.link.toolbar,command:'link'});m.ui.addButton('Unlink',{label:m.lang.unlink,command:'unlink'});m.ui.addButton('Anchor',{label:m.lang.anchor.toolbar,command:'anchor'});a.dialog.add('link',this.path+'dialogs/link.js');a.dialog.add('anchor',this.path+'dialogs/anchor.js');var n=m.lang.dir=='rtl'?'right':'left',o='background:url('+a.getUrl(this.path+'images/anchor.gif')+') no-repeat '+n+' center;'+'border:1px dotted #00f;';m.addCss('a.cke_anchor,a.cke_anchor_empty'+(c&&b.version<7?'':',a[name],a[data-cke-saved-name]')+'{'+o+'padding-'+n+':18px;'+'cursor:auto;'+'}'+(c?'a.cke_anchor_empty{display:inline-block;}':'')+'img.cke_anchor'+'{'+o+'width:16px;'+'min-height:15px;'+'height:1.15em;'+'vertical-align:'+(b.opera?'middle':'text-bottom')+';'+'}');m.on('selectionChange',function(p){if(m.readOnly)return;var q=m.getCommand('unlink'),r=p.data.path.lastElement&&p.data.path.lastElement.getAscendant('a',true);if(r&&r.getName()=='a'&&r.getAttribute('href')&&r.getChildCount())q.setState(2);else q.setState(0);});m.on('doubleclick',function(p){var q=j.link.getSelectedLink(m)||p.data.element;if(!q.isReadOnly())if(q.is('a')){p.data.dialog=q.getAttribute('name')&&(!q.getAttribute('href')||!q.getChildCount())?'anchor':'link';m.getSelection().selectElement(q);}else if(j.link.tryRestoreFakeAnchor(m,q))p.data.dialog='anchor';});if(m.addMenuItems)m.addMenuItems({anchor:{label:m.lang.anchor.menu,command:'anchor',group:'anchor',order:1},removeAnchor:{label:m.lang.anchor.remove,command:'removeAnchor',group:'anchor',order:5},link:{label:m.lang.link.menu,command:'link',group:'link',order:1},unlink:{label:m.lang.unlink,command:'unlink',group:'link',order:5}});if(m.contextMenu)m.contextMenu.addListener(function(p,q){if(!p||p.isReadOnly())return null;var r=j.link.tryRestoreFakeAnchor(m,p);if(!r&&!(r=j.link.getSelectedLink(m)))return null;var s={};if(r.getAttribute('href')&&r.getChildCount())s={link:2,unlink:2};if(r&&r.hasAttribute('name'))s.anchor=s.removeAnchor=2;return s;});},afterInit:function(m){var n=m.dataProcessor,o=n&&n.dataFilter,p=n&&n.htmlFilter,q=m._.elementsPath&&m._.elementsPath.filters;if(o)o.addRules({elements:{a:function(r){var s=r.attributes;if(!s.name)return null;var t=!r.children.length;if(j.link.synAnchorSelector){var u=t?'cke_anchor_empty':'cke_anchor',v=s['class'];if(s.name&&(!v||v.indexOf(u)<0))s['class']=(v||'')+' '+u;if(t&&j.link.emptyAnchorFix){s.contenteditable='false';s['data-cke-editable']=1;}}else if(j.link.fakeAnchor&&t)return m.createFakeParserElement(r,'cke_anchor','anchor');
return null;}}});if(j.link.emptyAnchorFix&&p)p.addRules({elements:{a:function(r){delete r.attributes.contenteditable;}}});if(q)q.push(function(r,s){if(s=='a')if(j.link.tryRestoreFakeAnchor(m,r)||r.getAttribute('name')&&(!r.getAttribute('href')||!r.getChildCount()))return 'anchor';});}});j.link={getSelectedLink:function(m){try{var n=m.getSelection();if(n.getType()==3){var o=n.getSelectedElement();if(o.is('a'))return o;}var p=n.getRanges(true)[0];p.shrink(2);var q=p.getCommonAncestor();return q.getAscendant('a',true);}catch(r){return null;}},fakeAnchor:b.opera||b.webkit,synAnchorSelector:c,emptyAnchorFix:c&&b.version<8,tryRestoreFakeAnchor:function(m,n){if(n&&n.data('cke-real-element-type')&&n.data('cke-real-element-type')=='anchor'){var o=m.restoreRealElement(n);if(o.data('cke-saved-name'))return o;}}};a.unlinkCommand=function(){};a.unlinkCommand.prototype={exec:function(m){var n=m.getSelection(),o=n.createBookmarks(),p=n.getRanges(),q,r;for(var s=0;s<p.length;s++){q=p[s].getCommonAncestor(true);r=q.getAscendant('a',true);if(!r)continue;p[s].selectNodeContents(r);}n.selectRanges(p);m.document.$.execCommand('unlink',false,null);n.selectBookmarks(o);},startDisabled:true};a.removeAnchorCommand=function(){};a.removeAnchorCommand.prototype={exec:function(m){var n=m.getSelection(),o=n.createBookmarks(),p;if(n&&(p=n.getSelectedElement())&&(j.link.fakeAnchor&&!p.getChildCount()?j.link.tryRestoreFakeAnchor(m,p):p.is('a')))p.remove(1);else if(p=j.link.getSelectedLink(m))if(p.hasAttribute('href')){p.removeAttributes({name:1,'data-cke-saved-name':1});p.removeClass('cke_anchor');}else p.remove(1);n.selectBookmarks(o);}};e.extend(i,{linkShowAdvancedTab:true,linkShowTargetTab:true});(function(){var m={ol:1,ul:1},n=/^[\n\r\t ]*$/,o=d.walker.whitespaces(),p=d.walker.bookmark(),q=function(N){return!(o(N)||p(N));},r=d.walker.bogus();function s(N){var O,P,Q;if(O=N.getDirection()){P=N.getParent();while(P&&!(Q=P.getDirection()))P=P.getParent();if(O==Q)N.removeAttribute('dir');}};function t(N,O){var P=N.getAttribute('style');P&&O.setAttribute('style',P.replace(/([^;])$/,'$1;')+(O.getAttribute('style')||''));};j.list={listToArray:function(N,O,P,Q,R){if(!m[N.getName()])return[];if(!Q)Q=0;if(!P)P=[];for(var S=0,T=N.getChildCount();S<T;S++){var U=N.getChild(S);if(U.type==1&&U.getName() in f.$list)j.list.listToArray(U,O,P,Q+1);if(U.$.nodeName.toLowerCase()!='li')continue;var V={parent:N,indent:Q,element:U,contents:[]};if(!R){V.grandparent=N.getParent();if(V.grandparent&&V.grandparent.$.nodeName.toLowerCase()=='li')V.grandparent=V.grandparent.getParent();
}else V.grandparent=R;if(O)h.setMarker(O,U,'listarray_index',P.length);P.push(V);for(var W=0,X=U.getChildCount(),Y;W<X;W++){Y=U.getChild(W);if(Y.type==1&&m[Y.getName()])j.list.listToArray(Y,O,P,Q+1,V.grandparent);else V.contents.push(Y);}}return P;},arrayToList:function(N,O,P,Q,R){if(!P)P=0;if(!N||N.length<P+1)return null;var S,T=N[P].parent.getDocument(),U=new d.documentFragment(T),V=null,W=P,X=Math.max(N[P].indent,0),Y=null,Z,aa,ab=Q==1?'p':'div';while(1){var ac=N[W],ad=ac.grandparent;Z=ac.element.getDirection(1);if(ac.indent==X){if(!V||N[W].parent.getName()!=V.getName()){V=N[W].parent.clone(false,1);R&&V.setAttribute('dir',R);U.append(V);}Y=V.append(ac.element.clone(0,1));if(Z!=V.getDirection(1))Y.setAttribute('dir',Z);for(S=0;S<ac.contents.length;S++)Y.append(ac.contents[S].clone(1,1));W++;}else if(ac.indent==Math.max(X,0)+1){var ae=N[W-1].element.getDirection(1),af=j.list.arrayToList(N,null,W,Q,ae!=Z?Z:null);if(!Y.getChildCount()&&c&&!(T.$.documentMode>7))Y.append(T.createText('\xa0'));Y.append(af.listNode);W=af.nextIndex;}else if(ac.indent==-1&&!P&&ad){if(m[ad.getName()]){Y=ac.element.clone(false,true);if(Z!=ad.getDirection(1))Y.setAttribute('dir',Z);}else Y=new d.documentFragment(T);var ag=ad.getDirection(1)!=Z,ah=ac.element,ai=ah.getAttribute('class'),aj=ah.getAttribute('style'),ak=Y.type==11&&(Q!=2||ag||aj||ai),al,am=ac.contents.length;for(S=0;S<am;S++){al=ac.contents[S];if(al.type==1&&al.isBlockBoundary()){if(ag&&!al.getDirection())al.setAttribute('dir',Z);t(ah,al);ai&&al.addClass(ai);}else if(ak){if(!aa){aa=T.createElement(ab);ag&&aa.setAttribute('dir',Z);}aj&&aa.setAttribute('style',aj);ai&&aa.setAttribute('class',ai);aa.append(al.clone(1,1));}Y.append(aa||al.clone(1,1));}if(Y.type==11&&W!=N.length-1){var an=Y.getLast();if(an&&an.type==1&&an.getAttribute('type')=='_moz')an.remove();if(!(an=Y.getLast(q)&&an.type==1&&an.getName() in f.$block))Y.append(T.createElement('br'));}var ao=Y.$.nodeName.toLowerCase();if(!c&&(ao=='div'||ao=='p'))Y.appendBogus();U.append(Y);V=null;W++;}else return null;aa=null;if(N.length<=W||Math.max(N[W].indent,0)<X)break;}if(O){var ap=U.getFirst(),aq=N[0].parent;while(ap){if(ap.type==1){h.clearMarkers(O,ap);if(ap.getName() in f.$listItem)s(ap);}ap=ap.getNextSourceNode();}}return{listNode:U,nextIndex:W};}};function u(N){if(N.editor.readOnly)return null;var O=N.data.path,P=O.blockLimit,Q=O.elements,R,S;for(S=0;S<Q.length&&(R=Q[S])&&!R.equals(P);S++){if(m[Q[S].getName()])return this.setState(this.type==Q[S].getName()?1:2);}return this.setState(2);
};function v(N,O,P,Q){var R=j.list.listToArray(O.root,P),S=[];for(var T=0;T<O.contents.length;T++){var U=O.contents[T];U=U.getAscendant('li',true);if(!U||U.getCustomData('list_item_processed'))continue;S.push(U);h.setMarker(P,U,'list_item_processed',true);}var V=O.root,W=V.getDocument(),X,Y;for(T=0;T<S.length;T++){var Z=S[T].getCustomData('listarray_index');X=R[Z].parent;if(!X.is(this.type)){Y=W.createElement(this.type);X.copyAttributes(Y,{start:1,type:1});Y.removeStyle('list-style-type');R[Z].parent=Y;}}var aa=j.list.arrayToList(R,P,null,N.config.enterMode),ab,ac=aa.listNode.getChildCount();for(T=0;T<ac&&(ab=aa.listNode.getChild(T));T++){if(ab.getName()==this.type)Q.push(ab);}aa.listNode.replace(O.root);};var w=/^h[1-6]$/;function x(N,O,P){var Q=O.contents,R=O.root.getDocument(),S=[];if(Q.length==1&&Q[0].equals(O.root)){var T=R.createElement('div');Q[0].moveChildren&&Q[0].moveChildren(T);Q[0].append(T);Q[0]=T;}var U=O.contents[0].getParent();for(var V=0;V<Q.length;V++)U=U.getCommonAncestor(Q[V].getParent());var W=N.config.useComputedState,X,Y;W=W===undefined||W;for(V=0;V<Q.length;V++){var Z=Q[V],aa;while(aa=Z.getParent()){if(aa.equals(U)){S.push(Z);if(!Y&&Z.getDirection())Y=1;var ab=Z.getDirection(W);if(X!==null)if(X&&X!=ab)X=null;else X=ab;break;}Z=aa;}}if(S.length<1)return;var ac=S[S.length-1].getNext(),ad=R.createElement(this.type);P.push(ad);var ae,af;while(S.length){ae=S.shift();af=R.createElement('li');if(ae.is('pre')||w.test(ae.getName()))ae.appendTo(af);else{ae.copyAttributes(af);if(X&&ae.getDirection()){af.removeStyle('direction');af.removeAttribute('dir');}ae.moveChildren(af);ae.remove();}af.appendTo(ad);}if(X&&Y)ad.setAttribute('dir',X);if(ac)ad.insertBefore(ac);else ad.appendTo(U);};function y(N,O,P){var Q=j.list.listToArray(O.root,P),R=[];for(var S=0;S<O.contents.length;S++){var T=O.contents[S];T=T.getAscendant('li',true);if(!T||T.getCustomData('list_item_processed'))continue;R.push(T);h.setMarker(P,T,'list_item_processed',true);}var U=null;for(S=0;S<R.length;S++){var V=R[S].getCustomData('listarray_index');Q[V].indent=-1;U=V;}for(S=U+1;S<Q.length;S++){if(Q[S].indent>Q[S-1].indent+1){var W=Q[S-1].indent+1-Q[S].indent,X=Q[S].indent;while(Q[S]&&Q[S].indent>=X){Q[S].indent+=W;S++;}S--;}}var Y=j.list.arrayToList(Q,P,null,N.config.enterMode,O.root.getAttribute('dir')),Z=Y.listNode,aa,ab;function ac(ad){if((aa=Z[ad?'getFirst':'getLast']())&&!(aa.is&&aa.isBlockBoundary())&&(ab=O.root[ad?'getPrevious':'getNext'](d.walker.whitespaces(true)))&&!(ab.is&&ab.isBlockBoundary({br:1})))N.document.createElement('br')[ad?'insertBefore':'insertAfter'](aa);
};ac(true);ac();Z.replace(O.root);};function z(N,O){this.name=N;this.type=O;};var A=d.walker.nodeType(1);function B(N,O,P,Q){var R,S;while(R=N[Q?'getLast':'getFirst'](A)){if((S=R.getDirection(1))!==O.getDirection(1))R.setAttribute('dir',S);R.remove();P?R[Q?'insertBefore':'insertAfter'](P):O.append(R,Q);}};z.prototype={exec:function(N){var aq=this;var O=N.document,P=N.config,Q=N.getSelection(),R=Q&&Q.getRanges(true);if(!R||R.length<1)return;if(aq.state==2){var S=O.getBody();if(!S.getFirst(q)){P.enterMode==2?S.appendBogus():R[0].fixBlock(1,P.enterMode==1?'p':'div');Q.selectRanges(R);}else{var T=R.length==1&&R[0],U=T&&T.getEnclosedNode();if(U&&U.is&&aq.type==U.getName())aq.setState(1);}}var V=Q.createBookmarks(true),W=[],X={},Y=R.createIterator(),Z=0;while((T=Y.getNextRange())&&++Z){var aa=T.getBoundaryNodes(),ab=aa.startNode,ac=aa.endNode;if(ab.type==1&&ab.getName()=='td')T.setStartAt(aa.startNode,1);if(ac.type==1&&ac.getName()=='td')T.setEndAt(aa.endNode,2);var ad=T.createIterator(),ae;ad.forceBrBreak=aq.state==2;while(ae=ad.getNextParagraph()){if(ae.getCustomData('list_block'))continue;else h.setMarker(X,ae,'list_block',1);var af=new d.elementPath(ae),ag=af.elements,ah=ag.length,ai=null,aj=0,ak=af.blockLimit,al;for(var am=ah-1;am>=0&&(al=ag[am]);am--){if(m[al.getName()]&&ak.contains(al)){ak.removeCustomData('list_group_object_'+Z);var an=al.getCustomData('list_group_object');if(an)an.contents.push(ae);else{an={root:al,contents:[ae]};W.push(an);h.setMarker(X,al,'list_group_object',an);}aj=1;break;}}if(aj)continue;var ao=ak;if(ao.getCustomData('list_group_object_'+Z))ao.getCustomData('list_group_object_'+Z).contents.push(ae);else{an={root:ao,contents:[ae]};h.setMarker(X,ao,'list_group_object_'+Z,an);W.push(an);}}}var ap=[];while(W.length>0){an=W.shift();if(aq.state==2){if(m[an.root.getName()])v.call(aq,N,an,X,ap);else x.call(aq,N,an,ap);}else if(aq.state==1&&m[an.root.getName()])y.call(aq,N,an,X);}for(am=0;am<ap.length;am++)C(ap[am]);h.clearAllMarkers(X);Q.selectBookmarks(V);N.focus();}};function C(N){var O;(O=function(P){var Q=N[P?'getPrevious':'getNext'](q);if(Q&&Q.type==1&&Q.is(N.getName())){B(N,Q,null,!P);N.remove();N=Q;}})();O(1);};var D=f,E=/[\t\r\n ]*(?:&nbsp;|\xa0)$/;function F(N,O){var P,Q=N.children,R=Q.length;for(var S=0;S<R;S++){P=Q[S];if(P.name&&P.name in O)return S;}return R;};function G(N){return function(O){var P=O.children,Q=F(O,D.$list),R=P[Q],S=R&&R.previous,T;if(S&&(S.name&&S.name=='br'||S.value&&(T=S.value.match(E)))){var U=S;if(!(T&&T.index)&&U==P[0])P[0]=N||c?new a.htmlParser.text('\xa0'):new a.htmlParser.element('br',{});
else if(U.name=='br')P.splice(Q-1,1);else U.value=U.value.replace(E,'');}};};var H={elements:{}};for(var I in D.$listItem)H.elements[I]=G();var J={elements:{}};for(I in D.$listItem)J.elements[I]=G(true);function K(N){return N.type==1&&(N.getName() in f.$block||N.getName() in f.$listItem)&&f[N.getName()]['#'];};function L(N,O,P){N.fire('saveSnapshot');P.enlarge(3);var Q=P.extractContents();O.trim(false,true);var R=O.createBookmark(),S=new d.elementPath(O.startContainer),T=S.block,U=S.lastElement.getAscendant('li',1)||T,V=new d.elementPath(P.startContainer),W=V.contains(f.$listItem),X=V.contains(f.$list),Y;if(T){var Z=T.getBogus();Z&&Z.remove();}else if(X){Y=X.getPrevious(q);if(Y&&r(Y))Y.remove();}Y=Q.getLast();if(Y&&Y.type==1&&Y.is('br'))Y.remove();var aa=O.startContainer.getChild(O.startOffset);if(aa)Q.insertBefore(aa);else O.startContainer.append(Q);if(W){var ab=M(W);if(ab)if(U.contains(W)){B(ab,W.getParent(),W);ab.remove();}else U.append(ab);}while(P.checkStartOfBlock()&&P.checkEndOfBlock()){V=new d.elementPath(P.startContainer);var ac=V.block,ad;if(ac.is('li')){ad=ac.getParent();if(ac.equals(ad.getLast(q))&&ac.equals(ad.getFirst(q)))ac=ad;}P.moveToPosition(ac,3);ac.remove();}var ae=P.clone(),af=N.document.getBody();ae.setEndAt(af,2);var ag=new d.walker(ae);ag.evaluator=function(ai){return q(ai)&&!r(ai);};var ah=ag.next();if(ah&&ah.type==1&&ah.getName() in f.$list)C(ah);O.moveToBookmark(R);O.select();N.selectionChange(1);N.fire('saveSnapshot');};function M(N){var O=N.getLast(q);return O&&O.type==1&&O.getName() in m?O:null;};j.add('list',{init:function(N){var O=N.addCommand('numberedlist',new z('numberedlist','ol')),P=N.addCommand('bulletedlist',new z('bulletedlist','ul'));N.ui.addButton('NumberedList',{label:N.lang.numberedlist,command:'numberedlist'});N.ui.addButton('BulletedList',{label:N.lang.bulletedlist,command:'bulletedlist'});N.on('selectionChange',e.bind(u,O));N.on('selectionChange',e.bind(u,P));N.on('key',function(Q){var R=Q.data.keyCode;if(N.mode=='wysiwyg'&&R in {8:1,46:1}){var S=N.getSelection(),T=S.getRanges()[0];if(!T.collapsed)return;var U=new d.elementPath(T.startContainer),V=R==8,W=N.document.getBody(),X=new d.walker(T.clone());X.evaluator=function(ai){return q(ai)&&!r(ai);};X.guard=function(ai,aj){return!(aj&&ai.type==1&&ai.is('table'));};var Y=T.clone();if(V){var Z,aa;if((Z=U.contains(m))&&T.checkBoundaryOfElement(Z,1)&&(Z=Z.getParent())&&Z.is('li')&&(Z=M(Z))){aa=Z;Z=Z.getPrevious(q);Y.moveToPosition(Z&&r(Z)?Z:aa,3);}else{X.range.setStartAt(W,1);
X.range.setEnd(T.startContainer,T.startOffset);Z=X.previous();if(Z&&Z.type==1&&(Z.getName() in m||Z.is('li'))){if(!Z.is('li')){X.range.selectNodeContents(Z);X.reset();X.evaluator=K;Z=X.previous();}aa=Z;Y.moveToElementEditEnd(aa);}}if(aa){L(N,Y,T);Q.cancel();}else{var ab=U.contains(m),ac;if(ab&&T.checkBoundaryOfElement(ab,1)){ac=ab.getFirst(q);if(T.checkBoundaryOfElement(ac,1)){Z=ab.getPrevious(q);if(M(ac)){if(Z){T.moveToElementEditEnd(Z);T.select();}Q.cancel();}else{N.execCommand('outdent');Q.cancel();}}}}}else{var ad,ae;ac=T.startContainer.getAscendant('li',1);if(ac){X.range.setEndAt(W,2);var af=ac.getLast(q),ag=af&&K(af)?af:ac,ah=0;ad=X.next();if(ad&&ad.type==1&&ad.getName() in m&&ad.equals(af)){ah=1;ad=X.next();}else if(T.checkBoundaryOfElement(ag,2))ah=1;if(ah&&ad){ae=T.clone();ae.moveToElementEditStart(ad);L(N,Y,ae);Q.cancel();}}else{X.range.setEndAt(W,2);ad=X.next();if(ad&&ad.type==1&&ad.getName() in m){ad=ad.getFirst(q);if(U.block&&T.checkStartOfBlock()&&T.checkEndOfBlock()){U.block.remove();T.moveToElementEditStart(ad);T.select();Q.cancel();}else if(M(ad)){T.moveToElementEditStart(ad);T.select();Q.cancel();}else{ae=T.clone();ae.moveToElementEditStart(ad);L(N,Y,ae);Q.cancel();}}}}setTimeout(function(){N.selectionChange(1);});}});},afterInit:function(N){var O=N.dataProcessor;if(O){O.dataFilter.addRules(H);O.htmlFilter.addRules(J);}},requires:['domiterator']});})();(function(){j.liststyle={requires:['dialog'],init:function(m){m.addCommand('numberedListStyle',new a.dialogCommand('numberedListStyle'));a.dialog.add('numberedListStyle',this.path+'dialogs/liststyle.js');m.addCommand('bulletedListStyle',new a.dialogCommand('bulletedListStyle'));a.dialog.add('bulletedListStyle',this.path+'dialogs/liststyle.js');if(m.addMenuItems){m.addMenuGroup('list',108);m.addMenuItems({numberedlist:{label:m.lang.list.numberedTitle,group:'list',command:'numberedListStyle'},bulletedlist:{label:m.lang.list.bulletedTitle,group:'list',command:'bulletedListStyle'}});}if(m.contextMenu)m.contextMenu.addListener(function(n,o){if(!n||n.isReadOnly())return null;while(n){var p=n.getName();if(p=='ol')return{numberedlist:2};else if(p=='ul')return{bulletedlist:2};n=n.getParent();}return null;});}};j.add('liststyle',j.liststyle);})();(function(){function m(s){if(!s||s.type!=1||s.getName()!='form')return[];var t=[],u=['style','className'];for(var v=0;v<u.length;v++){var w=u[v],x=s.$.elements.namedItem(w);if(x){var y=new h(x);t.push([y,y.nextSibling]);y.remove();}}return t;};function n(s,t){if(!s||s.type!=1||s.getName()!='form')return;
if(t.length>0)for(var u=t.length-1;u>=0;u--){var v=t[u][0],w=t[u][1];if(w)v.insertBefore(w);else v.appendTo(s);}};function o(s,t){var u=m(s),v={},w=s.$;if(!t){v['class']=w.className||'';w.className='';}v.inline=w.style.cssText||'';if(!t)w.style.cssText='position: static; overflow: visible';n(u);return v;};function p(s,t){var u=m(s),v=s.$;if('class' in t)v.className=t['class'];if('inline' in t)v.style.cssText=t.inline;n(u);};function q(s){var t=a.instances;for(var u in t){var v=t[u];if(v.mode=='wysiwyg'&&!v.readOnly){var w=v.document.getBody();w.setAttribute('contentEditable',false);w.setAttribute('contentEditable',true);}}if(s.focusManager.hasFocus){s.toolbox.focus();s.focus();}};function r(s){if(!c||b.version>6)return null;var t=h.createFromHtml('<iframe frameborder="0" tabindex="-1" src="javascript:void((function(){document.open();'+(b.isCustomDomain()?"document.domain='"+this.getDocument().$.domain+"';":'')+'document.close();'+'})())"'+' style="display:block;position:absolute;z-index:-1;'+'progid:DXImageTransform.Microsoft.Alpha(opacity=0);'+'"></iframe>');return s.append(t,true);};j.add('maximize',{init:function(s){var t=s.lang,u=a.document,v=u.getWindow(),w,x,y,z;function A(){var C=v.getViewPaneSize();z&&z.setStyles({width:C.width+'px',height:C.height+'px'});s.resize(C.width,C.height,null,true);};var B=2;s.addCommand('maximize',{modes:{wysiwyg:!b.iOS,source:!b.iOS},readOnly:1,editorFocus:false,exec:function(){var C=s.container.getChild(1),D=s.getThemeSpace('contents');if(s.mode=='wysiwyg'){var E=s.getSelection();w=E&&E.getRanges();x=v.getScrollPosition();}else{var F=s.textarea.$;w=!c&&[F.selectionStart,F.selectionEnd];x=[F.scrollLeft,F.scrollTop];}if(this.state==2){v.on('resize',A);y=v.getScrollPosition();var G=s.container;while(G=G.getParent()){G.setCustomData('maximize_saved_styles',o(G));G.setStyle('z-index',s.config.baseFloatZIndex-1);}D.setCustomData('maximize_saved_styles',o(D,true));C.setCustomData('maximize_saved_styles',o(C,true));var H={overflow:b.webkit?'':'hidden',width:0,height:0};u.getDocumentElement().setStyles(H);!b.gecko&&u.getDocumentElement().setStyle('position','fixed');!(b.gecko&&b.quirks)&&u.getBody().setStyles(H);c?setTimeout(function(){v.$.scrollTo(0,0);},0):v.$.scrollTo(0,0);C.setStyle('position',b.gecko&&b.quirks?'fixed':'absolute');C.$.offsetLeft;C.setStyles({'z-index':s.config.baseFloatZIndex-1,left:'0px',top:'0px'});z=r(C);C.addClass('cke_maximized');A();var I=C.getDocumentPosition();C.setStyles({left:-1*I.x+'px',top:-1*I.y+'px'});
b.gecko&&q(s);}else if(this.state==1){v.removeListener('resize',A);var J=[D,C];for(var K=0;K<J.length;K++){p(J[K],J[K].getCustomData('maximize_saved_styles'));J[K].removeCustomData('maximize_saved_styles');}G=s.container;while(G=G.getParent()){p(G,G.getCustomData('maximize_saved_styles'));G.removeCustomData('maximize_saved_styles');}c?setTimeout(function(){v.$.scrollTo(y.x,y.y);},0):v.$.scrollTo(y.x,y.y);C.removeClass('cke_maximized');if(b.webkit){C.setStyle('display','inline');setTimeout(function(){C.setStyle('display','block');},0);}if(z){z.remove();z=null;}s.fire('resize');}this.toggleState();var L=this.uiItems[0];if(L){var M=this.state==2?t.maximize:t.minimize,N=s.element.getDocument().getById(L._.id);N.getChild(1).setHtml(M);N.setAttribute('title',M);N.setAttribute('href','javascript:void("'+M+'");');}if(s.mode=='wysiwyg'){if(w){b.gecko&&q(s);s.getSelection().selectRanges(w);var O=s.getSelection().getStartElement();O&&O.scrollIntoView(true);}else v.$.scrollTo(x.x,x.y);}else{if(w){F.selectionStart=w[0];F.selectionEnd=w[1];}F.scrollLeft=x[0];F.scrollTop=x[1];}w=x=null;B=this.state;},canUndo:false});s.ui.addButton('Maximize',{label:t.maximize,command:'maximize'});s.on('mode',function(){var C=s.getCommand('maximize');C.setState(C.state==0?0:B);},null,null,100);}});})();j.add('newpage',{init:function(m){m.addCommand('newpage',{modes:{wysiwyg:1,source:1},exec:function(n){var o=this;n.setData(n.config.newpage_html||'',function(){setTimeout(function(){n.fire('afterCommandExec',{name:'newpage',command:o});n.selectionChange();},200);});n.focus();},async:true});m.ui.addButton('NewPage',{label:m.lang.newPage,command:'newpage'});}});j.add('pagebreak',{init:function(m){m.addCommand('pagebreak',j.pagebreakCmd);m.ui.addButton('PageBreak',{label:m.lang.pagebreak,command:'pagebreak'});var n=['{','background: url('+a.getUrl(this.path+'images/pagebreak.gif')+') no-repeat center center;','clear: both;','width:100%; _width:99.9%;','border-top: #999999 1px dotted;','border-bottom: #999999 1px dotted;','padding:0;','height: 5px;','cursor: default;','}'].join('').replace(/;/g,' !important;');m.addCss('div.cke_pagebreak'+n);b.opera&&m.on('contentDom',function(){m.document.on('click',function(o){var p=o.data.getTarget();if(p.is('div')&&p.hasClass('cke_pagebreak'))m.getSelection().selectElement(p);});});},afterInit:function(m){var n=m.lang.pagebreakAlt,o=m.dataProcessor,p=o&&o.dataFilter,q=o&&o.htmlFilter;if(q)q.addRules({attributes:{'class':function(r,s){var t=r.replace('cke_pagebreak','');
if(t!=r){var u=a.htmlParser.fragment.fromHtml('<span style="display: none;">&nbsp;</span>');s.children.length=0;s.add(u);var v=s.attributes;delete v['aria-label'];delete v.contenteditable;delete v.title;}return t;}}},5);if(p)p.addRules({elements:{div:function(r){var s=r.attributes,t=s&&s.style,u=t&&r.children.length==1&&r.children[0],v=u&&u.name=='span'&&u.attributes.style;if(v&&/page-break-after\s*:\s*always/i.test(t)&&/display\s*:\s*none/i.test(v)){s.contenteditable='false';s['class']='cke_pagebreak';s['data-cke-display-name']='pagebreak';s['aria-label']=n;s.title=n;r.children.length=0;}}}});},requires:['fakeobjects']});j.pagebreakCmd={exec:function(m){var n=m.lang.pagebreakAlt,o=h.createFromHtml('<div style="page-break-after: always;"contenteditable="false" title="'+n+'" '+'aria-label="'+n+'" '+'data-cke-display-name="pagebreak" '+'class="cke_pagebreak">'+'</div>',m.document),p=m.getSelection().getRanges(true);m.fire('saveSnapshot');for(var q,r=p.length-1;r>=0;r--){q=p[r];if(r<p.length-1)o=o.clone(true);q.splitBlock('p');q.insertNode(o);if(r==p.length-1){var s=o.getNext();q.moveToPosition(o,4);if(!s||s.type==1&&!s.isEditable())q.fixBlock(true,m.config.enterMode==3?'div':'p');q.select();}}m.fire('saveSnapshot');}};(function(){function m(n){n.data.mode='html';};j.add('pastefromword',{init:function(n){var o=0,p=function(q){q&&q.removeListener();n.removeListener('beforePaste',m);o&&setTimeout(function(){o=0;},0);};n.addCommand('pastefromword',{canUndo:false,exec:function(){o=1;n.on('beforePaste',m);if(n.execCommand('paste','html')===false){n.on('dialogShow',function(q){q.removeListener();q.data.on('cancel',p);});n.on('dialogHide',function(q){q.data.removeListener('cancel',p);});}n.on('afterPaste',p);}});n.ui.addButton('PasteFromWord',{label:n.lang.pastefromword.toolbar,command:'pastefromword'});n.on('pasteState',function(q){n.getCommand('pastefromword').setState(q.data);});n.on('paste',function(q){var r=q.data,s;if((s=r.html)&&(o||/(class=\"?Mso|style=\"[^\"]*\bmso\-|w:WordDocument)/.test(s))){var t=this.loadFilterRules(function(){if(t)n.fire('paste',r);else if(!n.config.pasteFromWordPromptCleanup||o||confirm(n.lang.pastefromword.confirmCleanup))r.html=a.cleanWord(s,n);});t&&q.cancel();}},this);},loadFilterRules:function(n){var o=a.cleanWord;if(o)n();else{var p=a.getUrl(i.pasteFromWordCleanupFile||this.path+'filter/default.js');a.scriptLoader.load(p,n,null,true);}return!o;},requires:['clipboard']});})();(function(){var m={exec:function(n){var o=e.tryThese(function(){var p=window.clipboardData.getData('Text');
if(!p)throw 0;return p;});if(!o){n.openDialog('pastetext');return false;}else n.fire('paste',{text:o});return true;}};j.add('pastetext',{init:function(n){var o='pastetext',p=n.addCommand(o,m);n.ui.addButton('PasteText',{label:n.lang.pasteText.button,command:o});a.dialog.add(o,a.getUrl(this.path+'dialogs/pastetext.js'));if(n.config.forcePasteAsPlainText){n.on('beforeCommandExec',function(q){var r=q.data.commandData;if(q.data.name=='paste'&&r!='html'){n.execCommand('pastetext');q.cancel();}},null,null,0);n.on('beforePaste',function(q){q.data.mode='text';});}n.on('pasteState',function(q){n.getCommand('pastetext').setState(q.data);});},requires:['clipboard']});})();j.add('popup');e.extend(a.editor.prototype,{popup:function(m,n,o,p){n=n||'80%';o=o||'70%';if(typeof n=='string'&&n.length>1&&n.substr(n.length-1,1)=='%')n=parseInt(window.screen.width*parseInt(n,10)/100,10);if(typeof o=='string'&&o.length>1&&o.substr(o.length-1,1)=='%')o=parseInt(window.screen.height*parseInt(o,10)/100,10);if(n<640)n=640;if(o<420)o=420;var q=parseInt((window.screen.height-o)/2,10),r=parseInt((window.screen.width-n)/2,10);p=(p||'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes')+',width='+n+',height='+o+',top='+q+',left='+r;var s=window.open('',null,p,true);if(!s)return false;try{var t=navigator.userAgent.toLowerCase();if(t.indexOf(' chrome/')==-1){s.moveTo(r,q);s.resizeTo(n,o);}s.focus();s.location.href=m;}catch(u){s=window.open(m,null,p,true);}return true;}});(function(){var m,n={modes:{wysiwyg:1,source:1},canUndo:false,readOnly:1,exec:function(p){var q,r=p.config,s=r.baseHref?'<base href="'+r.baseHref+'"/>':'',t=b.isCustomDomain();if(r.fullPage)q=p.getData().replace(/<head>/,'$&'+s).replace(/[^>]*(?=<\/title>)/,'$& &mdash; '+p.lang.preview);else{var u='<body ',v=p.document&&p.document.getBody();if(v){if(v.getAttribute('id'))u+='id="'+v.getAttribute('id')+'" ';if(v.getAttribute('class'))u+='class="'+v.getAttribute('class')+'" ';}u+='>';q=p.config.docType+'<html dir="'+p.config.contentsLangDirection+'">'+'<head>'+s+'<title>'+p.lang.preview+'</title>'+e.buildStyleHtml(p.config.contentsCss)+'</head>'+u+p.getData()+'</body></html>';}var w=640,x=420,y=80;try{var z=window.screen;w=Math.round(z.width*0.8);x=Math.round(z.height*0.7);y=Math.round(z.width*0.1);}catch(D){}var A='';if(t){window._cke_htmlToLoad=q;A='javascript:void( (function(){document.open();document.domain="'+document.domain+'";'+'document.write( window.opener._cke_htmlToLoad );'+'document.close();'+'window.opener._cke_htmlToLoad = null;'+'})() )';
}if(b.gecko){window._cke_htmlToLoad=q;A=m+'preview.html';}var B=window.open(A,null,'toolbar=yes,location=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width='+w+',height='+x+',left='+y);if(!t&&!b.gecko){var C=B.document;C.open();C.write(q);C.close();b.webkit&&setTimeout(function(){C.body.innerHTML+='';},0);}}},o='preview';j.add(o,{init:function(p){m=this.path;p.addCommand(o,n);p.ui.addButton('Preview',{label:p.lang.preview,command:o});}});})();j.add('print',{init:function(m){var n='print',o=m.addCommand(n,j.print);m.ui.addButton('Print',{label:m.lang.print,command:n});}});j.print={exec:function(m){if(b.opera)return;else if(b.gecko)m.window.$.print();else m.document.$.execCommand('Print');},canUndo:false,readOnly:1,modes:{wysiwyg:!b.opera}};j.add('removeformat',{requires:['selection'],init:function(m){m.addCommand('removeFormat',j.removeformat.commands.removeformat);m.ui.addButton('RemoveFormat',{label:m.lang.removeFormat,command:'removeFormat'});m._.removeFormat={filters:[]};}});j.removeformat={commands:{removeformat:{exec:function(m){var n=m._.removeFormatRegex||(m._.removeFormatRegex=new RegExp('^(?:'+m.config.removeFormatTags.replace(/,/g,'|')+')$','i')),o=m._.removeAttributes||(m._.removeAttributes=m.config.removeFormatAttributes.split(',')),p=j.removeformat.filter,q=m.getSelection().getRanges(1),r=q.createIterator(),s;while(s=r.getNextRange()){if(!s.collapsed)s.enlarge(1);var t=s.createBookmark(),u=t.startNode,v=t.endNode,w,x=function(z){var A=new d.elementPath(z),B=A.elements;for(var C=1,D;D=B[C];C++){if(D.equals(A.block)||D.equals(A.blockLimit))break;if(n.test(D.getName())&&p(m,D))z.breakParent(D);}};x(u);if(v){x(v);w=u.getNextSourceNode(true,1);while(w){if(w.equals(v))break;var y=w.getNextSourceNode(false,1);if(!(w.getName()=='img'&&w.data('cke-realelement'))&&p(m,w))if(n.test(w.getName()))w.remove(1);else{w.removeAttributes(o);m.fire('removeFormatCleanup',w);}w=y;}}s.moveToBookmark(t);}m.getSelection().selectRanges(q);}}},filter:function(m,n){var o=m._.removeFormat.filters;for(var p=0;p<o.length;p++){if(o[p](n)===false)return false;}return true;}};a.editor.prototype.addRemoveFormatFilter=function(m){this._.removeFormat.filters.push(m);};i.removeFormatTags='b,big,code,del,dfn,em,font,i,ins,kbd,q,samp,small,span,strike,strong,sub,sup,tt,u,var';i.removeFormatAttributes='class,style,lang,width,height,align,hspace,valign';j.add('resize',{init:function(m){var n=m.config,o=m.element.getDirection(1);!n.resize_dir&&(n.resize_dir='both');n.resize_maxWidth==undefined&&(n.resize_maxWidth=3000);
n.resize_maxHeight==undefined&&(n.resize_maxHeight=3000);n.resize_minWidth==undefined&&(n.resize_minWidth=750);n.resize_minHeight==undefined&&(n.resize_minHeight=250);if(n.resize_enabled!==false){var p=null,q,r,s=(n.resize_dir=='both'||n.resize_dir=='horizontal')&&n.resize_minWidth!=n.resize_maxWidth,t=(n.resize_dir=='both'||n.resize_dir=='vertical')&&n.resize_minHeight!=n.resize_maxHeight;function u(x){var y=x.data.$.screenX-q.x,z=x.data.$.screenY-q.y,A=r.width,B=r.height,C=A+y*(o=='rtl'?-1:1),D=B+z;if(s)A=Math.max(n.resize_minWidth,Math.min(C,n.resize_maxWidth));if(t)B=Math.max(n.resize_minHeight,Math.min(D,n.resize_maxHeight));m.resize(s?A:null,B);};function v(x){a.document.removeListener('mousemove',u);a.document.removeListener('mouseup',v);if(m.document){m.document.removeListener('mousemove',u);m.document.removeListener('mouseup',v);}};var w=e.addFunction(function(x){if(!p)p=m.getResizable();r={width:p.$.offsetWidth||0,height:p.$.offsetHeight||0};q={x:x.screenX,y:x.screenY};n.resize_minWidth>r.width&&(n.resize_minWidth=r.width);n.resize_minHeight>r.height&&(n.resize_minHeight=r.height);a.document.on('mousemove',u);a.document.on('mouseup',v);if(m.document){m.document.on('mousemove',u);m.document.on('mouseup',v);}});m.on('destroy',function(){e.removeFunction(w);});m.on('themeSpace',function(x){if(x.data.space=='bottom'){var y='';if(s&&!t)y=' cke_resizer_horizontal';if(!s&&t)y=' cke_resizer_vertical';var z='<div class="cke_resizer'+y+' cke_resizer_'+o+'"'+' title="'+e.htmlEncode(m.lang.resize)+'"'+' onmousedown="CKEDITOR.tools.callFunction('+w+', event)"'+'></div>';o=='ltr'&&y=='ltr'?x.data.html+=z:x.data.html=z+x.data.html;}},m,null,100);}}});(function(){var m={modes:{wysiwyg:1,source:1},readOnly:1,exec:function(o){var p=o.element.$.form;if(p)try{p.submit();}catch(q){if(p.submit.click)p.submit.click();}}},n='save';j.add(n,{init:function(o){var p=o.addCommand(n,m);p.modes={wysiwyg:!!o.element.$.form};o.ui.addButton('Save',{label:o.lang.save,command:n});}});})();(function(){var m='scaytcheck',n='';function o(t,u){var v=0,w;for(w in u){if(u[w]==t){v=1;break;}}return v;};var p=function(){var t=this,u=function(){var y=t.config,z={};z.srcNodeRef=t.document.getWindow().$.frameElement;z.assocApp='CKEDITOR.'+a.version+'@'+a.revision;z.customerid=y.scayt_customerid||'1:WvF0D4-UtPqN1-43nkD4-NKvUm2-daQqk3-LmNiI-z7Ysb4-mwry24-T8YrS3-Q2tpq2';z.customDictionaryIds=y.scayt_customDictionaryIds||'';z.userDictionaryName=y.scayt_userDictionaryName||'';z.sLang=y.scayt_sLang||'en_US';
z.onLoad=function(){if(!(c&&b.version<8))this.addStyle(this.selectorCss(),'padding-bottom: 2px !important;');if(t.focusManager.hasFocus&&!q.isControlRestored(t))this.focus();};z.onBeforeChange=function(){if(q.getScayt(t)&&!t.checkDirty())setTimeout(function(){t.resetDirty();},0);};var A=window.scayt_custom_params;if(typeof A=='object')for(var B in A)z[B]=A[B];if(q.getControlId(t))z.id=q.getControlId(t);var C=new window.scayt(z);C.afterMarkupRemove.push(function(E){new h(E,C.document).mergeSiblings();});var D=q.instances[t.name];if(D){C.sLang=D.sLang;C.option(D.option());C.paused=D.paused;}q.instances[t.name]=C;try{C.setDisabled(q.isPaused(t)===false);}catch(E){}t.fire('showScaytState');};t.on('contentDom',u);t.on('contentDomUnload',function(){var y=a.document.getElementsByTag('script'),z=/^dojoIoScript(\d+)$/i,A=/^https?:\/\/svc\.webspellchecker\.net\/spellcheck\/script\/ssrv\.cgi/i;for(var B=0;B<y.count();B++){var C=y.getItem(B),D=C.getId(),E=C.getAttribute('src');if(D&&E&&D.match(z)&&E.match(A))C.remove();}});t.on('beforeCommandExec',function(y){if((y.data.name=='source'||y.data.name=='newpage')&&t.mode=='wysiwyg'){var z=q.getScayt(t);if(z){q.setPaused(t,!z.disabled);q.setControlId(t,z.id);z.destroy(true);delete q.instances[t.name];}}else if(y.data.name=='source'&&t.mode=='source')q.markControlRestore(t);});t.on('afterCommandExec',function(y){if(!q.isScaytEnabled(t))return;if(t.mode=='wysiwyg'&&(y.data.name=='undo'||y.data.name=='redo'))window.setTimeout(function(){q.getScayt(t).refresh();},10);});t.on('destroy',function(y){var z=y.editor,A=q.getScayt(z);if(!A)return;delete q.instances[z.name];q.setControlId(z,A.id);A.destroy(true);});t.on('afterSetData',function(){if(q.isScaytEnabled(t))window.setTimeout(function(){var y=q.getScayt(t);y&&y.refresh();},10);});t.on('insertElement',function(){var y=q.getScayt(t);if(q.isScaytEnabled(t)){if(c)t.getSelection().unlock(true);window.setTimeout(function(){y.focus();y.refresh();},10);}},this,null,50);t.on('insertHtml',function(){var y=q.getScayt(t);if(q.isScaytEnabled(t)){if(c)t.getSelection().unlock(true);window.setTimeout(function(){y.focus();y.refresh();},10);}},this,null,50);t.on('scaytDialog',function(y){y.data.djConfig=window.djConfig;y.data.scayt_control=q.getScayt(t);y.data.tab=n;y.data.scayt=window.scayt;});var v=t.dataProcessor,w=v&&v.htmlFilter;if(w)w.addRules({elements:{span:function(y){if(y.attributes['data-scayt_word']&&y.attributes['data-scaytid']){delete y.name;return y;}}}});var x=j.undo.Image.prototype;
x.equals=e.override(x.equals,function(y){return function(z){var E=this;var A=E.contents,B=z.contents,C=q.getScayt(E.editor);if(C&&q.isScaytReady(E.editor)){E.contents=C.reset(A)||'';z.contents=C.reset(B)||'';}var D=y.apply(E,arguments);E.contents=A;z.contents=B;return D;};});if(t.document)u();};j.scayt={engineLoaded:false,instances:{},controlInfo:{},setControlInfo:function(t,u){if(t&&t.name&&typeof this.controlInfo[t.name]!='object')this.controlInfo[t.name]={};for(var v in u)this.controlInfo[t.name][v]=u[v];},isControlRestored:function(t){if(t&&t.name&&this.controlInfo[t.name])return this.controlInfo[t.name].restored;return false;},markControlRestore:function(t){this.setControlInfo(t,{restored:true});},setControlId:function(t,u){this.setControlInfo(t,{id:u});},getControlId:function(t){if(t&&t.name&&this.controlInfo[t.name]&&this.controlInfo[t.name].id)return this.controlInfo[t.name].id;return null;},setPaused:function(t,u){this.setControlInfo(t,{paused:u});},isPaused:function(t){if(t&&t.name&&this.controlInfo[t.name])return this.controlInfo[t.name].paused;return undefined;},getScayt:function(t){return this.instances[t.name];},isScaytReady:function(t){return this.engineLoaded===true&&'undefined'!==typeof window.scayt&&this.getScayt(t);},isScaytEnabled:function(t){var u=this.getScayt(t);return u?u.disabled===false:false;},getUiTabs:function(t){var u=[],v=t.config.scayt_uiTabs||'1,1,1';v=v.split(',');v[3]='1';for(var w=0;w<4;w++)u[w]=typeof window.scayt!='undefined'&&typeof window.scayt.uiTags!='undefined'?parseInt(v[w],10)&&window.scayt.uiTags[w]:parseInt(v[w],10);return u;},loadEngine:function(t){if(b.gecko&&b.version<10900||b.opera||b.air)return t.fire('showScaytState');if(this.engineLoaded===true)return p.apply(t);else if(this.engineLoaded==-1)return a.on('scaytReady',function(){p.apply(t);});a.on('scaytReady',p,t);a.on('scaytReady',function(){this.engineLoaded=true;},this,null,0);this.engineLoaded=-1;var u=document.location.protocol;u=u.search(/https?:/)!=-1?u:'http:';var v='svc.webspellchecker.net/scayt26/loader__base.js',w=t.config.scayt_srcUrl||u+'//'+v,x=q.parseUrl(w).path+'/';if(window.scayt==undefined){a._djScaytConfig={baseUrl:x,addOnLoad:[function(){a.fireOnce('scaytReady');}],isDebug:false};a.document.getHead().append(a.document.createElement('script',{attributes:{type:'text/javascript',async:'true',src:w}}));}else a.fireOnce('scaytReady');return null;},parseUrl:function(t){var u;if(t.match&&(u=t.match(/(.*)[\/\\](.*?\.\w+)$/)))return{path:u[1],file:u[2]};
else return t;}};var q=j.scayt,r=function(t,u,v,w,x,y,z){t.addCommand(w,x);t.addMenuItem(w,{label:v,command:w,group:y,order:z});},s={preserveState:true,editorFocus:false,canUndo:false,exec:function(t){if(q.isScaytReady(t)){var u=q.isScaytEnabled(t);this.setState(u?2:1);var v=q.getScayt(t);v.focus();v.setDisabled(u);}else if(!t.config.scayt_autoStartup&&q.engineLoaded>=0){this.setState(0);q.loadEngine(t);}}};j.add('scayt',{requires:['menubutton'],beforeInit:function(t){var u=t.config.scayt_contextMenuItemsOrder||'suggest|moresuggest|control',v='';u=u.split('|');if(u&&u.length)for(var w=0;w<u.length;w++)v+='scayt_'+u[w]+(u.length!=parseInt(w,10)+1?',':'');t.config.menu_groups=v+','+t.config.menu_groups;},init:function(t){var u=t.dataProcessor&&t.dataProcessor.dataFilter,v={elements:{span:function(E){var F=E.attributes;if(F&&F['data-scaytid'])delete E.name;}}};u&&u.addRules(v);var w={},x={},y=t.addCommand(m,s);a.dialog.add(m,a.getUrl(this.path+'dialogs/options.js'));var z=q.getUiTabs(t),A='scaytButton';t.addMenuGroup(A);var B={},C=t.lang.scayt;B.scaytToggle={label:C.enable,command:m,group:A};if(z[0]==1)B.scaytOptions={label:C.options,group:A,onClick:function(){n='options';t.openDialog(m);}};if(z[1]==1)B.scaytLangs={label:C.langs,group:A,onClick:function(){n='langs';t.openDialog(m);}};if(z[2]==1)B.scaytDict={label:C.dictionariesTab,group:A,onClick:function(){n='dictionaries';t.openDialog(m);}};B.scaytAbout={label:t.lang.scayt.about,group:A,onClick:function(){n='about';t.openDialog(m);}};t.addMenuItems(B);t.ui.add('Scayt','menubutton',{label:C.title,title:b.opera?C.opera_title:C.title,className:'cke_button_scayt',modes:{wysiwyg:1},onRender:function(){y.on('state',function(){this.setState(y.state);},this);},onMenu:function(){var E=q.isScaytEnabled(t);t.getMenuItem('scaytToggle').label=C[E?'disable':'enable'];var F=q.getUiTabs(t);return{scaytToggle:2,scaytOptions:E&&F[0]?2:0,scaytLangs:E&&F[1]?2:0,scaytDict:E&&F[2]?2:0,scaytAbout:E&&F[3]?2:0};}});if(t.contextMenu&&t.addMenuItems)t.contextMenu.addListener(function(E,F){if(!q.isScaytEnabled(t)||F.getRanges()[0].checkReadOnly())return null;var G=q.getScayt(t),H=G.getScaytNode();if(!H)return null;var I=G.getWord(H);if(!I)return null;var J=G.getLang(),K={},L=window.scayt.getSuggestion(I,J);if(!L||!L.length)return null;for(var M in w){delete t._.menuItems[M];delete t._.commands[M];}for(M in x){delete t._.menuItems[M];delete t._.commands[M];}w={};x={};var N=t.config.scayt_moreSuggestions||'on',O=false,P=t.config.scayt_maxSuggestions;
typeof P!='number'&&(P=5);!P&&(P=L.length);var Q=t.config.scayt_contextCommands||'all';Q=Q.split('|');for(var R=0,S=L.length;R<S;R+=1){var T='scayt_suggestion_'+L[R].replace(' ','_'),U=(function(Y,Z){return{exec:function(){G.replace(Y,Z);}};})(H,L[R]);if(R<P){r(t,'button_'+T,L[R],T,U,'scayt_suggest',R+1);K[T]=2;x[T]=2;}else if(N=='on'){r(t,'button_'+T,L[R],T,U,'scayt_moresuggest',R+1);w[T]=2;O=true;}}if(O){t.addMenuItem('scayt_moresuggest',{label:C.moreSuggestions,group:'scayt_moresuggest',order:10,getItems:function(){return w;}});x.scayt_moresuggest=2;}if(o('all',Q)||o('ignore',Q)){var V={exec:function(){G.ignore(H);}};r(t,'ignore',C.ignore,'scayt_ignore',V,'scayt_control',1);x.scayt_ignore=2;}if(o('all',Q)||o('ignoreall',Q)){var W={exec:function(){G.ignoreAll(H);}};r(t,'ignore_all',C.ignoreAll,'scayt_ignore_all',W,'scayt_control',2);x.scayt_ignore_all=2;}if(o('all',Q)||o('add',Q)){var X={exec:function(){window.scayt.addWordToUserDictionary(H);}};r(t,'add_word',C.addWord,'scayt_add_word',X,'scayt_control',3);x.scayt_add_word=2;}if(G.fireOnContextMenu)G.fireOnContextMenu(t);return x;});var D=function(){t.removeListener('showScaytState',D);if(!b.opera&&!b.air)y.setState(q.isScaytEnabled(t)?1:2);else y.setState(0);};t.on('showScaytState',D);if(b.opera||b.air)t.on('instanceReady',function(){D();});if(t.config.scayt_autoStartup)t.on('instanceReady',function(){q.loadEngine(t);});},afterInit:function(t){var u,v=function(w){if(w.hasAttribute('data-scaytid'))return false;};if(t._.elementsPath&&(u=t._.elementsPath.filters))u.push(v);t.addRemoveFormatFilter&&t.addRemoveFormatFilter(v);}});})();j.add('smiley',{requires:['dialog'],init:function(m){m.config.smiley_path=m.config.smiley_path||this.path+'images/';m.addCommand('smiley',new a.dialogCommand('smiley'));m.ui.addButton('Smiley',{label:m.lang.smiley.toolbar,command:'smiley'});a.dialog.add('smiley',this.path+'dialogs/smiley.js');}});i.smiley_images=['regular_smile.gif','sad_smile.gif','wink_smile.gif','teeth_smile.gif','confused_smile.gif','tounge_smile.gif','embaressed_smile.gif','omg_smile.gif','whatchutalkingabout_smile.gif','angry_smile.gif','angel_smile.gif','shades_smile.gif','devil_smile.gif','cry_smile.gif','lightbulb.gif','thumbs_down.gif','thumbs_up.gif','heart.gif','broken_heart.gif','kiss.gif','envelope.gif'];i.smiley_descriptions=['smiley','sad','wink','laugh','frown','cheeky','blush','surprise','indecision','angry','angel','cool','devil','crying','enlightened','no','yes','heart','broken heart','kiss','mail'];
(function(){var m='.%2 p,.%2 div,.%2 pre,.%2 address,.%2 blockquote,.%2 h1,.%2 h2,.%2 h3,.%2 h4,.%2 h5,.%2 h6{background-repeat: no-repeat;background-position: top %3;border: 1px dotted gray;padding-top: 8px;padding-%3: 8px;}.%2 p{%1p.png);}.%2 div{%1div.png);}.%2 pre{%1pre.png);}.%2 address{%1address.png);}.%2 blockquote{%1blockquote.png);}.%2 h1{%1h1.png);}.%2 h2{%1h2.png);}.%2 h3{%1h3.png);}.%2 h4{%1h4.png);}.%2 h5{%1h5.png);}.%2 h6{%1h6.png);}',n=/%1/g,o=/%2/g,p=/%3/g,q={readOnly:1,preserveState:true,editorFocus:false,exec:function(r){this.toggleState();this.refresh(r);},refresh:function(r){if(r.document){var s=this.state==1?'addClass':'removeClass';r.document.getBody()[s]('cke_show_blocks');}}};j.add('showblocks',{requires:['wysiwygarea'],init:function(r){var s=r.addCommand('showblocks',q);s.canUndo=false;if(r.config.startupOutlineBlocks)s.setState(1);r.addCss(m.replace(n,'background-image: url('+a.getUrl(this.path)+'images/block_').replace(o,'cke_show_blocks ').replace(p,r.lang.dir=='rtl'?'right':'left'));r.ui.addButton('ShowBlocks',{label:r.lang.showBlocks,command:'showblocks'});r.on('mode',function(){if(s.state!=0)s.refresh(r);});r.on('contentDom',function(){if(s.state!=0)s.refresh(r);});}});})();(function(){var m='cke_show_border',n,o=(b.ie6Compat?['.%1 table.%2,','.%1 table.%2 td, .%1 table.%2 th','{','border : #d3d3d3 1px dotted','}']:['.%1 table.%2,','.%1 table.%2 > tr > td, .%1 table.%2 > tr > th,','.%1 table.%2 > tbody > tr > td, .%1 table.%2 > tbody > tr > th,','.%1 table.%2 > thead > tr > td, .%1 table.%2 > thead > tr > th,','.%1 table.%2 > tfoot > tr > td, .%1 table.%2 > tfoot > tr > th','{','border : #d3d3d3 1px dotted','}']).join('');n=o.replace(/%2/g,m).replace(/%1/g,'cke_show_borders ');var p={preserveState:true,editorFocus:false,readOnly:1,exec:function(q){this.toggleState();this.refresh(q);},refresh:function(q){if(q.document){var r=this.state==1?'addClass':'removeClass';q.document.getBody()[r]('cke_show_borders');}}};j.add('showborders',{requires:['wysiwygarea'],modes:{wysiwyg:1},init:function(q){var r=q.addCommand('showborders',p);r.canUndo=false;if(q.config.startupShowBorders!==false)r.setState(1);q.addCss(n);q.on('mode',function(){if(r.state!=0)r.refresh(q);},null,null,100);q.on('contentDom',function(){if(r.state!=0)r.refresh(q);});q.on('removeFormatCleanup',function(s){var t=s.data;if(q.getCommand('showborders').state==1&&t.is('table')&&(!t.hasAttribute('border')||parseInt(t.getAttribute('border'),10)<=0))t.addClass(m);});},afterInit:function(q){var r=q.dataProcessor,s=r&&r.dataFilter,t=r&&r.htmlFilter;
if(s)s.addRules({elements:{table:function(u){var v=u.attributes,w=v['class'],x=parseInt(v.border,10);if((!x||x<=0)&&(!w||w.indexOf(m)==-1))v['class']=(w||'')+' '+m;}}});if(t)t.addRules({elements:{table:function(u){var v=u.attributes,w=v['class'];w&&(v['class']=w.replace(m,'').replace(/\s{2}/,' ').replace(/^\s+|\s+$/,''));}}});}});a.on('dialogDefinition',function(q){var r=q.data.name;if(r=='table'||r=='tableProperties'){var s=q.data.definition,t=s.getContents('info'),u=t.get('txtBorder'),v=u.commit;u.commit=e.override(v,function(y){return function(z,A){y.apply(this,arguments);var B=parseInt(this.getValue(),10);A[!B||B<=0?'addClass':'removeClass'](m);};});var w=s.getContents('advanced'),x=w&&w.get('advCSSClasses');if(x){x.setup=e.override(x.setup,function(y){return function(){y.apply(this,arguments);this.setValue(this.getValue().replace(/cke_show_border/,''));};});x.commit=e.override(x.commit,function(y){return function(z,A){y.apply(this,arguments);if(!parseInt(A.getAttribute('border'),10))A.addClass('cke_show_border');};});}}});})();j.add('sourcearea',{requires:['editingblock'],init:function(m){var n=j.sourcearea,o=a.document.getWindow();m.on('editingBlockReady',function(){var p,q;m.addMode('source',{load:function(r,s){if(c&&b.version<8)r.setStyle('position','relative');m.textarea=p=new h('textarea');p.setAttributes({dir:'ltr',tabIndex:b.webkit?-1:m.tabIndex,role:'textbox','aria-label':m.lang.editorTitle.replace('%1',m.name)});p.addClass('cke_source');p.addClass('cke_enable_context_menu');m.readOnly&&p.setAttribute('readOnly','readonly');var t={width:b.ie7Compat?'99%':'100%',height:'100%',resize:'none',outline:'none','text-align':'left'};if(c){q=function(){p.hide();p.setStyle('height',r.$.clientHeight+'px');p.setStyle('width',r.$.clientWidth+'px');p.show();};m.on('resize',q);o.on('resize',q);setTimeout(q,0);}r.setHtml('');r.append(p);p.setStyles(t);m.fire('ariaWidget',p);p.on('blur',function(){m.focusManager.blur();});p.on('focus',function(){m.focusManager.focus();});m.mayBeDirty=true;this.loadData(s);var u=m.keystrokeHandler;if(u)u.attach(p);setTimeout(function(){m.mode='source';m.fire('mode',{previousMode:m._.previousMode});},b.gecko||b.webkit?100:0);},loadData:function(r){p.setValue(r);m.fire('dataReady');},getData:function(){return p.getValue();},getSnapshotData:function(){return p.getValue();},unload:function(r){p.clearCustomData();m.textarea=p=null;if(q){m.removeListener('resize',q);o.removeListener('resize',q);}if(c&&b.version<8)r.removeStyle('position');
},focus:function(){p.focus();}});});m.on('readOnly',function(){if(m.mode=='source')if(m.readOnly)m.textarea.setAttribute('readOnly','readonly');else m.textarea.removeAttribute('readOnly');});m.addCommand('source',n.commands.source);if(m.ui.addButton)m.ui.addButton('Source',{label:m.lang.source,command:'source'});m.on('mode',function(){m.getCommand('source').setState(m.mode=='source'?1:2);});}});j.sourcearea={commands:{source:{modes:{wysiwyg:1,source:1},editorFocus:false,readOnly:1,exec:function(m){if(m.mode=='wysiwyg')m.fire('saveSnapshot');m.getCommand('source').setState(0);m.setMode(m.mode=='source'?'wysiwyg':'source');},canUndo:false}}};(function(){j.add('stylescombo',{requires:['richcombo','styles'],init:function(n){var o=n.config,p=n.lang.stylesCombo,q={},r=[],s;function t(u){n.getStylesSet(function(v){if(!r.length){var w,x;for(var y=0,z=v.length;y<z;y++){var A=v[y];x=A.name;w=q[x]=new a.style(A);w._name=x;w._.enterMode=o.enterMode;r.push(w);}r.sort(m);}u&&u();});};n.ui.addRichCombo('Styles',{label:p.label,title:p.panelTitle,className:'cke_styles',panel:{css:n.skin.editor.css.concat(o.contentsCss),multiSelect:true,attributes:{'aria-label':p.panelTitle}},init:function(){s=this;t(function(){var u,v,w,x,y,z;for(y=0,z=r.length;y<z;y++){u=r[y];v=u._name;x=u.type;if(x!=w){s.startGroup(p['panelTitle'+String(x)]);w=x;}s.add(v,u.type==3?v:u.buildPreview(),v);}s.commit();});},onClick:function(u){n.focus();n.fire('saveSnapshot');var v=q[u],w=n.getSelection(),x=new d.elementPath(w.getStartElement());v[v.checkActive(x)?'remove':'apply'](n.document);n.fire('saveSnapshot');},onRender:function(){n.on('selectionChange',function(u){var v=this.getValue(),w=u.data.path,x=w.elements;for(var y=0,z=x.length,A;y<z;y++){A=x[y];for(var B in q){if(q[B].checkElementRemovable(A,true)){if(B!=v)this.setValue(B);return;}}}this.setValue('');},this);},onOpen:function(){var B=this;if(c||b.webkit)n.focus();var u=n.getSelection(),v=u.getSelectedElement(),w=new d.elementPath(v||u.getStartElement()),x=[0,0,0,0];B.showAll();B.unmarkAll();for(var y in q){var z=q[y],A=z.type;if(z.checkActive(w))B.mark(y);else if(A==3&&!z.checkApplicable(w)){B.hideItem(y);x[A]--;}x[A]++;}if(!x[1])B.hideGroup(p['panelTitle'+String(1)]);if(!x[2])B.hideGroup(p['panelTitle'+String(2)]);if(!x[3])B.hideGroup(p['panelTitle'+String(3)]);},reset:function(){if(s){delete s._.panel;delete s._.list;s._.committed=0;s._.items={};s._.state=2;}q={};r=[];t();}});n.on('instanceReady',function(){t();});}});function m(n,o){var p=n.type,q=o.type;
return p==q?0:p==3?-1:q==3?1:q==1?1:-1;};})();j.add('table',{requires:['dialog'],init:function(m){var n=j.table,o=m.lang.table;m.addCommand('table',new a.dialogCommand('table'));m.addCommand('tableProperties',new a.dialogCommand('tableProperties'));m.ui.addButton('Table',{label:o.toolbar,command:'table'});a.dialog.add('table',this.path+'dialogs/table.js');a.dialog.add('tableProperties',this.path+'dialogs/table.js');if(m.addMenuItems)m.addMenuItems({table:{label:o.menu,command:'tableProperties',group:'table',order:5},tabledelete:{label:o.deleteTable,command:'tableDelete',group:'table',order:1}});m.on('doubleclick',function(p){var q=p.data.element;if(q.is('table'))p.data.dialog='tableProperties';});if(m.contextMenu)m.contextMenu.addListener(function(p,q){if(!p||p.isReadOnly())return null;var r=p.hasAscendant('table',1);if(r)return{tabledelete:2,table:2};return null;});}});(function(){var m=/^(?:td|th)$/;function n(G){var H=G.getRanges(),I=[],J={};function K(S){if(I.length>0)return;if(S.type==1&&m.test(S.getName())&&!S.getCustomData('selected_cell')){h.setMarker(J,S,'selected_cell',true);I.push(S);}};for(var L=0;L<H.length;L++){var M=H[L];if(M.collapsed){var N=M.getCommonAncestor(),O=N.getAscendant('td',true)||N.getAscendant('th',true);if(O)I.push(O);}else{var P=new d.walker(M),Q;P.guard=K;while(Q=P.next()){var R=Q.getAscendant('td')||Q.getAscendant('th');if(R&&!R.getCustomData('selected_cell')){h.setMarker(J,R,'selected_cell',true);I.push(R);}}}}h.clearAllMarkers(J);return I;};function o(G){var H=0,I=G.length-1,J={},K,L,M;while(K=G[H++])h.setMarker(J,K,'delete_cell',true);H=0;while(K=G[H++]){if((L=K.getPrevious())&&!L.getCustomData('delete_cell')||(L=K.getNext())&&!L.getCustomData('delete_cell')){h.clearAllMarkers(J);return L;}}h.clearAllMarkers(J);M=G[0].getParent();if(M=M.getPrevious())return M.getLast();M=G[I].getParent();if(M=M.getNext())return M.getChild(0);return null;};function p(G,H){var I=n(G),J=I[0],K=J.getAscendant('table'),L=J.getDocument(),M=I[0].getParent(),N=M.$.rowIndex,O=I[I.length-1],P=O.getParent().$.rowIndex+O.$.rowSpan-1,Q=new h(K.$.rows[P]),R=H?N:P,S=H?M:Q,T=e.buildTableMap(K),U=T[R],V=H?T[R-1]:T[R+1],W=T[0].length,X=L.createElement('tr');for(var Y=0;U[Y]&&Y<W;Y++){var Z;if(U[Y].rowSpan>1&&V&&U[Y]==V[Y]){Z=U[Y];Z.rowSpan+=1;}else{Z=new h(U[Y]).clone();Z.removeAttribute('rowSpan');!c&&Z.appendBogus();X.append(Z);Z=Z.$;}Y+=Z.colSpan-1;}H?X.insertBefore(S):X.insertAfter(S);};function q(G){if(G instanceof d.selection){var H=n(G),I=H[0],J=I.getAscendant('table'),K=e.buildTableMap(J),L=H[0].getParent(),M=L.$.rowIndex,N=H[H.length-1],O=N.getParent().$.rowIndex+N.$.rowSpan-1,P=[];
for(var Q=M;Q<=O;Q++){var R=K[Q],S=new h(J.$.rows[Q]);for(var T=0;T<R.length;T++){var U=new h(R[T]),V=U.getParent().$.rowIndex;if(U.$.rowSpan==1)U.remove();else{U.$.rowSpan-=1;if(V==Q){var W=K[Q+1];W[T-1]?U.insertAfter(new h(W[T-1])):new h(J.$.rows[Q+1]).append(U,1);}}T+=U.$.colSpan-1;}P.push(S);}var X=J.$.rows,Y=new h(X[O+1]||(M>0?X[M-1]:null)||J.$.parentNode);for(Q=P.length;Q>=0;Q--)q(P[Q]);return Y;}else if(G instanceof h){J=G.getAscendant('table');if(J.$.rows.length==1)J.remove();else G.remove();}return null;};function r(G,H){var I=G.getParent(),J=I.$.cells,K=0;for(var L=0;L<J.length;L++){var M=J[L];K+=H?1:M.colSpan;if(M==G.$)break;}return K-1;};function s(G,H){var I=H?Infinity:0;for(var J=0;J<G.length;J++){var K=r(G[J],H);if(H?K<I:K>I)I=K;}return I;};function t(G,H){var I=n(G),J=I[0],K=J.getAscendant('table'),L=s(I,1),M=s(I),N=H?L:M,O=e.buildTableMap(K),P=[],Q=[],R=O.length;for(var S=0;S<R;S++){P.push(O[S][N]);var T=H?O[S][N-1]:O[S][N+1];Q.push(T);}for(S=0;S<R;S++){var U;if(!P[S])continue;if(P[S].colSpan>1&&Q[S]==P[S]){U=P[S];U.colSpan+=1;}else{U=new h(P[S]).clone();U.removeAttribute('colSpan');!c&&U.appendBogus();U[H?'insertBefore':'insertAfter'].call(U,new h(P[S]));U=U.$;}S+=U.rowSpan-1;}};function u(G){var H=n(G),I=H[0],J=H[H.length-1],K=I.getAscendant('table'),L=e.buildTableMap(K),M,N,O=[];for(var P=0,Q=L.length;P<Q;P++)for(var R=0,S=L[P].length;R<S;R++){if(L[P][R]==I.$)M=R;if(L[P][R]==J.$)N=R;}for(P=M;P<=N;P++)for(R=0;R<L.length;R++){var T=L[R],U=new h(K.$.rows[R]),V=new h(T[P]);if(V.$){if(V.$.colSpan==1)V.remove();else V.$.colSpan-=1;R+=V.$.rowSpan-1;if(!U.$.cells.length)O.push(U);}}var W=K.$.rows[0]&&K.$.rows[0].cells,X=new h(W[M]||(M?W[M-1]:K.$.parentNode));if(O.length==Q)K.remove();return X;};function v(G){var H=[],I=G[0]&&G[0].getAscendant('table'),J,K,L,M;for(J=0,K=G.length;J<K;J++)H.push(G[J].$.cellIndex);H.sort();for(J=1,K=H.length;J<K;J++){if(H[J]-H[J-1]>1){L=H[J-1]+1;break;}}if(!L)L=H[0]>0?H[0]-1:H[H.length-1]+1;var N=I.$.rows;for(J=0,K=N.length;J<K;J++){M=N[J].cells[L];if(M)break;}return M?new h(M):I.getPrevious();};function w(G,H){var I=G.getStartElement(),J=I.getAscendant('td',1)||I.getAscendant('th',1);if(!J)return;var K=J.clone();if(!c)K.appendBogus();if(H)K.insertBefore(J);else K.insertAfter(J);};function x(G){if(G instanceof d.selection){var H=n(G),I=H[0]&&H[0].getAscendant('table'),J=o(H);for(var K=H.length-1;K>=0;K--)x(H[K]);if(J)z(J,true);else if(I)I.remove();}else if(G instanceof h){var L=G.getParent();if(L.getChildCount()==1)L.remove();
else G.remove();}};function y(G){var H=G.getBogus();H&&H.remove();G.trim();};function z(G,H){var I=new d.range(G.getDocument());if(!I['moveToElementEdit'+(H?'End':'Start')](G)){I.selectNodeContents(G);I.collapse(H?false:true);}I.select(true);};function A(G,H,I){var J=G[H];if(typeof I=='undefined')return J;for(var K=0;J&&K<J.length;K++){if(I.is&&J[K]==I.$)return K;else if(K==I)return new h(J[K]);}return I.is?-1:null;};function B(G,H){var I=[];for(var J=0;J<G.length;J++){var K=G[J];I.push(K[H]);if(K[H].rowSpan>1)J+=K[H].rowSpan-1;}return I;};function C(G,H,I){var J=n(G),K;if((H?J.length!=1:J.length<2)||(K=G.getCommonAncestor())&&K.type==1&&K.is('table'))return false;var L,M=J[0],N=M.getAscendant('table'),O=e.buildTableMap(N),P=O.length,Q=O[0].length,R=M.getParent().$.rowIndex,S=A(O,R,M);if(H){var T;try{var U=parseInt(M.getAttribute('rowspan'),10)||1,V=parseInt(M.getAttribute('colspan'),10)||1;T=O[H=='up'?R-U:H=='down'?R+U:R][H=='left'?S-V:H=='right'?S+V:S];}catch(an){return false;}if(!T||M.$==T)return false;J[H=='up'||H=='left'?'unshift':'push'](new h(T));}var W=M.getDocument(),X=R,Y=0,Z=0,aa=!I&&new d.documentFragment(W),ab=0;for(var ac=0;ac<J.length;ac++){L=J[ac];var ad=L.getParent(),ae=L.getFirst(),af=L.$.colSpan,ag=L.$.rowSpan,ah=ad.$.rowIndex,ai=A(O,ah,L);ab+=af*ag;Z=Math.max(Z,ai-S+af);Y=Math.max(Y,ah-R+ag);if(!I){if(y(L),L.getChildren().count()){if(ah!=X&&ae&&!(ae.isBlockBoundary&&ae.isBlockBoundary({br:1}))){var aj=aa.getLast(d.walker.whitespaces(true));if(aj&&!(aj.is&&aj.is('br')))aa.append('br');}L.moveChildren(aa);}ac?L.remove():L.setHtml('');}X=ah;}if(!I){aa.moveChildren(M);if(!c)M.appendBogus();if(Z>=Q)M.removeAttribute('rowSpan');else M.$.rowSpan=Y;if(Y>=P)M.removeAttribute('colSpan');else M.$.colSpan=Z;var ak=new d.nodeList(N.$.rows),al=ak.count();for(ac=al-1;ac>=0;ac--){var am=ak.getItem(ac);if(!am.$.cells.length){am.remove();al++;continue;}}return M;}else return Y*Z==ab;};function D(G,H){var I=n(G);if(I.length>1)return false;else if(H)return true;var J=I[0],K=J.getParent(),L=K.getAscendant('table'),M=e.buildTableMap(L),N=K.$.rowIndex,O=A(M,N,J),P=J.$.rowSpan,Q,R,S,T;if(P>1){R=Math.ceil(P/2);S=Math.floor(P/2);T=N+R;var U=new h(L.$.rows[T]),V=A(M,T),W;Q=J.clone();for(var X=0;X<V.length;X++){W=V[X];if(W.parentNode==U.$&&X>O){Q.insertBefore(new h(W));break;}else W=null;}if(!W)U.append(Q,true);}else{S=R=1;U=K.clone();U.insertAfter(K);U.append(Q=J.clone());var Y=A(M,N);for(var Z=0;Z<Y.length;Z++)Y[Z].rowSpan++;}if(!c)Q.appendBogus();J.$.rowSpan=R;Q.$.rowSpan=S;
if(R==1)J.removeAttribute('rowSpan');if(S==1)Q.removeAttribute('rowSpan');return Q;};function E(G,H){var I=n(G);if(I.length>1)return false;else if(H)return true;var J=I[0],K=J.getParent(),L=K.getAscendant('table'),M=e.buildTableMap(L),N=K.$.rowIndex,O=A(M,N,J),P=J.$.colSpan,Q,R,S;if(P>1){R=Math.ceil(P/2);S=Math.floor(P/2);}else{S=R=1;var T=B(M,O);for(var U=0;U<T.length;U++)T[U].colSpan++;}Q=J.clone();Q.insertAfter(J);if(!c)Q.appendBogus();J.$.colSpan=R;Q.$.colSpan=S;if(R==1)J.removeAttribute('colSpan');if(S==1)Q.removeAttribute('colSpan');return Q;};var F={thead:1,tbody:1,tfoot:1,td:1,tr:1,th:1};j.tabletools={requires:['table','dialog'],init:function(G){var H=G.lang.table;G.addCommand('cellProperties',new a.dialogCommand('cellProperties'));a.dialog.add('cellProperties',this.path+'dialogs/tableCell.js');G.addCommand('tableDelete',{exec:function(I){var J=I.getSelection(),K=J&&J.getStartElement(),L=K&&K.getAscendant('table',1);if(!L)return;var M=L.getParent();if(M.getChildCount()==1&&!M.is('body','td','th'))L=M;var N=new d.range(I.document);N.moveToPosition(L,3);L.remove();N.select();}});G.addCommand('rowDelete',{exec:function(I){var J=I.getSelection();z(q(J));}});G.addCommand('rowInsertBefore',{exec:function(I){var J=I.getSelection();p(J,true);}});G.addCommand('rowInsertAfter',{exec:function(I){var J=I.getSelection();p(J);}});G.addCommand('columnDelete',{exec:function(I){var J=I.getSelection(),K=u(J);K&&z(K,true);}});G.addCommand('columnInsertBefore',{exec:function(I){var J=I.getSelection();t(J,true);}});G.addCommand('columnInsertAfter',{exec:function(I){var J=I.getSelection();t(J);}});G.addCommand('cellDelete',{exec:function(I){var J=I.getSelection();x(J);}});G.addCommand('cellMerge',{exec:function(I){z(C(I.getSelection()),true);}});G.addCommand('cellMergeRight',{exec:function(I){z(C(I.getSelection(),'right'),true);}});G.addCommand('cellMergeDown',{exec:function(I){z(C(I.getSelection(),'down'),true);}});G.addCommand('cellVerticalSplit',{exec:function(I){z(D(I.getSelection()));}});G.addCommand('cellHorizontalSplit',{exec:function(I){z(E(I.getSelection()));}});G.addCommand('cellInsertBefore',{exec:function(I){var J=I.getSelection();w(J,true);}});G.addCommand('cellInsertAfter',{exec:function(I){var J=I.getSelection();w(J);}});if(G.addMenuItems)G.addMenuItems({tablecell:{label:H.cell.menu,group:'tablecell',order:1,getItems:function(){var I=G.getSelection(),J=n(I);return{tablecell_insertBefore:2,tablecell_insertAfter:2,tablecell_delete:2,tablecell_merge:C(I,null,true)?2:0,tablecell_merge_right:C(I,'right',true)?2:0,tablecell_merge_down:C(I,'down',true)?2:0,tablecell_split_vertical:D(I,true)?2:0,tablecell_split_horizontal:E(I,true)?2:0,tablecell_properties:J.length>0?2:0};
}},tablecell_insertBefore:{label:H.cell.insertBefore,group:'tablecell',command:'cellInsertBefore',order:5},tablecell_insertAfter:{label:H.cell.insertAfter,group:'tablecell',command:'cellInsertAfter',order:10},tablecell_delete:{label:H.cell.deleteCell,group:'tablecell',command:'cellDelete',order:15},tablecell_merge:{label:H.cell.merge,group:'tablecell',command:'cellMerge',order:16},tablecell_merge_right:{label:H.cell.mergeRight,group:'tablecell',command:'cellMergeRight',order:17},tablecell_merge_down:{label:H.cell.mergeDown,group:'tablecell',command:'cellMergeDown',order:18},tablecell_split_horizontal:{label:H.cell.splitHorizontal,group:'tablecell',command:'cellHorizontalSplit',order:19},tablecell_split_vertical:{label:H.cell.splitVertical,group:'tablecell',command:'cellVerticalSplit',order:20},tablecell_properties:{label:H.cell.title,group:'tablecellproperties',command:'cellProperties',order:21},tablerow:{label:H.row.menu,group:'tablerow',order:1,getItems:function(){return{tablerow_insertBefore:2,tablerow_insertAfter:2,tablerow_delete:2};}},tablerow_insertBefore:{label:H.row.insertBefore,group:'tablerow',command:'rowInsertBefore',order:5},tablerow_insertAfter:{label:H.row.insertAfter,group:'tablerow',command:'rowInsertAfter',order:10},tablerow_delete:{label:H.row.deleteRow,group:'tablerow',command:'rowDelete',order:15},tablecolumn:{label:H.column.menu,group:'tablecolumn',order:1,getItems:function(){return{tablecolumn_insertBefore:2,tablecolumn_insertAfter:2,tablecolumn_delete:2};}},tablecolumn_insertBefore:{label:H.column.insertBefore,group:'tablecolumn',command:'columnInsertBefore',order:5},tablecolumn_insertAfter:{label:H.column.insertAfter,group:'tablecolumn',command:'columnInsertAfter',order:10},tablecolumn_delete:{label:H.column.deleteColumn,group:'tablecolumn',command:'columnDelete',order:15}});if(G.contextMenu)G.contextMenu.addListener(function(I,J){if(!I||I.isReadOnly())return null;while(I){if(I.getName() in F)return{tablecell:2,tablerow:2,tablecolumn:2};I=I.getParent();}return null;});},getSelectedCells:n};j.add('tabletools',j.tabletools);})();e.buildTableMap=function(m){var n=m.$.rows,o=-1,p=[];for(var q=0;q<n.length;q++){o++;!p[o]&&(p[o]=[]);var r=-1;for(var s=0;s<n[q].cells.length;s++){var t=n[q].cells[s];r++;while(p[o][r])r++;var u=isNaN(t.colSpan)?1:t.colSpan,v=isNaN(t.rowSpan)?1:t.rowSpan;for(var w=0;w<v;w++){if(!p[o+w])p[o+w]=[];for(var x=0;x<u;x++)p[o+w][r+x]=n[q].cells[s];}r+=u-1;}}return p;};j.add('specialchar',{requires:['dialog'],availableLangs:{cs:1,cy:1,de:1,el:1,en:1,eo:1,et:1,fa:1,fi:1,fr:1,he:1,hr:1,it:1,nb:1,nl:1,no:1,'pt-br':1,tr:1,ug:1,'zh-cn':1},init:function(m){var n='specialchar',o=this;
a.dialog.add(n,this.path+'dialogs/specialchar.js');m.addCommand(n,{exec:function(){var p=m.langCode;p=o.availableLangs[p]?p:'en';a.scriptLoader.load(a.getUrl(o.path+'lang/'+p+'.js'),function(){e.extend(m.lang.specialChar,o.langEntries[p]);m.openDialog(n);});},modes:{wysiwyg:1},canUndo:false});m.ui.addButton('SpecialChar',{label:m.lang.specialChar.toolbar,command:n});}});i.specialChars=['!','&quot;','#','$','%','&amp;',"'",'(',')','*','+','-','.','/','0','1','2','3','4','5','6','7','8','9',':',';','&lt;','=','&gt;','?','@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','[',']','^','_','`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','{','|','}','~','&euro;','&lsquo;','&rsquo;','&ldquo;','&rdquo;','&ndash;','&mdash;','&iexcl;','&cent;','&pound;','&curren;','&yen;','&brvbar;','&sect;','&uml;','&copy;','&ordf;','&laquo;','&not;','&reg;','&macr;','&deg;','&sup2;','&sup3;','&acute;','&micro;','&para;','&middot;','&cedil;','&sup1;','&ordm;','&raquo;','&frac14;','&frac12;','&frac34;','&iquest;','&Agrave;','&Aacute;','&Acirc;','&Atilde;','&Auml;','&Aring;','&AElig;','&Ccedil;','&Egrave;','&Eacute;','&Ecirc;','&Euml;','&Igrave;','&Iacute;','&Icirc;','&Iuml;','&ETH;','&Ntilde;','&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&times;','&Oslash;','&Ugrave;','&Uacute;','&Ucirc;','&Uuml;','&Yacute;','&THORN;','&szlig;','&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;','&aelig;','&ccedil;','&egrave;','&eacute;','&ecirc;','&euml;','&igrave;','&iacute;','&icirc;','&iuml;','&eth;','&ntilde;','&ograve;','&oacute;','&ocirc;','&otilde;','&ouml;','&divide;','&oslash;','&ugrave;','&uacute;','&ucirc;','&uuml;','&yacute;','&thorn;','&yuml;','&OElig;','&oelig;','&#372;','&#374','&#373','&#375;','&sbquo;','&#8219;','&bdquo;','&hellip;','&trade;','&#9658;','&bull;','&rarr;','&rArr;','&hArr;','&diams;','&asymp;'];(function(){var m={editorFocus:false,modes:{wysiwyg:1,source:1}},n={exec:function(q){q.container.focusNext(true,q.tabIndex);}},o={exec:function(q){q.container.focusPrevious(true,q.tabIndex);}};function p(q){return{editorFocus:false,canUndo:false,modes:{wysiwyg:1},exec:function(r){if(r.focusManager.hasFocus){var s=r.getSelection(),t=s.getCommonAncestor(),u;if(u=t.getAscendant('td',true)||t.getAscendant('th',true)){var v=new d.range(r.document),w=e.tryThese(function(){var D=u.getParent(),E=D.$.cells[u.$.cellIndex+(q?-1:1)];E.parentNode.parentNode;return E;
},function(){var D=u.getParent(),E=D.getAscendant('table'),F=E.$.rows[D.$.rowIndex+(q?-1:1)];return F.cells[q?F.cells.length-1:0];});if(!(w||q)){var x=u.getAscendant('table').$,y=u.getParent().$.cells,z=new h(x.insertRow(-1),r.document);for(var A=0,B=y.length;A<B;A++){var C=z.append(new h(y[A],r.document).clone(false,false));!c&&C.appendBogus();}v.moveToElementEditStart(z);}else if(w){w=new h(w);v.moveToElementEditStart(w);if(!(v.checkStartOfBlock()&&v.checkEndOfBlock()))v.selectNodeContents(w);}else return true;v.select(true);return true;}}return false;}};};j.add('tab',{requires:['keystrokes'],init:function(q){var r=q.config.enableTabKeyTools!==false,s=q.config.tabSpaces||0,t='';while(s--)t+='\xa0';if(t)q.on('key',function(u){if(u.data.keyCode==9){q.insertHtml(t);u.cancel();}});if(r)q.on('key',function(u){if(u.data.keyCode==9&&q.execCommand('selectNextCell')||u.data.keyCode==2228224+9&&q.execCommand('selectPreviousCell'))u.cancel();});if(b.webkit||b.gecko)q.on('key',function(u){var v=u.data.keyCode;if(v==9&&!t){u.cancel();q.execCommand('blur');}if(v==2228224+9){q.execCommand('blurBack');u.cancel();}});q.addCommand('blur',e.extend(n,m));q.addCommand('blurBack',e.extend(o,m));q.addCommand('selectNextCell',p());q.addCommand('selectPreviousCell',p(true));}});})();h.prototype.focusNext=function(m,n){var w=this;var o=w.$,p=n===undefined?w.getTabIndex():n,q,r,s,t,u,v;if(p<=0){u=w.getNextSourceNode(m,1);while(u){if(u.isVisible()&&u.getTabIndex()===0){s=u;break;}u=u.getNextSourceNode(false,1);}}else{u=w.getDocument().getBody().getFirst();while(u=u.getNextSourceNode(false,1)){if(!q)if(!r&&u.equals(w)){r=true;if(m){if(!(u=u.getNextSourceNode(true,1)))break;q=1;}}else if(r&&!w.contains(u))q=1;if(!u.isVisible()||(v=u.getTabIndex())<0)continue;if(q&&v==p){s=u;break;}if(v>p&&(!s||!t||v<t)){s=u;t=v;}else if(!s&&v===0){s=u;t=v;}}}if(s)s.focus();};h.prototype.focusPrevious=function(m,n){var w=this;var o=w.$,p=n===undefined?w.getTabIndex():n,q,r,s,t=0,u,v=w.getDocument().getBody().getLast();while(v=v.getPreviousSourceNode(false,1)){if(!q)if(!r&&v.equals(w)){r=true;if(m){if(!(v=v.getPreviousSourceNode(true,1)))break;q=1;}}else if(r&&!w.contains(v))q=1;if(!v.isVisible()||(u=v.getTabIndex())<0)continue;if(p<=0){if(q&&u===0){s=v;break;}if(u>t){s=v;t=u;}}else{if(q&&u==p){s=v;break;}if(u<p&&(!s||u>t)){s=v;t=u;}}}if(s)s.focus();};(function(){j.add('templates',{requires:['dialog'],init:function(o){a.dialog.add('templates',a.getUrl(this.path+'dialogs/templates.js'));o.addCommand('templates',new a.dialogCommand('templates'));
o.ui.addButton('Templates',{label:o.lang.templates.button,command:'templates'});}});var m={},n={};a.addTemplates=function(o,p){m[o]=p;};a.getTemplates=function(o){return m[o];};a.loadTemplates=function(o,p){var q=[];for(var r=0,s=o.length;r<s;r++){if(!n[o[r]]){q.push(o[r]);n[o[r]]=1;}}if(q.length)a.scriptLoader.load(q,p);else setTimeout(p,0);};})();i.templates_files=[a.getUrl('plugins/templates/templates/default.js')];i.templates_replaceContent=true;(function(){var m=function(){this.toolbars=[];this.focusCommandExecuted=false;};m.prototype.focus=function(){for(var o=0,p;p=this.toolbars[o++];)for(var q=0,r;r=p.items[q++];){if(r.focus){r.focus();return;}}};var n={toolbarFocus:{modes:{wysiwyg:1,source:1},readOnly:1,exec:function(o){if(o.toolbox){o.toolbox.focusCommandExecuted=true;if(c||b.air)setTimeout(function(){o.toolbox.focus();},100);else o.toolbox.focus();}}}};j.add('toolbar',{requires:['button'],init:function(o){var p,q=function(r,s){var t,u,v=o.lang.dir=='rtl',w=o.config.toolbarGroupCycling;w=w===undefined||w;switch(s){case 9:case 2228224+9:while(!u||!u.items.length){u=s==9?(u?u.next:r.toolbar.next)||o.toolbox.toolbars[0]:(u?u.previous:r.toolbar.previous)||o.toolbox.toolbars[o.toolbox.toolbars.length-1];if(u.items.length){r=u.items[p?u.items.length-1:0];while(r&&!r.focus){r=p?r.previous:r.next;if(!r)u=0;}}}if(r)r.focus();return false;case v?37:39:case 40:t=r;do{t=t.next;if(!t&&w)t=r.toolbar.items[0];}while(t&&!t.focus);if(t)t.focus();else q(r,9);return false;case v?39:37:case 38:t=r;do{t=t.previous;if(!t&&w)t=r.toolbar.items[r.toolbar.items.length-1];}while(t&&!t.focus);if(t)t.focus();else{p=1;q(r,2228224+9);p=0;}return false;case 27:o.focus();return false;case 13:case 32:r.execute();return false;}return true;};o.on('themeSpace',function(r){if(r.data.space==o.config.toolbarLocation){o.toolbox=new m();var s=e.getNextId(),t=['<div class="cke_toolbox" role="group" aria-labelledby="',s,'" onmousedown="return false;"'],u=o.config.toolbarStartupExpanded!==false,v;t.push(u?'>':' style="display:none">');t.push('<span id="',s,'" class="cke_voice_label">',o.lang.toolbars,'</span>');var w=o.toolbox.toolbars,x=o.config.toolbar instanceof Array?o.config.toolbar:o.config['toolbar_'+o.config.toolbar];for(var y=0;y<x.length;y++){var z,A=0,B,C=x[y],D;if(!C)continue;if(v){t.push('</div>');v=0;}if(C==='/'){t.push('<div class="cke_break"></div>');continue;}D=C.items||C;for(var E=0;E<D.length;E++){var F,G=D[E],H;F=o.ui.create(G);if(F){H=F.canGroup!==false;if(!A){z=e.getNextId();
A={id:z,items:[]};B=C.name&&(o.lang.toolbarGroups[C.name]||C.name);t.push('<span id="',z,'" class="cke_toolbar"',B?' aria-labelledby="'+z+'_label"':'',' role="toolbar">');B&&t.push('<span id="',z,'_label" class="cke_voice_label">',B,'</span>');t.push('<span class="cke_toolbar_start"></span>');var I=w.push(A)-1;if(I>0){A.previous=w[I-1];A.previous.next=A;}}if(H){if(!v){t.push('<span class="cke_toolgroup" role="presentation">');v=1;}}else if(v){t.push('</span>');v=0;}var J=F.render(o,t);I=A.items.push(J)-1;if(I>0){J.previous=A.items[I-1];J.previous.next=J;}J.toolbar=A;J.onkey=q;J.onfocus=function(){if(!o.toolbox.focusCommandExecuted)o.focus();};}}if(v){t.push('</span>');v=0;}if(A)t.push('<span class="cke_toolbar_end"></span></span>');}t.push('</div>');if(o.config.toolbarCanCollapse){var K=e.addFunction(function(){o.execCommand('toolbarCollapse');});o.on('destroy',function(){e.removeFunction(K);});var L=e.getNextId();o.addCommand('toolbarCollapse',{readOnly:1,exec:function(M){var N=a.document.getById(L),O=N.getPrevious(),P=M.getThemeSpace('contents'),Q=O.getParent(),R=parseInt(P.$.style.height,10),S=Q.$.offsetHeight,T=!O.isVisible();if(!T){O.hide();N.addClass('cke_toolbox_collapser_min');N.setAttribute('title',M.lang.toolbarExpand);}else{O.show();N.removeClass('cke_toolbox_collapser_min');N.setAttribute('title',M.lang.toolbarCollapse);}N.getFirst().setText(T?'▲':'◀');var U=Q.$.offsetHeight-S;P.setStyle('height',R-U+'px');M.fire('resize');},modes:{wysiwyg:1,source:1}});t.push('<a title="'+(u?o.lang.toolbarCollapse:o.lang.toolbarExpand)+'" id="'+L+'" tabIndex="-1" class="cke_toolbox_collapser');if(!u)t.push(' cke_toolbox_collapser_min');t.push('" onclick="CKEDITOR.tools.callFunction('+K+')">','<span>&#9650;</span>','</a>');}r.data.html+=t.join('');}});o.on('destroy',function(){var r,s=0,t,u,v;r=this.toolbox.toolbars;for(;s<r.length;s++){u=r[s].items;for(t=0;t<u.length;t++){v=u[t];if(v.clickFn)e.removeFunction(v.clickFn);if(v.keyDownFn)e.removeFunction(v.keyDownFn);}}});o.addCommand('toolbarFocus',n.toolbarFocus);o.ui.add('-',a.UI_SEPARATOR,{});o.ui.addHandler(a.UI_SEPARATOR,{create:function(){return{render:function(r,s){s.push('<span class="cke_separator" role="separator"></span>');return{};}};}});}});})();a.UI_SEPARATOR='separator';i.toolbarLocation='top';i.toolbar_Basic=[['Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink','-','About']];i.toolbar_Full=[{name:'document',items:['Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates']},{name:'clipboard',items:['Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo']},{name:'editing',items:['Find','Replace','-','SelectAll','-','SpellChecker','Scayt']},{name:'forms',items:['Form','Checkbox','Radio','TextField','Textarea','Select','Button','ImageButton','HiddenField']},'/',{name:'basicstyles',items:['Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat']},{name:'paragraph',items:['NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl']},{name:'links',items:['Link','Unlink','Anchor']},{name:'insert',items:['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe']},'/',{name:'styles',items:['Styles','Format','Font','FontSize']},{name:'colors',items:['TextColor','BGColor']},{name:'tools',items:['Maximize','ShowBlocks','-','About']}];
i.toolbar='Full';i.toolbarCanCollapse=true;(function(){j.add('undo',{requires:['selection','wysiwygarea'],init:function(s){var t=new o(s),u=s.addCommand('undo',{exec:function(){if(t.undo()){s.selectionChange();this.fire('afterUndo');}},state:0,canUndo:false}),v=s.addCommand('redo',{exec:function(){if(t.redo()){s.selectionChange();this.fire('afterRedo');}},state:0,canUndo:false});t.onChange=function(){u.setState(t.undoable()?2:0);v.setState(t.redoable()?2:0);};function w(x){if(t.enabled&&x.data.command.canUndo!==false)t.save();};s.on('beforeCommandExec',w);s.on('afterCommandExec',w);s.on('saveSnapshot',function(x){t.save(x.data&&x.data.contentOnly);});s.on('contentDom',function(){s.document.on('keydown',function(x){if(!x.data.$.ctrlKey&&!x.data.$.metaKey)t.type(x);});});s.on('beforeModeUnload',function(){s.mode=='wysiwyg'&&t.save(true);});s.on('mode',function(){t.enabled=s.readOnly?false:s.mode=='wysiwyg';t.onChange();});s.ui.addButton('Undo',{label:s.lang.undo,command:'undo'});s.ui.addButton('Redo',{label:s.lang.redo,command:'redo'});s.resetUndo=function(){t.reset();s.fire('saveSnapshot');};s.on('updateSnapshot',function(){if(t.currentImage)t.update();});}});j.undo={};var m=j.undo.Image=function(s){this.editor=s;s.fire('beforeUndoImage');var t=s.getSnapshot(),u=t&&s.getSelection();c&&t&&(t=t.replace(/\s+data-cke-expando=".*?"/g,''));this.contents=t;this.bookmarks=u&&u.createBookmarks2(true);s.fire('afterUndoImage');},n=/\b(?:href|src|name)="[^"]*?"/gi;m.prototype={equals:function(s,t){var u=this.contents,v=s.contents;if(c&&(b.ie7Compat||b.ie6Compat)){u=u.replace(n,'');v=v.replace(n,'');}if(u!=v)return false;if(t)return true;var w=this.bookmarks,x=s.bookmarks;if(w||x){if(!w||!x||w.length!=x.length)return false;for(var y=0;y<w.length;y++){var z=w[y],A=x[y];if(z.startOffset!=A.startOffset||z.endOffset!=A.endOffset||!e.arrayCompare(z.start,A.start)||!e.arrayCompare(z.end,A.end))return false;}}return true;}};function o(s){this.editor=s;this.reset();};var p={8:1,46:1},q={16:1,17:1,18:1},r={37:1,38:1,39:1,40:1};o.prototype={type:function(s){var t=s&&s.data.getKey(),u=t in q,v=t in p,w=this.lastKeystroke in p,x=v&&t==this.lastKeystroke,y=t in r,z=this.lastKeystroke in r,A=!v&&!y,B=v&&!x,C=!(u||this.typing)||A&&(w||z);if(C||B){var D=new m(this.editor),E=this.snapshots.length;e.setTimeout(function(){var G=this;var F=G.editor.getSnapshot();if(c)F=F.replace(/\s+data-cke-expando=".*?"/g,'');if(D.contents!=F&&E==G.snapshots.length){G.typing=true;if(!G.save(false,D,false))G.snapshots.splice(G.index+1,G.snapshots.length-G.index-1);
G.hasUndo=true;G.hasRedo=false;G.typesCount=1;G.modifiersCount=1;G.onChange();}},0,this);}this.lastKeystroke=t;if(v){this.typesCount=0;this.modifiersCount++;if(this.modifiersCount>25){this.save(false,null,false);this.modifiersCount=1;}}else if(!y){this.modifiersCount=0;this.typesCount++;if(this.typesCount>25){this.save(false,null,false);this.typesCount=1;}}},reset:function(){var s=this;s.lastKeystroke=0;s.snapshots=[];s.index=-1;s.limit=s.editor.config.undoStackSize||20;s.currentImage=null;s.hasUndo=false;s.hasRedo=false;s.resetType();},resetType:function(){var s=this;s.typing=false;delete s.lastKeystroke;s.typesCount=0;s.modifiersCount=0;},fireChange:function(){var s=this;s.hasUndo=!!s.getNextImage(true);s.hasRedo=!!s.getNextImage(false);s.resetType();s.onChange();},save:function(s,t,u){var w=this;var v=w.snapshots;if(!t)t=new m(w.editor);if(t.contents===false)return false;if(w.currentImage&&t.equals(w.currentImage,s))return false;v.splice(w.index+1,v.length-w.index-1);if(v.length==w.limit)v.shift();w.index=v.push(t)-1;w.currentImage=t;if(u!==false)w.fireChange();return true;},restoreImage:function(s){var w=this;var t=w.editor,u;if(s.bookmarks){t.focus();u=t.getSelection();}w.editor.loadSnapshot(s.contents);if(s.bookmarks)u.selectBookmarks(s.bookmarks);else if(c){var v=w.editor.document.getBody().$.createTextRange();v.collapse(true);v.select();}w.index=s.index;w.update();w.fireChange();},getNextImage:function(s){var x=this;var t=x.snapshots,u=x.currentImage,v,w;if(u)if(s)for(w=x.index-1;w>=0;w--){v=t[w];if(!u.equals(v,true)){v.index=w;return v;}}else for(w=x.index+1;w<t.length;w++){v=t[w];if(!u.equals(v,true)){v.index=w;return v;}}return null;},redoable:function(){return this.enabled&&this.hasRedo;},undoable:function(){return this.enabled&&this.hasUndo;},undo:function(){var t=this;if(t.undoable()){t.save(true);var s=t.getNextImage(true);if(s)return t.restoreImage(s),true;}return false;},redo:function(){var t=this;if(t.redoable()){t.save(true);if(t.redoable()){var s=t.getNextImage(false);if(s)return t.restoreImage(s),true;}}return false;},update:function(){var s=this;s.snapshots.splice(s.index,1,s.currentImage=new m(s.editor));}};})();(function(){var m=/(^|<body\b[^>]*>)\s*<(p|div|address|h\d|center|pre)[^>]*>\s*(?:<br[^>]*>|&nbsp;|\u00A0|&#160;)?\s*(:?<\/\2>)?\s*(?=$|<\/body>)/gi,n=d.walker.whitespaces(true),o=d.walker.bogus(true),p=function(E){return n(E)&&o(E);};function q(E){return E.isBlockBoundary()&&f.$empty[E.getName()];};function r(E){return function(F){if(this.mode=='wysiwyg'){this.focus();
var G=this.getSelection(),H=G.isLocked;H&&G.unlock();this.fire('saveSnapshot');E.call(this,F.data);H&&this.getSelection().lock();var I=this;setTimeout(function(){try{I.fire('saveSnapshot');}catch(J){setTimeout(function(){I.fire('saveSnapshot');},200);}},0);}};};function s(E){var N=this;if(N.dataProcessor)E=N.dataProcessor.toHtml(E);if(!E)return;var F=N.getSelection(),G=F.getRanges()[0];if(G.checkReadOnly())return;if(b.opera){var H=new d.elementPath(G.startContainer);if(H.block){var I=a.htmlParser.fragment.fromHtml(E,false).children;for(var J=0,K=I.length;J<K;J++){if(I[J]._.isBlockLike){G.splitBlock(N.enterMode==3?'div':'p');G.insertNode(G.document.createText(''));G.select();break;}}}}if(c){var L=F.getNative();if(L.type=='Control')L.clear();else if(F.getType()==2){G=F.getRanges()[0];var M=G&&G.endContainer;if(M&&M.type==1&&M.getAttribute('contenteditable')=='false'&&G.checkBoundaryOfElement(M,2)){G.setEndAfter(G.endContainer);G.deleteContents();}}L.createRange().pasteHTML(E);}else N.document.$.execCommand('inserthtml',false,E);if(b.webkit){F=N.getSelection();F.scrollIntoView();}};function t(E){var F=this.getSelection(),G=F.getStartElement().hasAscendant('pre',true)?2:this.config.enterMode,H=G==2,I=e.htmlEncode(E.replace(/\r\n|\r/g,'\n'));I=I.replace(/^[ \t]+|[ \t]+$/g,function(O,P,Q){if(O.length==1)return '&nbsp;';else if(!P)return e.repeat('&nbsp;',O.length-1)+' ';else return ' '+e.repeat('&nbsp;',O.length-1);});I=I.replace(/[ \t]{2,}/g,function(O){return e.repeat('&nbsp;',O.length-1)+' ';});var J=G==1?'p':'div';if(!H)I=I.replace(/(\n{2})([\s\S]*?)(?:$|\1)/g,function(O,P,Q){return '<'+J+'>'+Q+'</'+J+'>';});I=I.replace(/\n/g,'<br>');if(!(H||c))I=I.replace(new RegExp('<br>(?=</'+J+'>)'),function(O){return e.repeat(O,2);});if(b.gecko||b.webkit){var K=new d.elementPath(F.getStartElement()),L=[];for(var M=0;M<K.elements.length;M++){var N=K.elements[M].getName();if(N in f.$inline)L.unshift(K.elements[M].getOuterHtml().match(/^<.*?>/));else if(N in f.$block)break;}I=L.join('')+I;}s.call(this,I);};function u(E){var F=this.getSelection(),G=F.getRanges(),H=E.getName(),I=f.$block[H],J=F.isLocked;if(J)F.unlock();var K,L,M,N;for(var O=G.length-1;O>=0;O--){K=G[O];if(!K.checkReadOnly()){K.deleteContents(1);L=!O&&E||E.clone(1);var P,Q;if(I)while((P=K.getCommonAncestor(0,1))&&(Q=f[P.getName()])&&!(Q&&Q[H])){if(P.getName() in f.span)K.splitElement(P);else if(K.checkStartOfBlock()&&K.checkEndOfBlock()){K.setStartBefore(P);K.collapse(true);P.remove();}else K.splitBlock();}K.insertNode(L);
if(!M)M=L;}}if(M){K.moveToPosition(M,4);if(I){var R=M.getNext(p),S=R&&R.type==1&&R.getName();if(S&&f.$block[S]){if(f[S]['#'])K.moveToElementEditStart(R);else K.moveToElementEditEnd(M);}else if(!R){R=K.fixBlock(true,this.config.enterMode==3?'div':'p');K.moveToElementEditStart(R);}}}F.selectRanges([K]);if(J)this.getSelection().lock();};function v(E){if(!E.checkDirty())setTimeout(function(){E.resetDirty();},0);};var w=d.walker.whitespaces(true),x=d.walker.bookmark(false,true);function y(E){return w(E)&&x(E);};function z(E){return E.type==3&&e.trim(E.getText()).match(/^(?:&nbsp;|\xa0)$/);};function A(E){if(E.isLocked){E.unlock();setTimeout(function(){E.lock();},0);}};function B(E){return E.getOuterHtml().match(m);};w=d.walker.whitespaces(true);function C(E){var F=E.window,G=E.document,H=E.document.getBody(),I=H.getFirst(),J=H.getChildren().count();if(!J||J==1&&I.type==1&&I.hasAttribute('_moz_editor_bogus_node')){v(E);var K=E.element.getDocument(),L=K.getDocumentElement(),M=L.$.scrollTop,N=L.$.scrollLeft,O=G.$.createEvent('KeyEvents');O.initKeyEvent('keypress',true,true,F.$,false,false,false,false,0,32);G.$.dispatchEvent(O);if(M!=L.$.scrollTop||N!=L.$.scrollLeft)K.getWindow().$.scrollTo(N,M);J&&H.getFirst().remove();G.getBody().appendBogus();var P=new d.range(G);P.setStartAt(H,1);P.select();}};function D(E){var F=E.editor,G=E.data.path,H=G.blockLimit,I=E.data.selection,J=I.getRanges()[0],K=F.document.getBody(),L=F.config.enterMode;if(b.gecko){var M=G.block||G.blockLimit,N=M&&M.getLast(y);if(M&&M.isBlockBoundary()&&!(N&&N.type==1&&N.isBlockBoundary())&&!M.is('pre')&&!M.getBogus())M.appendBogus();}if(F.config.autoParagraph!==false&&L!=2&&J.collapsed&&H.getName()=='body'&&!G.block){var O=J.fixBlock(true,F.config.enterMode==3?'div':'p');if(c){var P=O.getFirst(y);P&&z(P)&&P.remove();}if(B(O)){var Q=O.getNext(w);if(Q&&Q.type==1&&!q(Q)){J.moveToElementEditStart(Q);O.remove();}else{Q=O.getPrevious(w);if(Q&&Q.type==1&&!q(Q)){J.moveToElementEditEnd(Q);O.remove();}}}J.select();E.cancel();}var R=new d.range(F.document);R.moveToElementEditEnd(F.document.getBody());var S=new d.elementPath(R.startContainer);if(!S.blockLimit.is('body')){var T;if(L!=2)T=K.append(F.document.createElement(L==1?'p':'div'));else T=K;if(!c)T.appendBogus();}};j.add('wysiwygarea',{requires:['editingblock'],init:function(E){var F=E.config.enterMode!=2&&E.config.autoParagraph!==false?E.config.enterMode==3?'div':'p':false,G=E.lang.editorTitle.replace('%1',E.name),H=E.lang.editorHelp;if(c)G+=', '+H;var I=a.document.getWindow(),J;
E.on('editingBlockReady',function(){var M,N,O,P,Q,R,S,T=b.isCustomDomain(),U=function(X){if(N)N.remove();var Y='document.open();'+(T?'document.domain="'+document.domain+'";':'')+'document.close();';Y=b.air?'javascript:void(0)':c?'javascript:void(function(){'+encodeURIComponent(Y)+'}())':'';var Z=e.getNextId();N=h.createFromHtml('<iframe style="width:100%;height:100%" frameBorder="0" aria-describedby="'+Z+'"'+' title="'+G+'"'+' src="'+Y+'"'+' tabIndex="'+(b.webkit?-1:E.tabIndex)+'"'+' allowTransparency="true"'+'></iframe>');if(document.location.protocol=='chrome:')a.event.useCapture=true;N.on('load',function(aa){Q=1;aa.removeListener();var ab=N.getFrameDocument();ab.write(X);b.air&&W(ab.getWindow().$);});if(document.location.protocol=='chrome:')a.event.useCapture=false;M.append(h.createFromHtml('<span id="'+Z+'" class="cke_voice_label">'+H+'</span>'));M.append(N);if(b.webkit){S=function(){M.setStyle('width','100%');N.hide();N.setSize('width',M.getSize('width'));M.removeStyle('width');N.show();};I.on('resize',S);}};J=e.addFunction(W);var V='<script id="cke_actscrpt" type="text/javascript" data-cke-temp="1">'+(T?'document.domain="'+document.domain+'";':'')+'window.parent.CKEDITOR.tools.callFunction( '+J+', window );'+'</script>';function W(X){if(!Q)return;Q=0;E.fire('ariaWidget',N);var Y=X.document,Z=Y.body,aa=Y.getElementById('cke_actscrpt');aa&&aa.parentNode.removeChild(aa);Z.spellcheck=!E.config.disableNativeSpellChecker;var ab=!E.readOnly;if(c){Z.hideFocus=true;Z.disabled=true;Z.contentEditable=ab;Z.removeAttribute('disabled');}else setTimeout(function(){if(b.gecko&&b.version>=10900||b.opera)Y.$.body.contentEditable=ab;else if(b.webkit)Y.$.body.parentNode.contentEditable=ab;else Y.$.designMode=ab?'off':'on';},0);ab&&b.gecko&&e.setTimeout(C,0,null,E);X=E.window=new d.window(X);Y=E.document=new g(Y);ab&&Y.on('dblclick',function(ag){var ah=ag.data.getTarget(),ai={element:ah,dialog:''};E.fire('doubleclick',ai);ai.dialog&&E.openDialog(ai.dialog);});c&&Y.on('click',function(ag){var ah=ag.data.getTarget();if(ah.is('input')){var ai=ah.getAttribute('type');if(ai=='submit'||ai=='reset')ag.data.preventDefault();}});if(!(c||b.opera))Y.on('mousedown',function(ag){var ah=ag.data.getTarget();if(ah.is('img','hr','input','textarea','select'))E.getSelection().selectElement(ah);});if(b.gecko)Y.on('mouseup',function(ag){if(ag.data.$.button==2){var ah=ag.data.getTarget();if(!ah.getOuterHtml().replace(m,'')){var ai=new d.range(Y);ai.moveToElementEditStart(ah);ai.select(true);}}});
Y.on('click',function(ag){ag=ag.data;if(ag.getTarget().is('a')&&ag.$.button!=2)ag.preventDefault();});if(b.webkit){Y.on('mousedown',function(){ad=1;});Y.on('click',function(ag){if(ag.data.getTarget().is('input','select'))ag.data.preventDefault();});Y.on('mouseup',function(ag){if(ag.data.getTarget().is('input','textarea'))ag.data.preventDefault();});}var ac=c?N:X;ac.on('blur',function(){E.focusManager.blur();});var ad;ac.on('focus',function(){var ag=E.document;if(b.gecko||b.opera)ag.getBody().focus();else if(b.webkit)if(!ad){E.document.getDocumentElement().focus();ad=1;}E.focusManager.focus();});var ae=E.keystrokeHandler;ae.blockedKeystrokes[8]=!ab;ae.attach(Y);Y.getDocumentElement().addClass(Y.$.compatMode);E.on('key',function(ag){if(E.mode!='wysiwyg')return;var ah=ag.data.keyCode;if(ah in {8:1,46:1}){var ai=E.getSelection(),aj=ai.getSelectedElement(),ak=ai.getRanges()[0],al=new d.elementPath(ak.startContainer),am,an,ao,ap=ah==8;if(aj){E.fire('saveSnapshot');ak.moveToPosition(aj,3);aj.remove();ak.select();E.fire('saveSnapshot');ag.cancel();}else if(ak.collapsed)if((am=al.block)&&ak[ap?'checkStartOfBlock':'checkEndOfBlock']()&&(ao=am[ap?'getPrevious':'getNext'](n))&&ao.is('table')){E.fire('saveSnapshot');if(ak[ap?'checkEndOfBlock':'checkStartOfBlock']())am.remove();ak['moveToElementEdit'+(ap?'End':'Start')](ao);ak.select();E.fire('saveSnapshot');ag.cancel();}else if(al.blockLimit.is('td')&&(an=al.blockLimit.getAscendant('table'))&&ak.checkBoundaryOfElement(an,ap?1:2)&&(ao=an[ap?'getPrevious':'getNext'](n))){E.fire('saveSnapshot');ak['moveToElementEdit'+(ap?'End':'Start')](ao);if(ak.checkStartOfBlock()&&ak.checkEndOfBlock())ao.remove();else ak.select();E.fire('saveSnapshot');ag.cancel();}}if(ah==33||ah==34)if(b.gecko){var aq=Y.getBody();if(X.$.innerHeight>aq.$.offsetHeight){ak=new d.range(Y);ak[ah==33?'moveToElementEditStart':'moveToElementEditEnd'](aq);ak.select();ag.cancel();}}});if(c&&Y.$.compatMode=='CSS1Compat'){var af={33:1,34:1};Y.on('keydown',function(ag){if(ag.data.getKeystroke() in af)setTimeout(function(){E.getSelection().scrollIntoView();},0);});}if(c&&E.config.enterMode!=1)Y.on('selectionchange',function(){var ag=Y.getBody(),ah=E.getSelection(),ai=ah&&ah.getRanges()[0];if(ai&&ag.getHtml().match(/^<p>&nbsp;<\/p>$/i)&&ai.startContainer.equals(ag))setTimeout(function(){ai=E.getSelection().getRanges()[0];if(!ai.startContainer.equals('body')){ag.getFirst().remove(1);ai.moveToElementEditEnd(ag);ai.select(1);}},0);});if(E.contextMenu)E.contextMenu.addTarget(Y,E.config.browserContextMenuOnCtrl!==false);
setTimeout(function(){E.fire('contentDom');if(R){E.mode='wysiwyg';E.fire('mode',{previousMode:E._.previousMode});R=false;}O=false;if(P){E.focus();P=false;}setTimeout(function(){E.fire('dataReady');},0);try{E.document.$.execCommand('2D-position',false,true);}catch(ag){}try{E.document.$.execCommand('enableInlineTableEditing',false,!E.config.disableNativeTableHandles);}catch(ah){}if(E.config.disableObjectResizing)try{E.document.$.execCommand('enableObjectResizing',false,false);}catch(ai){E.document.getBody().on(c?'resizestart':'resize',function(aj){aj.data.preventDefault();});}if(c)setTimeout(function(){if(E.document){var aj=E.document.$.body;aj.runtimeStyle.marginBottom='0px';aj.runtimeStyle.marginBottom='';}},1000);},0);};E.addMode('wysiwyg',{load:function(X,Y,Z){M=X;if(c&&b.quirks)X.setStyle('position','relative');E.mayBeDirty=true;R=true;if(Z)this.loadSnapshotData(Y);else this.loadData(Y);},loadData:function(X){O=true;E._.dataStore={id:1};var Y=E.config,Z=Y.fullPage,aa=Y.docType,ab='<style type="text/css" data-cke-temp="1">'+E._.styles.join('\n')+'</style>';!Z&&(ab=e.buildStyleHtml(E.config.contentsCss)+ab);var ac=Y.baseHref?'<base href="'+Y.baseHref+'" data-cke-temp="1" />':'';if(Z)X=X.replace(/<!DOCTYPE[^>]*>/i,function(ad){E.docType=aa=ad;return '';}).replace(/<\?xml\s[^\?]*\?>/i,function(ad){E.xmlDeclaration=ad;return '';});if(E.dataProcessor)X=E.dataProcessor.toHtml(X,F);if(Z){if(!/<body[\s|>]/.test(X))X='<body>'+X;if(!/<html[\s|>]/.test(X))X='<html>'+X+'</html>';if(!/<head[\s|>]/.test(X))X=X.replace(/<html[^>]*>/,'$&<head><title></title></head>');else if(!/<title[\s|>]/.test(X))X=X.replace(/<head[^>]*>/,'$&<title></title>');ac&&(X=X.replace(/<head>/,'$&'+ac));X=X.replace(/<\/head\s*>/,ab+'$&');X=aa+X;}else X=Y.docType+'<html dir="'+Y.contentsLangDirection+'"'+' lang="'+(Y.contentsLanguage||E.langCode)+'">'+'<head>'+'<title>'+G+'</title>'+ac+ab+'</head>'+'<body'+(Y.bodyId?' id="'+Y.bodyId+'"':'')+(Y.bodyClass?' class="'+Y.bodyClass+'"':'')+'>'+X+'</html>';if(b.gecko)X=X.replace(/<br \/>(?=\s*<\/(:?html|body)>)/,'$&<br type="_moz" />');X+=V;this.onDispose();U(X);},getData:function(){var X=E.config,Y=X.fullPage,Z=Y&&E.docType,aa=Y&&E.xmlDeclaration,ab=N.getFrameDocument(),ac=Y?ab.getDocumentElement().getOuterHtml():ab.getBody().getHtml();if(b.gecko)ac=ac.replace(/<br>(?=\s*(:?$|<\/body>))/,'');if(E.dataProcessor)ac=E.dataProcessor.toDataFormat(ac,F);if(X.ignoreEmptyParagraph)ac=ac.replace(m,function(ad,ae){return ae;});if(aa)ac=aa+'\n'+ac;if(Z)ac=Z+'\n'+ac;
return ac;},getSnapshotData:function(){return N.getFrameDocument().getBody().getHtml();},loadSnapshotData:function(X){N.getFrameDocument().getBody().setHtml(X);},onDispose:function(){if(!E.document)return;E.document.getDocumentElement().clearCustomData();E.document.getBody().clearCustomData();E.window.clearCustomData();E.document.clearCustomData();N.clearCustomData();N.remove();},unload:function(X){this.onDispose();if(S)I.removeListener('resize',S);E.window=E.document=N=M=P=null;E.fire('contentDomUnload');},focus:function(){var X=E.window;if(O)P=true;else if(X){var Y=E.getSelection(),Z=Y&&Y.getNative();if(Z&&Z.type=='Control')return;b.air?setTimeout(function(){X.focus();},0):X.focus();E.selectionChange();}}});E.on('insertHtml',r(s),null,null,20);E.on('insertElement',r(u),null,null,20);E.on('insertText',r(t),null,null,20);E.on('selectionChange',function(X){if(E.readOnly)return;var Y=E.getSelection();if(Y&&!Y.isLocked){var Z=E.checkDirty();E.fire('saveSnapshot',{contentOnly:1});D.call(this,X);E.fire('updateSnapshot');!Z&&E.resetDirty();}},null,null,1);});E.on('contentDom',function(){var M=E.document.getElementsByTag('title').getItem(0);M.data('cke-title',E.document.$.title);c&&(E.document.$.title=G);});E.on('readOnly',function(){if(E.mode=='wysiwyg'){var M=E.getMode();M.loadData(M.getData());}});if(a.document.$.documentMode>=8){E.addCss('html.CSS1Compat [contenteditable=false]{ min-height:0 !important;}');var K=[];for(var L in f.$removeEmpty)K.push('html.CSS1Compat '+L+'[contenteditable=false]');E.addCss(K.join(',')+'{ display:inline-block;}');}else if(b.gecko){E.addCss('html { height: 100% !important; }');E.addCss('img:-moz-broken { -moz-force-broken-image-icon : 1;\tmin-width : 24px; min-height : 24px; }');}E.addCss('html {\t_overflow-y: scroll; cursor: text;\t*cursor:auto;}');E.addCss('img, input, textarea { cursor: default;}');E.on('insertElement',function(M){var N=M.data;if(N.type==1&&(N.is('input')||N.is('textarea'))){var O=N.getAttribute('contenteditable')=='false';if(!O){N.data('cke-editable',N.hasAttribute('contenteditable')?'true':'1');N.setAttribute('contenteditable',false);}}});}});if(b.gecko)(function(){var E=document.body;if(!E)window.addEventListener('load',arguments.callee,false);else{var F=E.getAttribute('onpageshow');E.setAttribute('onpageshow',(F?F+';':'')+'event.persisted && (function(){'+'var allInstances = CKEDITOR.instances, editor, doc;'+'for ( var i in allInstances )'+'{'+'\teditor = allInstances[ i ];'+'\tdoc = editor.document;'+'\tif ( doc )'+'\t{'+'\t\tdoc.$.designMode = "off";'+'\t\tdoc.$.designMode = "on";'+'\t}'+'}'+'})();');
}})();})();i.disableObjectResizing=false;i.disableNativeTableHandles=true;i.disableNativeSpellChecker=true;i.ignoreEmptyParagraph=true;j.add('wsc',{requires:['dialog'],init:function(m){var n='checkspell',o=m.addCommand(n,new a.dialogCommand(n));o.modes={wysiwyg:!b.opera&&!b.air&&document.domain==window.location.hostname};m.ui.addButton('SpellChecker',{label:m.lang.spellCheck.toolbar,command:n});a.dialog.add(n,this.path+'dialogs/wsc.js');}});i.wsc_customerId=i.wsc_customerId||'1:ua3xw1-2XyGJ3-GWruD3-6OFNT1-oXcuB1-nR6Bp4-hgQHc-EcYng3-sdRXG3-NOfFk';i.wsc_customLoaderScript=i.wsc_customLoaderScript||null;a.DIALOG_RESIZE_NONE=0;a.DIALOG_RESIZE_WIDTH=1;a.DIALOG_RESIZE_HEIGHT=2;a.DIALOG_RESIZE_BOTH=3;(function(){var m=e.cssLength;function n(R){return!!this._.tabs[R][0].$.offsetHeight;};function o(){var V=this;var R=V._.currentTabId,S=V._.tabIdList.length,T=e.indexOf(V._.tabIdList,R)+S;for(var U=T-1;U>T-S;U--){if(n.call(V,V._.tabIdList[U%S]))return V._.tabIdList[U%S];}return null;};function p(){var V=this;var R=V._.currentTabId,S=V._.tabIdList.length,T=e.indexOf(V._.tabIdList,R);for(var U=T+1;U<T+S;U++){if(n.call(V,V._.tabIdList[U%S]))return V._.tabIdList[U%S];}return null;};function q(R,S){var T=R.$.getElementsByTagName('input');for(var U=0,V=T.length;U<V;U++){var W=new h(T[U]);if(W.getAttribute('type').toLowerCase()=='text')if(S){W.setAttribute('value',W.getCustomData('fake_value')||'');W.removeCustomData('fake_value');}else{W.setCustomData('fake_value',W.getAttribute('value'));W.setAttribute('value','');}}};function r(R,S){var U=this;var T=U.getInputElement();if(T)R?T.removeAttribute('aria-invalid'):T.setAttribute('aria-invalid',true);if(!R)if(U.select)U.select();else U.focus();S&&alert(S);U.fire('validated',{valid:R,msg:S});};function s(){var R=this.getInputElement();R&&R.removeAttribute('aria-invalid');};a.dialog=function(R,S){var T=a.dialog._.dialogDefinitions[S],U=e.clone(v),V=R.config.dialog_buttonsOrder||'OS',W=R.lang.dir,X={},Y,Z,aa;if(V=='OS'&&b.mac||V=='rtl'&&W=='ltr'||V=='ltr'&&W=='rtl')U.buttons.reverse();T=e.extend(T(R),U);T=e.clone(T);T=new z(this,T);var ab=a.document,ac=R.theme.buildDialog(R);this._={editor:R,element:ac.element,name:S,contentSize:{width:0,height:0},size:{width:0,height:0},contents:{},buttons:{},accessKeyMap:{},tabs:{},tabIdList:[],currentTabId:null,currentTabIndex:null,pageCount:0,lastTab:null,tabBarMode:false,focusList:[],currentFocusIndex:0,hasFocus:false};this.parts=ac.parts;e.setTimeout(function(){R.fire('ariaWidget',this.parts.contents);
},0,this);var ad={position:b.ie6Compat?'absolute':'fixed',top:0,visibility:'hidden'};ad[W=='rtl'?'right':'left']=0;this.parts.dialog.setStyles(ad);a.event.call(this);this.definition=T=a.fire('dialogDefinition',{name:S,definition:T},R).definition;if(!('removeDialogTabs' in R._)&&R.config.removeDialogTabs){var ae=R.config.removeDialogTabs.split(';');for(Y=0;Y<ae.length;Y++){var af=ae[Y].split(':');if(af.length==2){var ag=af[0];if(!X[ag])X[ag]=[];X[ag].push(af[1]);}}R._.removeDialogTabs=X;}if(R._.removeDialogTabs&&(X=R._.removeDialogTabs[S]))for(Y=0;Y<X.length;Y++)T.removeContents(X[Y]);if(T.onLoad)this.on('load',T.onLoad);if(T.onShow)this.on('show',T.onShow);if(T.onHide)this.on('hide',T.onHide);if(T.onOk)this.on('ok',function(ar){R.fire('saveSnapshot');setTimeout(function(){R.fire('saveSnapshot');},0);if(T.onOk.call(this,ar)===false)ar.data.hide=false;});if(T.onCancel)this.on('cancel',function(ar){if(T.onCancel.call(this,ar)===false)ar.data.hide=false;});var ah=this,ai=function(ar){var as=ah._.contents,at=false;for(var au in as)for(var av in as[au]){at=ar.call(this,as[au][av]);if(at)return;}};this.on('ok',function(ar){ai(function(as){if(as.validate){var at=as.validate(this),au=typeof at=='string'||at===false;if(au){ar.data.hide=false;ar.stop();}r.call(as,!au,typeof at=='string'?at:undefined);return au;}});},this,null,0);this.on('cancel',function(ar){ai(function(as){if(as.isChanged()){if(!confirm(R.lang.common.confirmCancel))ar.data.hide=false;return true;}});},this,null,0);this.parts.close.on('click',function(ar){if(this.fire('cancel',{hide:true}).hide!==false)this.hide();ar.data.preventDefault();},this);function aj(){var ar=ah._.focusList;ar.sort(function(au,av){if(au.tabIndex!=av.tabIndex)return av.tabIndex-au.tabIndex;else return au.focusIndex-av.focusIndex;});var as=ar.length;for(var at=0;at<as;at++)ar[at].focusIndex=at;};function ak(ar){var as=ah._.focusList;ar=ar||0;if(as.length<1)return;var at=ah._.currentFocusIndex;try{as[at].getInputElement().$.blur();}catch(aw){}var au=(at+ar+as.length)%as.length,av=au;while(ar&&!as[av].isFocusable()){av=(av+ar+as.length)%as.length;if(av==au)break;}as[av].focus();if(as[av].type=='text')as[av].select();};this.changeFocus=ak;function al(ar){var ay=this;if(ah!=a.dialog._.currentTop)return;var as=ar.data.getKeystroke(),at=R.lang.dir=='rtl',au;Z=aa=0;if(as==9||as==2228224+9){var av=as==2228224+9;if(ah._.tabBarMode){var aw=av?o.call(ah):p.call(ah);ah.selectPage(aw);ah._.tabs[aw][0].focus();}else ak(av?-1:1);Z=1;}else if(as==4456448+121&&!ah._.tabBarMode&&ah.getPageCount()>1){ah._.tabBarMode=true;
ah._.tabs[ah._.currentTabId][0].focus();Z=1;}else if((as==37||as==39)&&ah._.tabBarMode){aw=as==(at?39:37)?o.call(ah):p.call(ah);ah.selectPage(aw);ah._.tabs[aw][0].focus();Z=1;}else if((as==13||as==32)&&ah._.tabBarMode){ay.selectPage(ay._.currentTabId);ay._.tabBarMode=false;ay._.currentFocusIndex=-1;ak(1);Z=1;}else if(as==13){var ax=ar.data.getTarget();if(!ax.is('a','button','select','textarea')&&(!ax.is('input')||ax.$.type!='button')){au=ay.getButton('ok');au&&e.setTimeout(au.click,0,au);Z=1;}aa=1;}else if(as==27){au=ay.getButton('cancel');if(au)e.setTimeout(au.click,0,au);else if(ay.fire('cancel',{hide:true}).hide!==false)ay.hide();aa=1;}else return;am(ar);};function am(ar){if(Z)ar.data.preventDefault(1);else if(aa)ar.data.stopPropagation();};var an=this._.element;this.on('show',function(){an.on('keydown',al,this);if(b.opera||b.gecko)an.on('keypress',am,this);});this.on('hide',function(){an.removeListener('keydown',al);if(b.opera||b.gecko)an.removeListener('keypress',am);ai(function(ar){s.apply(ar);});});this.on('iframeAdded',function(ar){var as=new g(ar.data.iframe.$.contentWindow.document);as.on('keydown',al,this,null,0);});this.on('show',function(){var av=this;aj();if(R.config.dialog_startupFocusTab&&ah._.pageCount>1){ah._.tabBarMode=true;ah._.tabs[ah._.currentTabId][0].focus();}else if(!av._.hasFocus){av._.currentFocusIndex=-1;if(T.onFocus){var ar=T.onFocus.call(av);ar&&ar.focus();}else ak(1);if(av._.editor.mode=='wysiwyg'&&c){var as=R.document.$.selection,at=as.createRange();if(at)if(at.parentElement&&at.parentElement().ownerDocument==R.document.$||at.item&&at.item(0).ownerDocument==R.document.$){var au=document.body.createTextRange();au.moveToElementText(av.getElement().getFirst().$);au.collapse(true);au.select();}}}},this,null,4294967295);if(b.ie6Compat)this.on('load',function(ar){var as=this.getElement(),at=as.getFirst();at.remove();at.appendTo(as);},this);B(this);C(this);new d.text(T.title,a.document).appendTo(this.parts.title);for(Y=0;Y<T.contents.length;Y++){var ao=T.contents[Y];ao&&this.addPage(ao);}this.parts.tabs.on('click',function(ar){var au=this;var as=ar.data.getTarget();if(as.hasClass('cke_dialog_tab')){var at=as.$.id;au.selectPage(at.substring(4,at.lastIndexOf('_')));if(au._.tabBarMode){au._.tabBarMode=false;au._.currentFocusIndex=-1;ak(1);}ar.data.preventDefault();}},this);var ap=[],aq=a.dialog._.uiElementBuilders.hbox.build(this,{type:'hbox',className:'cke_dialog_footer_buttons',widths:[],children:T.buttons},ap).getChild();this.parts.footer.setHtml(ap.join(''));
for(Y=0;Y<aq.length;Y++)this._.buttons[aq[Y].id]=aq[Y];};function t(R,S,T){this.element=S;this.focusIndex=T;this.tabIndex=0;this.isFocusable=function(){return!S.getAttribute('disabled')&&S.isVisible();};this.focus=function(){R._.currentFocusIndex=this.focusIndex;this.element.focus();};S.on('keydown',function(U){if(U.data.getKeystroke() in {32:1,13:1})this.fire('click');});S.on('focus',function(){this.fire('mouseover');});S.on('blur',function(){this.fire('mouseout');});};function u(R){var S=a.document.getWindow();function T(){R.layout();};S.on('resize',T);R.on('hide',function(){S.removeListener('resize',T);});};a.dialog.prototype={destroy:function(){this.hide();this._.element.remove();},resize:(function(){return function(R,S){var T=this;if(T._.contentSize&&T._.contentSize.width==R&&T._.contentSize.height==S)return;a.dialog.fire('resize',{dialog:T,skin:T._.editor.skinName,width:R,height:S},T._.editor);T.fire('resize',{skin:T._.editor.skinName,width:R,height:S},T._.editor);if(T._.editor.lang.dir=='rtl'&&T._.position)T._.position.x=a.document.getWindow().getViewPaneSize().width-T._.contentSize.width-parseInt(T._.element.getFirst().getStyle('right'),10);T._.contentSize={width:R,height:S};};})(),getSize:function(){var R=this._.element.getFirst();return{width:R.$.offsetWidth||0,height:R.$.offsetHeight||0};},move:function(R,S,T){var ab=this;var U=ab._.element.getFirst(),V=ab._.editor.lang.dir=='rtl',W=U.getComputedStyle('position')=='fixed';if(W&&ab._.position&&ab._.position.x==R&&ab._.position.y==S)return;ab._.position={x:R,y:S};if(!W){var X=a.document.getWindow().getScrollPosition();R+=X.x;S+=X.y;}if(V){var Y=ab.getSize(),Z=a.document.getWindow().getViewPaneSize();R=Z.width-Y.width-R;}var aa={top:(S>0?S:0)+'px'};aa[V?'right':'left']=(R>0?R:0)+'px';U.setStyles(aa);T&&(ab._.moved=1);},getPosition:function(){return e.extend({},this._.position);},show:function(){var R=this._.element,S=this.definition;if(!(R.getParent()&&R.getParent().equals(a.document.getBody())))R.appendTo(a.document.getBody());else R.setStyle('display','block');if(b.gecko&&b.version<10900){var T=this.parts.dialog;T.setStyle('position','absolute');setTimeout(function(){T.setStyle('position','fixed');},0);}this.resize(this._.contentSize&&this._.contentSize.width||S.width||S.minWidth,this._.contentSize&&this._.contentSize.height||S.height||S.minHeight);this.reset();this.selectPage(this.definition.contents[0].id);if(a.dialog._.currentZIndex===null)a.dialog._.currentZIndex=this._.editor.config.baseFloatZIndex;
this._.element.getFirst().setStyle('z-index',a.dialog._.currentZIndex+=10);if(a.dialog._.currentTop===null){a.dialog._.currentTop=this;this._.parentDialog=null;H(this._.editor);}else{this._.parentDialog=a.dialog._.currentTop;var U=this._.parentDialog.getElement().getFirst();U.$.style.zIndex-=Math.floor(this._.editor.config.baseFloatZIndex/2);a.dialog._.currentTop=this;}R.on('keydown',L);R.on(b.opera?'keypress':'keyup',M);this._.hasFocus=false;e.setTimeout(function(){this.layout();u(this);this.parts.dialog.setStyle('visibility','');this.fireOnce('load',{});k.fire('ready',this);this.fire('show',{});this._.editor.fire('dialogShow',this);this.foreach(function(V){V.setInitValue&&V.setInitValue();});},100,this);},layout:function(){var X=this;var R=X.parts.dialog,S=X.getSize(),T=a.document.getWindow(),U=T.getViewPaneSize(),V=(U.width-S.width)/2,W=(U.height-S.height)/2;if(!b.ie6Compat)if(S.height+(W>0?W:0)>U.height||S.width+(V>0?V:0)>U.width)R.setStyle('position','absolute');else R.setStyle('position','fixed');X.move(X._.moved?X._.position.x:V,X._.moved?X._.position.y:W);},foreach:function(R){var U=this;for(var S in U._.contents)for(var T in U._.contents[S])R.call(U,U._.contents[S][T]);return U;},reset:(function(){var R=function(S){if(S.reset)S.reset(1);};return function(){this.foreach(R);return this;};})(),setupContent:function(){var R=arguments;this.foreach(function(S){if(S.setup)S.setup.apply(S,R);});},commitContent:function(){var R=arguments;this.foreach(function(S){if(c&&this._.currentFocusIndex==S.focusIndex)S.getInputElement().$.blur();if(S.commit)S.commit.apply(S,R);});},hide:function(){if(!this.parts.dialog.isVisible())return;this.fire('hide',{});this._.editor.fire('dialogHide',this);this.selectPage(this._.tabIdList[0]);var R=this._.element;R.setStyle('display','none');this.parts.dialog.setStyle('visibility','hidden');O(this);while(a.dialog._.currentTop!=this)a.dialog._.currentTop.hide();if(!this._.parentDialog)I();else{var S=this._.parentDialog.getElement().getFirst();S.setStyle('z-index',parseInt(S.$.style.zIndex,10)+Math.floor(this._.editor.config.baseFloatZIndex/2));}a.dialog._.currentTop=this._.parentDialog;if(!this._.parentDialog){a.dialog._.currentZIndex=null;R.removeListener('keydown',L);R.removeListener(b.opera?'keypress':'keyup',M);var T=this._.editor;T.focus();if(T.mode=='wysiwyg'&&c){var U=T.getSelection();U&&U.unlock(true);}}else a.dialog._.currentZIndex-=10;delete this._.parentDialog;this.foreach(function(V){V.resetInitValue&&V.resetInitValue();
});},addPage:function(R){var ad=this;var S=[],T=R.label?' title="'+e.htmlEncode(R.label)+'"':'',U=R.elements,V=a.dialog._.uiElementBuilders.vbox.build(ad,{type:'vbox',className:'cke_dialog_page_contents',children:R.elements,expand:!!R.expand,padding:R.padding,style:R.style||'width: 100%;height:100%'},S),W=h.createFromHtml(S.join(''));W.setAttribute('role','tabpanel');var X=b,Y='cke_'+R.id+'_'+e.getNextNumber(),Z=h.createFromHtml(['<a class="cke_dialog_tab"',ad._.pageCount>0?' cke_last':'cke_first',T,!!R.hidden?' style="display:none"':'',' id="',Y,'"',X.gecko&&X.version>=10900&&!X.hc?'':' href="javascript:void(0)"',' tabIndex="-1"',' hidefocus="true"',' role="tab">',R.label,'</a>'].join(''));W.setAttribute('aria-labelledby',Y);ad._.tabs[R.id]=[Z,W];ad._.tabIdList.push(R.id);!R.hidden&&ad._.pageCount++;ad._.lastTab=Z;ad.updateStyle();var aa=ad._.contents[R.id]={},ab,ac=V.getChild();while(ab=ac.shift()){aa[ab.id]=ab;if(typeof ab.getChild=='function')ac.push.apply(ac,ab.getChild());}W.setAttribute('name',R.id);W.appendTo(ad.parts.contents);Z.unselectable();ad.parts.tabs.append(Z);if(R.accessKey){N(ad,ad,'CTRL+'+R.accessKey,Q,P);ad._.accessKeyMap['CTRL+'+R.accessKey]=R.id;}},selectPage:function(R){if(this._.currentTabId==R)return;if(this.fire('selectPage',{page:R,currentPage:this._.currentTabId})===true)return;for(var S in this._.tabs){var T=this._.tabs[S][0],U=this._.tabs[S][1];if(S!=R){T.removeClass('cke_dialog_tab_selected');U.hide();}U.setAttribute('aria-hidden',S!=R);}var V=this._.tabs[R];V[0].addClass('cke_dialog_tab_selected');if(b.ie6Compat||b.ie7Compat){q(V[1]);V[1].show();setTimeout(function(){q(V[1],1);},0);}else V[1].show();this._.currentTabId=R;this._.currentTabIndex=e.indexOf(this._.tabIdList,R);},updateStyle:function(){this.parts.dialog[(this._.pageCount===1?'add':'remove')+'Class']('cke_single_page');},hidePage:function(R){var T=this;var S=T._.tabs[R]&&T._.tabs[R][0];if(!S||T._.pageCount==1||!S.isVisible())return;else if(R==T._.currentTabId)T.selectPage(o.call(T));S.hide();T._.pageCount--;T.updateStyle();},showPage:function(R){var T=this;var S=T._.tabs[R]&&T._.tabs[R][0];if(!S)return;S.show();T._.pageCount++;T.updateStyle();},getElement:function(){return this._.element;},getName:function(){return this._.name;},getContentElement:function(R,S){var T=this._.contents[R];return T&&T[S];},getValueOf:function(R,S){return this.getContentElement(R,S).getValue();},setValueOf:function(R,S,T){return this.getContentElement(R,S).setValue(T);},getButton:function(R){return this._.buttons[R];
},click:function(R){return this._.buttons[R].click();},disableButton:function(R){return this._.buttons[R].disable();},enableButton:function(R){return this._.buttons[R].enable();},getPageCount:function(){return this._.pageCount;},getParentEditor:function(){return this._.editor;},getSelectedElement:function(){return this.getParentEditor().getSelection().getSelectedElement();},addFocusable:function(R,S){var U=this;if(typeof S=='undefined'){S=U._.focusList.length;U._.focusList.push(new t(U,R,S));}else{U._.focusList.splice(S,0,new t(U,R,S));for(var T=S+1;T<U._.focusList.length;T++)U._.focusList[T].focusIndex++;}}};e.extend(a.dialog,{add:function(R,S){if(!this._.dialogDefinitions[R]||typeof S=='function')this._.dialogDefinitions[R]=S;},exists:function(R){return!!this._.dialogDefinitions[R];},getCurrent:function(){return a.dialog._.currentTop;},okButton:(function(){var R=function(S,T){T=T||{};return e.extend({id:'ok',type:'button',label:S.lang.common.ok,'class':'cke_dialog_ui_button_ok',onClick:function(U){var V=U.data.dialog;if(V.fire('ok',{hide:true}).hide!==false)V.hide();}},T,true);};R.type='button';R.override=function(S){return e.extend(function(T){return R(T,S);},{type:'button'},true);};return R;})(),cancelButton:(function(){var R=function(S,T){T=T||{};return e.extend({id:'cancel',type:'button',label:S.lang.common.cancel,'class':'cke_dialog_ui_button_cancel',onClick:function(U){var V=U.data.dialog;if(V.fire('cancel',{hide:true}).hide!==false)V.hide();}},T,true);};R.type='button';R.override=function(S){return e.extend(function(T){return R(T,S);},{type:'button'},true);};return R;})(),addUIElement:function(R,S){this._.uiElementBuilders[R]=S;}});a.dialog._={uiElementBuilders:{},dialogDefinitions:{},currentTop:null,currentZIndex:null};a.event.implementOn(a.dialog);a.event.implementOn(a.dialog.prototype,true);var v={resizable:3,minWidth:600,minHeight:400,buttons:[a.dialog.okButton,a.dialog.cancelButton]},w=function(R,S,T){for(var U=0,V;V=R[U];U++){if(V.id==S)return V;if(T&&V[T]){var W=w(V[T],S,T);if(W)return W;}}return null;},x=function(R,S,T,U,V){if(T){for(var W=0,X;X=R[W];W++){if(X.id==T){R.splice(W,0,S);return S;}if(U&&X[U]){var Y=x(X[U],S,T,U,true);if(Y)return Y;}}if(V)return null;}R.push(S);return S;},y=function(R,S,T){for(var U=0,V;V=R[U];U++){if(V.id==S)return R.splice(U,1);if(T&&V[T]){var W=y(V[T],S,T);if(W)return W;}}return null;},z=function(R,S){this.dialog=R;var T=S.contents;for(var U=0,V;V=T[U];U++)T[U]=V&&new A(R,V);e.extend(this,S);};z.prototype={getContents:function(R){return w(this.contents,R);
},getButton:function(R){return w(this.buttons,R);},addContents:function(R,S){return x(this.contents,R,S);},addButton:function(R,S){return x(this.buttons,R,S);},removeContents:function(R){y(this.contents,R);},removeButton:function(R){y(this.buttons,R);}};function A(R,S){this._={dialog:R};e.extend(this,S);};A.prototype={get:function(R){return w(this.elements,R,'children');},add:function(R,S){return x(this.elements,R,S,'children');},remove:function(R){y(this.elements,R,'children');}};function B(R){var S=null,T=null,U=R.getElement().getFirst(),V=R.getParentEditor(),W=V.config.dialog_magnetDistance,X=V.skin.margins||[0,0,0,0];if(typeof W=='undefined')W=20;function Y(aa){var ab=R.getSize(),ac=a.document.getWindow().getViewPaneSize(),ad=aa.data.$.screenX,ae=aa.data.$.screenY,af=ad-S.x,ag=ae-S.y,ah,ai;S={x:ad,y:ae};T.x+=af;T.y+=ag;if(T.x+X[3]<W)ah=-X[3];else if(T.x-X[1]>ac.width-ab.width-W)ah=ac.width-ab.width+(V.lang.dir=='rtl'?0:X[1]);else ah=T.x;if(T.y+X[0]<W)ai=-X[0];else if(T.y-X[2]>ac.height-ab.height-W)ai=ac.height-ab.height+X[2];else ai=T.y;R.move(ah,ai,1);aa.data.preventDefault();};function Z(aa){a.document.removeListener('mousemove',Y);a.document.removeListener('mouseup',Z);if(b.ie6Compat){var ab=F.getChild(0).getFrameDocument();ab.removeListener('mousemove',Y);ab.removeListener('mouseup',Z);}};R.parts.title.on('mousedown',function(aa){S={x:aa.data.$.screenX,y:aa.data.$.screenY};a.document.on('mousemove',Y);a.document.on('mouseup',Z);T=R.getPosition();if(b.ie6Compat){var ab=F.getChild(0).getFrameDocument();ab.on('mousemove',Y);ab.on('mouseup',Z);}aa.data.preventDefault();},R);};function C(R){var S=R.definition,T=S.resizable;if(T==0)return;var U=R.getParentEditor(),V,W,X,Y,Z,aa,ab=e.addFunction(function(ae){Z=R.getSize();var af=R.parts.contents,ag=af.$.getElementsByTagName('iframe').length;if(ag){aa=h.createFromHtml('<div class="cke_dialog_resize_cover" style="height: 100%; position: absolute; width: 100%;"></div>');af.append(aa);}W=Z.height-R.parts.contents.getSize('height',!(b.gecko||b.opera||c&&b.quirks));V=Z.width-R.parts.contents.getSize('width',1);Y={x:ae.screenX,y:ae.screenY};X=a.document.getWindow().getViewPaneSize();a.document.on('mousemove',ac);a.document.on('mouseup',ad);if(b.ie6Compat){var ah=F.getChild(0).getFrameDocument();ah.on('mousemove',ac);ah.on('mouseup',ad);}ae.preventDefault&&ae.preventDefault();});R.on('load',function(){var ae='';if(T==1)ae=' cke_resizer_horizontal';else if(T==2)ae=' cke_resizer_vertical';var af=h.createFromHtml('<div class="cke_resizer'+ae+' cke_resizer_'+U.lang.dir+'"'+' title="'+e.htmlEncode(U.lang.resize)+'"'+' onmousedown="CKEDITOR.tools.callFunction('+ab+', event )"></div>');
R.parts.footer.append(af,1);});U.on('destroy',function(){e.removeFunction(ab);});function ac(ae){var af=U.lang.dir=='rtl',ag=(ae.data.$.screenX-Y.x)*(af?-1:1),ah=ae.data.$.screenY-Y.y,ai=Z.width,aj=Z.height,ak=ai+ag*(R._.moved?1:2),al=aj+ah*(R._.moved?1:2),am=R._.element.getFirst(),an=af&&am.getComputedStyle('right'),ao=R.getPosition();if(ao.y+al>X.height)al=X.height-ao.y;if((af?an:ao.x)+ak>X.width)ak=X.width-(af?an:ao.x);if(T==1||T==3)ai=Math.max(S.minWidth||0,ak-V);if(T==2||T==3)aj=Math.max(S.minHeight||0,al-W);R.resize(ai,aj);if(!R._.moved)R.layout();ae.data.preventDefault();};function ad(){a.document.removeListener('mouseup',ad);a.document.removeListener('mousemove',ac);if(aa){aa.remove();aa=null;}if(b.ie6Compat){var ae=F.getChild(0).getFrameDocument();ae.removeListener('mouseup',ad);ae.removeListener('mousemove',ac);}};};var D,E={},F;function G(R){R.data.preventDefault(1);};function H(R){var S=a.document.getWindow(),T=R.config,U=T.dialog_backgroundCoverColor||'white',V=T.dialog_backgroundCoverOpacity,W=T.baseFloatZIndex,X=e.genKey(U,V,W),Y=E[X];if(!Y){var Z=['<div tabIndex="-1" style="position: ',b.ie6Compat?'absolute':'fixed','; z-index: ',W,'; top: 0px; left: 0px; ',!b.ie6Compat?'background-color: '+U:'','" class="cke_dialog_background_cover">'];if(b.ie6Compat){var aa=b.isCustomDomain(),ab="<html><body style=\\'background-color:"+U+";\\'></body></html>";Z.push('<iframe hidefocus="true" frameborder="0" id="cke_dialog_background_iframe" src="javascript:');Z.push('void((function(){document.open();'+(aa?"document.domain='"+document.domain+"';":'')+"document.write( '"+ab+"' );"+'document.close();'+'})())');Z.push('" style="position:absolute;left:0;top:0;width:100%;height: 100%;progid:DXImageTransform.Microsoft.Alpha(opacity=0)"></iframe>');}Z.push('</div>');Y=h.createFromHtml(Z.join(''));Y.setOpacity(V!=undefined?V:0.5);Y.on('keydown',G);Y.on('keypress',G);Y.on('keyup',G);Y.appendTo(a.document.getBody());E[X]=Y;}else Y.show();F=Y;var ac=function(){var af=S.getViewPaneSize();Y.setStyles({width:af.width+'px',height:af.height+'px'});},ad=function(){var af=S.getScrollPosition(),ag=a.dialog._.currentTop;Y.setStyles({left:af.x+'px',top:af.y+'px'});if(ag)do{var ah=ag.getPosition();ag.move(ah.x,ah.y);}while(ag=ag._.parentDialog)};D=ac;S.on('resize',ac);ac();if(!(b.mac&&b.webkit))Y.focus();if(b.ie6Compat){var ae=function(){ad();arguments.callee.prevScrollHandler.apply(this,arguments);};S.$.setTimeout(function(){ae.prevScrollHandler=window.onscroll||(function(){});
window.onscroll=ae;},0);ad();}};function I(){if(!F)return;var R=a.document.getWindow();F.hide();R.removeListener('resize',D);if(b.ie6Compat)R.$.setTimeout(function(){var S=window.onscroll&&window.onscroll.prevScrollHandler;window.onscroll=S||null;},0);D=null;};function J(){for(var R in E)E[R].remove();E={};};var K={},L=function(R){var S=R.data.$.ctrlKey||R.data.$.metaKey,T=R.data.$.altKey,U=R.data.$.shiftKey,V=String.fromCharCode(R.data.$.keyCode),W=K[(S?'CTRL+':'')+(T?'ALT+':'')+(U?'SHIFT+':'')+V];if(!W||!W.length)return;W=W[W.length-1];W.keydown&&W.keydown.call(W.uiElement,W.dialog,W.key);R.data.preventDefault();},M=function(R){var S=R.data.$.ctrlKey||R.data.$.metaKey,T=R.data.$.altKey,U=R.data.$.shiftKey,V=String.fromCharCode(R.data.$.keyCode),W=K[(S?'CTRL+':'')+(T?'ALT+':'')+(U?'SHIFT+':'')+V];if(!W||!W.length)return;W=W[W.length-1];if(W.keyup){W.keyup.call(W.uiElement,W.dialog,W.key);R.data.preventDefault();}},N=function(R,S,T,U,V){var W=K[T]||(K[T]=[]);W.push({uiElement:R,dialog:S,key:T,keyup:V||R.accessKeyUp,keydown:U||R.accessKeyDown});},O=function(R){for(var S in K){var T=K[S];for(var U=T.length-1;U>=0;U--){if(T[U].dialog==R||T[U].uiElement==R)T.splice(U,1);}if(T.length===0)delete K[S];}},P=function(R,S){if(R._.accessKeyMap[S])R.selectPage(R._.accessKeyMap[S]);},Q=function(R,S){};(function(){k.dialog={uiElement:function(R,S,T,U,V,W,X){if(arguments.length<4)return;var Y=(U.call?U(S):U)||'div',Z=['<',Y,' '],aa=(V&&V.call?V(S):V)||{},ab=(W&&W.call?W(S):W)||{},ac=(X&&X.call?X.call(this,R,S):X)||'',ad=this.domId=ab.id||e.getNextId()+'_uiElement',ae=this.id=S.id,af;ab.id=ad;var ag={};if(S.type)ag['cke_dialog_ui_'+S.type]=1;if(S.className)ag[S.className]=1;if(S.disabled)ag.cke_disabled=1;var ah=ab['class']&&ab['class'].split?ab['class'].split(' '):[];for(af=0;af<ah.length;af++){if(ah[af])ag[ah[af]]=1;}var ai=[];for(af in ag)ai.push(af);ab['class']=ai.join(' ');if(S.title)ab.title=S.title;var aj=(S.style||'').split(';');if(S.align){var ak=S.align;aa['margin-left']=ak=='left'?0:'auto';aa['margin-right']=ak=='right'?0:'auto';}for(af in aa)aj.push(af+':'+aa[af]);if(S.hidden)aj.push('display:none');for(af=aj.length-1;af>=0;af--){if(aj[af]==='')aj.splice(af,1);}if(aj.length>0)ab.style=(ab.style?ab.style+'; ':'')+aj.join('; ');for(af in ab)Z.push(af+'="'+e.htmlEncode(ab[af])+'" ');Z.push('>',ac,'</',Y,'>');T.push(Z.join(''));(this._||(this._={})).dialog=R;if(typeof S.isChanged=='boolean')this.isChanged=function(){return S.isChanged;};if(typeof S.isChanged=='function')this.isChanged=S.isChanged;
if(typeof S.setValue=='function')this.setValue=e.override(this.setValue,function(am){return function(an){am.call(this,S.setValue.call(this,an));};});if(typeof S.getValue=='function')this.getValue=e.override(this.getValue,function(am){return function(){return S.getValue.call(this,am.call(this));};});a.event.implementOn(this);this.registerEvents(S);if(this.accessKeyUp&&this.accessKeyDown&&S.accessKey)N(this,R,'CTRL+'+S.accessKey);var al=this;R.on('load',function(){var am=al.getInputElement();if(am){var an=al.type in {checkbox:1,ratio:1}&&c&&b.version<8?'cke_dialog_ui_focused':'';am.on('focus',function(){R._.tabBarMode=false;R._.hasFocus=true;al.fire('focus');an&&this.addClass(an);});am.on('blur',function(){al.fire('blur');an&&this.removeClass(an);});}});if(this.keyboardFocusable){this.tabIndex=S.tabIndex||0;this.focusIndex=R._.focusList.push(this)-1;this.on('focus',function(){R._.currentFocusIndex=al.focusIndex;});}e.extend(this,S);},hbox:function(R,S,T,U,V){if(arguments.length<4)return;this._||(this._={});var W=this._.children=S,X=V&&V.widths||null,Y=V&&V.height||null,Z={},aa,ab=function(){var ad=['<tbody><tr class="cke_dialog_ui_hbox">'];for(aa=0;aa<T.length;aa++){var ae='cke_dialog_ui_hbox_child',af=[];if(aa===0)ae='cke_dialog_ui_hbox_first';if(aa==T.length-1)ae='cke_dialog_ui_hbox_last';ad.push('<td class="',ae,'" role="presentation" ');if(X){if(X[aa])af.push('width:'+m(X[aa]));}else af.push('width:'+Math.floor(100/T.length)+'%');if(Y)af.push('height:'+m(Y));if(V&&V.padding!=undefined)af.push('padding:'+m(V.padding));if(c&&b.quirks&&W[aa].align)af.push('text-align:'+W[aa].align);if(af.length>0)ad.push('style="'+af.join('; ')+'" ');ad.push('>',T[aa],'</td>');}ad.push('</tr></tbody>');return ad.join('');},ac={role:'presentation'};V&&V.align&&(ac.align=V.align);k.dialog.uiElement.call(this,R,V||{type:'hbox'},U,'table',Z,ac,ab);},vbox:function(R,S,T,U,V){if(arguments.length<3)return;this._||(this._={});var W=this._.children=S,X=V&&V.width||null,Y=V&&V.heights||null,Z=function(){var aa=['<table role="presentation" cellspacing="0" border="0" '];aa.push('style="');if(V&&V.expand)aa.push('height:100%;');aa.push('width:'+m(X||'100%'),';');aa.push('"');aa.push('align="',e.htmlEncode(V&&V.align||(R.getParentEditor().lang.dir=='ltr'?'left':'right')),'" ');aa.push('><tbody>');for(var ab=0;ab<T.length;ab++){var ac=[];aa.push('<tr><td role="presentation" ');if(X)ac.push('width:'+m(X||'100%'));if(Y)ac.push('height:'+m(Y[ab]));else if(V&&V.expand)ac.push('height:'+Math.floor(100/T.length)+'%');
if(V&&V.padding!=undefined)ac.push('padding:'+m(V.padding));if(c&&b.quirks&&W[ab].align)ac.push('text-align:'+W[ab].align);if(ac.length>0)aa.push('style="',ac.join('; '),'" ');aa.push(' class="cke_dialog_ui_vbox_child">',T[ab],'</td></tr>');}aa.push('</tbody></table>');return aa.join('');};k.dialog.uiElement.call(this,R,V||{type:'vbox'},U,'div',null,{role:'presentation'},Z);}};})();k.dialog.uiElement.prototype={getElement:function(){return a.document.getById(this.domId);},getInputElement:function(){return this.getElement();},getDialog:function(){return this._.dialog;},setValue:function(R,S){this.getInputElement().setValue(R);!S&&this.fire('change',{value:R});return this;},getValue:function(){return this.getInputElement().getValue();},isChanged:function(){return false;},selectParentTab:function(){var U=this;var R=U.getInputElement(),S=R,T;while((S=S.getParent())&&S.$.className.search('cke_dialog_page_contents')==-1){}if(!S)return U;T=S.getAttribute('name');if(U._.dialog._.currentTabId!=T)U._.dialog.selectPage(T);return U;},focus:function(){this.selectParentTab().getInputElement().focus();return this;},registerEvents:function(R){var S=/^on([A-Z]\w+)/,T,U=function(W,X,Y,Z){X.on('load',function(){W.getInputElement().on(Y,Z,W);});};for(var V in R){if(!(T=V.match(S)))continue;if(this.eventProcessors[V])this.eventProcessors[V].call(this,this._.dialog,R[V]);else U(this,this._.dialog,T[1].toLowerCase(),R[V]);}return this;},eventProcessors:{onLoad:function(R,S){R.on('load',S,this);},onShow:function(R,S){R.on('show',S,this);},onHide:function(R,S){R.on('hide',S,this);}},accessKeyDown:function(R,S){this.focus();},accessKeyUp:function(R,S){},disable:function(){var R=this.getElement(),S=this.getInputElement();S.setAttribute('disabled','true');R.addClass('cke_disabled');},enable:function(){var R=this.getElement(),S=this.getInputElement();S.removeAttribute('disabled');R.removeClass('cke_disabled');},isEnabled:function(){return!this.getElement().hasClass('cke_disabled');},isVisible:function(){return this.getInputElement().isVisible();},isFocusable:function(){if(!this.isEnabled()||!this.isVisible())return false;return true;}};k.dialog.hbox.prototype=e.extend(new k.dialog.uiElement(),{getChild:function(R){var S=this;if(arguments.length<1)return S._.children.concat();if(!R.splice)R=[R];if(R.length<2)return S._.children[R[0]];else return S._.children[R[0]]&&S._.children[R[0]].getChild?S._.children[R[0]].getChild(R.slice(1,R.length)):null;}},true);k.dialog.vbox.prototype=new k.dialog.hbox();
(function(){var R={build:function(S,T,U){var V=T.children,W,X=[],Y=[];for(var Z=0;Z<V.length&&(W=V[Z]);Z++){var aa=[];X.push(aa);Y.push(a.dialog._.uiElementBuilders[W.type].build(S,W,aa));}return new k.dialog[T.type](S,Y,X,U,T);}};a.dialog.addUIElement('hbox',R);a.dialog.addUIElement('vbox',R);})();a.dialogCommand=function(R){this.dialogName=R;};a.dialogCommand.prototype={exec:function(R){b.opera?e.setTimeout(function(){R.openDialog(this.dialogName);},0,this):R.openDialog(this.dialogName);},canUndo:false,editorFocus:c||b.webkit};(function(){var R=/^([a]|[^a])+$/,S=/^\d*$/,T=/^\d*(?:\.\d+)?$/,U=/^(((\d*(\.\d+))|(\d*))(px|\%)?)?$/,V=/^(((\d*(\.\d+))|(\d*))(px|em|ex|in|cm|mm|pt|pc|\%)?)?$/i,W=/^(\s*[\w-]+\s*:\s*[^:;]+(?:;|$))*$/;a.VALIDATE_OR=1;a.VALIDATE_AND=2;a.dialog.validate={functions:function(){var X=arguments;return function(){var Y=this&&this.getValue?this.getValue():X[0],Z=undefined,aa=2,ab=[],ac;for(ac=0;ac<X.length;ac++){if(typeof X[ac]=='function')ab.push(X[ac]);else break;}if(ac<X.length&&typeof X[ac]=='string'){Z=X[ac];ac++;}if(ac<X.length&&typeof X[ac]=='number')aa=X[ac];var ad=aa==2?true:false;for(ac=0;ac<ab.length;ac++){if(aa==2)ad=ad&&ab[ac](Y);else ad=ad||ab[ac](Y);}return!ad?Z:true;};},regex:function(X,Y){return function(){var Z=this&&this.getValue?this.getValue():arguments[0];return!X.test(Z)?Y:true;};},notEmpty:function(X){return this.regex(R,X);},integer:function(X){return this.regex(S,X);},number:function(X){return this.regex(T,X);},cssLength:function(X){return this.functions(function(Y){return V.test(e.trim(Y));},X);},htmlLength:function(X){return this.functions(function(Y){return U.test(e.trim(Y));},X);},inlineStyle:function(X){return this.functions(function(Y){return W.test(e.trim(Y));},X);},equals:function(X,Y){return this.functions(function(Z){return Z==X;},Y);},notEqual:function(X,Y){return this.functions(function(Z){return Z!=X;},Y);}};a.on('instanceDestroyed',function(X){if(e.isEmpty(a.instances)){var Y;while(Y=a.dialog._.currentTop)Y.hide();J();}var Z=X.editor._.storedDialogs;for(var aa in Z)Z[aa].destroy();});})();e.extend(a.editor.prototype,{openDialog:function(R,S){if(this.mode=='wysiwyg'&&c){var T=this.getSelection();T&&T.lock();}var U=a.dialog._.dialogDefinitions[R],V=this.skin.dialog;if(a.dialog._.currentTop===null)H(this);if(typeof U=='function'&&V._isLoaded){var W=this._.storedDialogs||(this._.storedDialogs={}),X=W[R]||(W[R]=new a.dialog(this,R));S&&S.call(X,X);X.show();return X;}else if(U=='failed'){I();throw new Error('[CKEDITOR.dialog.openDialog] Dialog "'+R+'" failed when loading definition.');
}var Y=this;function Z(ab){var ac=a.dialog._.dialogDefinitions[R],ad=Y.skin.dialog;if(!ad._isLoaded||aa&&typeof ab=='undefined')return;if(typeof ac!='function')a.dialog._.dialogDefinitions[R]='failed';Y.openDialog(R,S);};if(typeof U=='string'){var aa=1;a.scriptLoader.load(a.getUrl(U),Z,null,0,1);}a.skins.load(this,'dialog',Z);return null;}});})();j.add('dialog',{requires:['dialogui']});j.add('styles',{requires:['selection'],init:function(m){m.on('contentDom',function(){m.document.setCustomData('cke_includeReadonly',!m.config.disableReadonlyStyling);});}});a.editor.prototype.attachStyleStateChange=function(m,n){var o=this._.styleStateChangeCallbacks;if(!o){o=this._.styleStateChangeCallbacks=[];this.on('selectionChange',function(p){for(var q=0;q<o.length;q++){var r=o[q],s=r.style.checkActive(p.data.path)?1:2;r.fn.call(this,s);}});}o.push({style:m,fn:n});};a.STYLE_BLOCK=1;a.STYLE_INLINE=2;a.STYLE_OBJECT=3;(function(){var m={address:1,div:1,h1:1,h2:1,h3:1,h4:1,h5:1,h6:1,p:1,pre:1,section:1,header:1,footer:1,nav:1,article:1,aside:1,figure:1,dialog:1,hgroup:1,time:1,meter:1,menu:1,command:1,keygen:1,output:1,progress:1,details:1,datagrid:1,datalist:1},n={a:1,embed:1,hr:1,img:1,li:1,object:1,ol:1,table:1,td:1,tr:1,th:1,ul:1,dl:1,dt:1,dd:1,form:1,audio:1,video:1},o=/\s*(?:;\s*|$)/,p=/#\((.+?)\)/g,q=d.walker.bookmark(0,1),r=d.walker.whitespaces(1);a.style=function(T,U){var X=this;var V=T.attributes;if(V&&V.style){T.styles=e.extend({},T.styles,Q(V.style));delete V.style;}if(U){T=e.clone(T);L(T.attributes,U);L(T.styles,U);}var W=X.element=T.element?typeof T.element=='string'?T.element.toLowerCase():T.element:'*';X.type=m[W]?1:n[W]?3:2;if(typeof X.element=='object')X.type=3;X._={definition:T};};a.style.prototype={apply:function(T){S.call(this,T,false);},remove:function(T){S.call(this,T,true);},applyToRange:function(T){var U=this;return(U.applyToRange=U.type==2?t:U.type==1?x:U.type==3?v:null).call(U,T);},removeFromRange:function(T){var U=this;return(U.removeFromRange=U.type==2?u:U.type==1?y:U.type==3?w:null).call(U,T);},applyToObject:function(T){K(T,this);},checkActive:function(T){var Y=this;switch(Y.type){case 1:return Y.checkElementRemovable(T.block||T.blockLimit,true);case 3:case 2:var U=T.elements;for(var V=0,W;V<U.length;V++){W=U[V];if(Y.type==2&&(W==T.block||W==T.blockLimit))continue;if(Y.type==3){var X=W.getName();if(!(typeof Y.element=='string'?X==Y.element:X in Y.element))continue;}if(Y.checkElementRemovable(W,true))return true;}}return false;},checkApplicable:function(T){switch(this.type){case 2:case 1:break;
case 3:return T.lastElement.getAscendant(this.element,true);}return true;},checkElementMatch:function(T,U){var aa=this;var V=aa._.definition;if(!T||!V.ignoreReadonly&&T.isReadOnly())return false;var W,X=T.getName();if(typeof aa.element=='string'?X==aa.element:X in aa.element){if(!U&&!T.hasAttributes())return true;W=M(V);if(W._length){for(var Y in W){if(Y=='_length')continue;var Z=T.getAttribute(Y)||'';if(Y=='style'?R(W[Y],P(Z,false)):W[Y]==Z){if(!U)return true;}else if(U)return false;}if(U)return true;}else return true;}return false;},checkElementRemovable:function(T,U){if(this.checkElementMatch(T,U))return true;var V=N(this)[T.getName()];if(V){var W,X;if(!(W=V.attributes))return true;for(var Y=0;Y<W.length;Y++){X=W[Y][0];var Z=T.getAttribute(X);if(Z){var aa=W[Y][1];if(aa===null||typeof aa=='string'&&Z==aa||aa.test(Z))return true;}}}return false;},buildPreview:function(T){var U=this._.definition,V=[],W=U.element;if(W=='bdo')W='span';V=['<',W];var X=U.attributes;if(X)for(var Y in X)V.push(' ',Y,'="',X[Y],'"');var Z=a.style.getStyleText(U);if(Z)V.push(' style="',Z,'"');V.push('>',T||U.name,'</',W,'>');return V.join('');}};a.style.getStyleText=function(T){var U=T._ST;if(U)return U;U=T.styles;var V=T.attributes&&T.attributes.style||'',W='';if(V.length)V=V.replace(o,';');for(var X in U){var Y=U[X],Z=(X+':'+Y).replace(o,';');if(Y=='inherit')W+=Z;else V+=Z;}if(V.length)V=P(V);V+=W;return T._ST=V;};function s(T){var U,V;while(T=T.getParent()){if(T.getName()=='body')break;if(T.getAttribute('data-nostyle'))U=T;else if(!V){var W=T.getAttribute('contentEditable');if(W=='false')U=T;else if(W=='true')V=1;}}return U;};function t(T){var ay=this;var U=T.document;if(T.collapsed){var V=J(ay,U);T.insertNode(V);T.moveToPosition(V,2);return;}var W=ay.element,X=ay._.definition,Y,Z=X.ignoreReadonly,aa=Z||X.includeReadonly;if(aa==undefined)aa=U.getCustomData('cke_includeReadonly');var ab=f[W]||(Y=true,f.span);T.enlarge(1,1);T.trim();var ac=T.createBookmark(),ad=ac.startNode,ae=ac.endNode,af=ad,ag;if(!Z){var ah=s(ad),ai=s(ae);if(ah)af=ah.getNextSourceNode(true);if(ai)ae=ai;}if(af.getPosition(ae)==2)af=0;while(af){var aj=false;if(af.equals(ae)){af=null;aj=true;}else{var ak=af.type,al=ak==1?af.getName():null,am=al&&af.getAttribute('contentEditable')=='false',an=al&&af.getAttribute('data-nostyle');if(al&&af.data('cke-bookmark')){af=af.getNextSourceNode(true);continue;}if(!al||ab[al]&&!an&&(!am||aa)&&(af.getPosition(ae)|4|0|8)==4+0+8&&(!X.childRule||X.childRule(af))){var ao=af.getParent();
if(ao&&((ao.getDtd()||f.span)[W]||Y)&&(!X.parentRule||X.parentRule(ao))){if(!ag&&(!al||!f.$removeEmpty[al]||(af.getPosition(ae)|4|0|8)==4+0+8)){ag=new d.range(U);ag.setStartBefore(af);}if(ak==3||am||ak==1&&!af.getChildCount()){var ap=af,aq;while((aj=!ap.getNext(q))&&(aq=ap.getParent(),ab[aq.getName()])&&(aq.getPosition(ad)|2|0|8)==2+0+8&&(!X.childRule||X.childRule(aq)))ap=aq;ag.setEndAfter(ap);}}else aj=true;}else aj=true;af=af.getNextSourceNode(an||am);}if(aj&&ag&&!ag.collapsed){var ar=J(ay,U),as=ar.hasAttributes(),at=ag.getCommonAncestor(),au={styles:{},attrs:{},blockedStyles:{},blockedAttrs:{}},av,aw,ax;while(ar&&at){if(at.getName()==W){for(av in X.attributes){if(au.blockedAttrs[av]||!(ax=at.getAttribute(aw)))continue;if(ar.getAttribute(av)==ax)au.attrs[av]=1;else au.blockedAttrs[av]=1;}for(aw in X.styles){if(au.blockedStyles[aw]||!(ax=at.getStyle(aw)))continue;if(ar.getStyle(aw)==ax)au.styles[aw]=1;else au.blockedStyles[aw]=1;}}at=at.getParent();}for(av in au.attrs)ar.removeAttribute(av);for(aw in au.styles)ar.removeStyle(aw);if(as&&!ar.hasAttributes())ar=null;if(ar){ag.extractContents().appendTo(ar);G(ay,ar);ag.insertNode(ar);ar.mergeSiblings();if(!c)ar.$.normalize();}else{ar=new h('span');ag.extractContents().appendTo(ar);ag.insertNode(ar);G(ay,ar);ar.remove(true);}ag=null;}}T.moveToBookmark(ac);T.shrink(2);};function u(T){T.enlarge(1,1);var U=T.createBookmark(),V=U.startNode;if(T.collapsed){var W=new d.elementPath(V.getParent()),X;for(var Y=0,Z;Y<W.elements.length&&(Z=W.elements[Y]);Y++){if(Z==W.block||Z==W.blockLimit)break;if(this.checkElementRemovable(Z)){var aa;if(T.collapsed&&(T.checkBoundaryOfElement(Z,2)||(aa=T.checkBoundaryOfElement(Z,1)))){X=Z;X.match=aa?'start':'end';}else{Z.mergeSiblings();if(Z.getName()==this.element)F(this,Z);else H(Z,N(this)[Z.getName()]);}}}if(X){var ab=V;for(Y=0;true;Y++){var ac=W.elements[Y];if(ac.equals(X))break;else if(ac.match)continue;else ac=ac.clone();ac.append(ab);ab=ac;}ab[X.match=='start'?'insertBefore':'insertAfter'](X);}}else{var ad=U.endNode,ae=this;function af(){var ai=new d.elementPath(V.getParent()),aj=new d.elementPath(ad.getParent()),ak=null,al=null;for(var am=0;am<ai.elements.length;am++){var an=ai.elements[am];if(an==ai.block||an==ai.blockLimit)break;if(ae.checkElementRemovable(an))ak=an;}for(am=0;am<aj.elements.length;am++){an=aj.elements[am];if(an==aj.block||an==aj.blockLimit)break;if(ae.checkElementRemovable(an))al=an;}if(al)ad.breakParent(al);if(ak)V.breakParent(ak);};af();var ag=V;while(!ag.equals(ad)){var ah=ag.getNextSourceNode();
if(ag.type==1&&this.checkElementRemovable(ag)){if(ag.getName()==this.element)F(this,ag);else H(ag,N(this)[ag.getName()]);if(ah.type==1&&ah.contains(V)){af();ah=V.getNext();}}ag=ah;}}T.moveToBookmark(U);};function v(T){var U=T.getCommonAncestor(true,true),V=U.getAscendant(this.element,true);V&&!V.isReadOnly()&&K(V,this);};function w(T){var U=T.getCommonAncestor(true,true),V=U.getAscendant(this.element,true);if(!V)return;var W=this,X=W._.definition,Y=X.attributes;if(Y)for(var Z in Y)V.removeAttribute(Z,Y[Z]);if(X.styles)for(var aa in X.styles){if(!X.styles.hasOwnProperty(aa))continue;V.removeStyle(aa);}};function x(T){var U=T.createBookmark(true),V=T.createIterator();V.enforceRealBlocks=true;if(this._.enterMode)V.enlargeBr=this._.enterMode!=2;var W,X=T.document,Y;while(W=V.getNextParagraph()){if(!W.isReadOnly()){var Z=J(this,X,W);z(W,Z);}}T.moveToBookmark(U);};function y(T){var Y=this;var U=T.createBookmark(1),V=T.createIterator();V.enforceRealBlocks=true;V.enlargeBr=Y._.enterMode!=2;var W;while(W=V.getNextParagraph()){if(Y.checkElementRemovable(W))if(W.is('pre')){var X=Y._.enterMode==2?null:T.document.createElement(Y._.enterMode==1?'p':'div');X&&W.copyAttributes(X);z(W,X);}else F(Y,W,1);}T.moveToBookmark(U);};function z(T,U){var V=!U;if(V){U=T.getDocument().createElement('div');T.copyAttributes(U);}var W=U&&U.is('pre'),X=T.is('pre'),Y=W&&!X,Z=!W&&X;if(Y)U=E(T,U);else if(Z)U=D(V?[T.getHtml()]:B(T),U);else T.moveChildren(U);U.replace(T);if(W)A(U);else if(V)I(U);};function A(T){var U;if(!((U=T.getPrevious(r))&&U.is&&U.is('pre')))return;var V=C(U.getHtml(),/\n$/,'')+'\n\n'+C(T.getHtml(),/^\n/,'');if(c)T.$.outerHTML='<pre>'+V+'</pre>';else T.setHtml(V);U.remove();};function B(T){var U=/(\S\s*)\n(?:\s|(<span[^>]+data-cke-bookmark.*?\/span>))*\n(?!$)/gi,V=T.getName(),W=C(T.getOuterHtml(),U,function(Y,Z,aa){return Z+'</pre>'+aa+'<pre>';}),X=[];W.replace(/<pre\b.*?>([\s\S]*?)<\/pre>/gi,function(Y,Z){X.push(Z);});return X;};function C(T,U,V){var W='',X='';T=T.replace(/(^<span[^>]+data-cke-bookmark.*?\/span>)|(<span[^>]+data-cke-bookmark.*?\/span>$)/gi,function(Y,Z,aa){Z&&(W=Z);aa&&(X=aa);return '';});return W+T.replace(U,V)+X;};function D(T,U){var V;if(T.length>1)V=new d.documentFragment(U.getDocument());for(var W=0;W<T.length;W++){var X=T[W];X=X.replace(/(\r\n|\r)/g,'\n');X=C(X,/^[ \t]*\n/,'');X=C(X,/\n$/,'');X=C(X,/^[ \t]+|[ \t]+$/g,function(Z,aa,ab){if(Z.length==1)return '&nbsp;';else if(!aa)return e.repeat('&nbsp;',Z.length-1)+' ';else return ' '+e.repeat('&nbsp;',Z.length-1);
});X=X.replace(/\n/g,'<br>');X=X.replace(/[ \t]{2,}/g,function(Z){return e.repeat('&nbsp;',Z.length-1)+' ';});if(V){var Y=U.clone();Y.setHtml(X);V.append(Y);}else U.setHtml(X);}return V||U;};function E(T,U){var V=T.getBogus();V&&V.remove();var W=T.getHtml();W=C(W,/(?:^[ \t\n\r]+)|(?:[ \t\n\r]+$)/g,'');W=W.replace(/[ \t\r\n]*(<br[^>]*>)[ \t\r\n]*/gi,'$1');W=W.replace(/([ \t\n\r]+|&nbsp;)/g,' ');W=W.replace(/<br\b[^>]*>/gi,'\n');if(c){var X=T.getDocument().createElement('div');X.append(U);U.$.outerHTML='<pre>'+W+'</pre>';U.copyAttributes(X.getFirst());U=X.getFirst().remove();}else U.setHtml(W);return U;};function F(T,U){var V=T._.definition,W=V.attributes,X=V.styles,Y=N(T)[U.getName()],Z=e.isEmpty(W)&&e.isEmpty(X);for(var aa in W){if((aa=='class'||T._.definition.fullMatch)&&U.getAttribute(aa)!=O(aa,W[aa]))continue;Z=U.hasAttribute(aa);U.removeAttribute(aa);}for(var ab in X){if(T._.definition.fullMatch&&U.getStyle(ab)!=O(ab,X[ab],true))continue;Z=Z||!!U.getStyle(ab);U.removeStyle(ab);}H(U,Y,m[U.getName()]);if(Z)!f.$block[U.getName()]||T._.enterMode==2&&!U.hasAttributes()?I(U):U.renameNode(T._.enterMode==1?'p':'div');};function G(T,U){var V=T._.definition,W=V.attributes,X=V.styles,Y=N(T),Z=U.getElementsByTag(T.element);for(var aa=Z.count();--aa>=0;)F(T,Z.getItem(aa));for(var ab in Y){if(ab!=T.element){Z=U.getElementsByTag(ab);for(aa=Z.count()-1;aa>=0;aa--){var ac=Z.getItem(aa);H(ac,Y[ab]);}}}};function H(T,U,V){var W=U&&U.attributes;if(W)for(var X=0;X<W.length;X++){var Y=W[X][0],Z;if(Z=T.getAttribute(Y)){var aa=W[X][1];if(aa===null||aa.test&&aa.test(Z)||typeof aa=='string'&&Z==aa)T.removeAttribute(Y);}}if(!V)I(T);};function I(T){if(!T.hasAttributes())if(f.$block[T.getName()]){var U=T.getPrevious(r),V=T.getNext(r);if(U&&(U.type==3||!U.isBlockBoundary({br:1})))T.append('br',1);if(V&&(V.type==3||!V.isBlockBoundary({br:1})))T.append('br');T.remove(true);}else{var W=T.getFirst(),X=T.getLast();T.remove(true);if(W){W.type==1&&W.mergeSiblings();if(X&&!W.equals(X)&&X.type==1)X.mergeSiblings();}}};function J(T,U,V){var W,X=T._.definition,Y=T.element;if(Y=='*')Y='span';W=new h(Y,U);if(V)V.copyAttributes(W);W=K(W,T);if(U.getCustomData('doc_processing_style')&&W.hasAttribute('id'))W.removeAttribute('id');else U.setCustomData('doc_processing_style',1);return W;};function K(T,U){var V=U._.definition,W=V.attributes,X=a.style.getStyleText(V);if(W)for(var Y in W)T.setAttribute(Y,W[Y]);if(X)T.setAttribute('style',X);return T;};function L(T,U){for(var V in T)T[V]=T[V].replace(p,function(W,X){return U[X];
});};function M(T){var U=T._AC;if(U)return U;U={};var V=0,W=T.attributes;if(W)for(var X in W){V++;U[X]=W[X];}var Y=a.style.getStyleText(T);if(Y){if(!U.style)V++;U.style=Y;}U._length=V;return T._AC=U;};function N(T){if(T._.overrides)return T._.overrides;var U=T._.overrides={},V=T._.definition.overrides;if(V){if(!e.isArray(V))V=[V];for(var W=0;W<V.length;W++){var X=V[W],Y,Z,aa;if(typeof X=='string')Y=X.toLowerCase();else{Y=X.element?X.element.toLowerCase():T.element;aa=X.attributes;}Z=U[Y]||(U[Y]={});if(aa){var ab=Z.attributes=Z.attributes||[];for(var ac in aa)ab.push([ac.toLowerCase(),aa[ac]]);}}}return U;};function O(T,U,V){var W=new h('span');W[V?'setStyle':'setAttribute'](T,U);return W[V?'getStyle':'getAttribute'](T);};function P(T,U){var V;if(U!==false){var W=new h('span');W.setAttribute('style',T);V=W.getAttribute('style')||'';}else V=T;V=V.replace(/(font-family:)(.*?)(?=;|$)/,function(X,Y,Z){var aa=Z.split(',');for(var ab=0;ab<aa.length;ab++)aa[ab]=e.trim(aa[ab].replace(/["']/g,''));return Y+aa.join(',');});return V.replace(/\s*([;:])\s*/,'$1').replace(/([^\s;])$/,'$1;').replace(/,\s+/g,',').replace(/\"/g,'').toLowerCase();};function Q(T){var U={};T.replace(/&quot;/g,'"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g,function(V,W,X){U[W]=X;});return U;};function R(T,U){typeof T=='string'&&(T=Q(T));typeof U=='string'&&(U=Q(U));for(var V in T){if(!(V in U&&(U[V]==T[V]||T[V]=='inherit'||U[V]=='inherit')))return false;}return true;};function S(T,U){var V=T.getSelection(),W=V.createBookmarks(1),X=V.getRanges(),Y=U?this.removeFromRange:this.applyToRange,Z,aa=X.createIterator();while(Z=aa.getNextRange())Y.call(this,Z);if(W.length==1&&W[0].collapsed){V.selectRanges(X);T.getById(W[0].startNode).remove();}else V.selectBookmarks(W);T.removeCustomData('doc_processing_style');};})();a.styleCommand=function(m){this.style=m;};a.styleCommand.prototype.exec=function(m){var o=this;m.focus();var n=m.document;if(n)if(o.state==2)o.style.apply(n);else if(o.state==1)o.style.remove(n);return!!n;};a.stylesSet=new a.resourceManager('','stylesSet');a.addStylesSet=e.bind(a.stylesSet.add,a.stylesSet);a.loadStylesSet=function(m,n,o){a.stylesSet.addExternal(m,n,'');a.stylesSet.load(m,o);};a.editor.prototype.getStylesSet=function(m){if(!this._.stylesDefinitions){var n=this,o=n.config.stylesCombo_stylesSet||n.config.stylesSet||'default';if(o instanceof Array){n._.stylesDefinitions=o;m(o);return;}var p=o.split(':'),q=p[0],r=p[1],s=j.registered.styles.path;a.stylesSet.addExternal(q,r?p.slice(1).join(':'):s+'styles/'+q+'.js','');
a.stylesSet.load(q,function(t){n._.stylesDefinitions=t[q];m(n._.stylesDefinitions);});}else m(this._.stylesDefinitions);};j.add('domiterator');(function(){function m(s){var t=this;if(arguments.length<1)return;t.range=s;t.forceBrBreak=0;t.enlargeBr=1;t.enforceRealBlocks=0;t._||(t._={});};var n=/^[\r\n\t ]+$/,o=d.walker.bookmark(false,true),p=d.walker.whitespaces(true),q=function(s){return o(s)&&p(s);};function r(s,t,u){var v=s.getNextSourceNode(t,null,u);while(!o(v))v=v.getNextSourceNode(t,null,u);return v;};m.prototype={getNextParagraph:function(s){var S=this;var t,u,v,w,x,y;if(!S._.started){u=S.range.clone();u.shrink(1,true);w=u.endContainer.hasAscendant('pre',true)||u.startContainer.hasAscendant('pre',true);u.enlarge(S.forceBrBreak&&!w||!S.enlargeBr?3:2);if(!u.collapsed){var z=new d.walker(u.clone()),A=d.walker.bookmark(true,true);z.evaluator=A;S._.nextNode=z.next();z=new d.walker(u.clone());z.evaluator=A;var B=z.previous();S._.lastNode=B.getNextSourceNode(true);if(S._.lastNode&&S._.lastNode.type==3&&!e.trim(S._.lastNode.getText())&&S._.lastNode.getParent().isBlockBoundary()){var C=new d.range(u.document);C.moveToPosition(S._.lastNode,4);if(C.checkEndOfBlock()){var D=new d.elementPath(C.endContainer),E=D.block||D.blockLimit;S._.lastNode=E.getNextSourceNode(true);}}if(!S._.lastNode){S._.lastNode=S._.docEndMarker=u.document.createText('');S._.lastNode.insertAfter(B);}u=null;}S._.started=1;}var F=S._.nextNode;B=S._.lastNode;S._.nextNode=null;while(F){var G=0,H=F.hasAscendant('pre'),I=F.type!=1,J=0;if(!I){var K=F.getName();if(F.isBlockBoundary(S.forceBrBreak&&!H&&{br:1})){if(K=='br')I=1;else if(!u&&!F.getChildCount()&&K!='hr'){t=F;v=F.equals(B);break;}if(u){u.setEndAt(F,3);if(K!='br')S._.nextNode=F;}G=1;}else{if(F.getFirst()){if(!u){u=new d.range(S.range.document);u.setStartAt(F,3);}F=F.getFirst();continue;}I=1;}}else if(F.type==3)if(n.test(F.getText()))I=0;if(I&&!u){u=new d.range(S.range.document);u.setStartAt(F,3);}v=(!G||I)&&F.equals(B);if(u&&!G)while(!F.getNext(q)&&!v){var L=F.getParent();if(L.isBlockBoundary(S.forceBrBreak&&!H&&{br:1})){G=1;I=0;v=v||L.equals(B);u.setEndAt(L,2);break;}F=L;I=1;v=F.equals(B);J=1;}if(I)u.setEndAt(F,4);F=r(F,J,B);v=!F;if(v||G&&u)break;}if(!t){if(!u){S._.docEndMarker&&S._.docEndMarker.remove();S._.nextNode=null;return null;}var M=new d.elementPath(u.startContainer),N=M.blockLimit,O={div:1,th:1,td:1};t=M.block;if(!t&&!S.enforceRealBlocks&&O[N.getName()]&&u.checkStartOfBlock()&&u.checkEndOfBlock())t=N;else if(!t||S.enforceRealBlocks&&t.getName()=='li'){t=S.range.document.createElement(s||'p');
u.extractContents().appendTo(t);t.trim();u.insertNode(t);x=y=true;}else if(t.getName()!='li'){if(!u.checkStartOfBlock()||!u.checkEndOfBlock()){t=t.clone(false);u.extractContents().appendTo(t);t.trim();var P=u.splitBlock();x=!P.wasStartOfBlock;y=!P.wasEndOfBlock;u.insertNode(t);}}else if(!v)S._.nextNode=t.equals(B)?null:r(u.getBoundaryNodes().endNode,1,B);}if(x){var Q=t.getPrevious();if(Q&&Q.type==1)if(Q.getName()=='br')Q.remove();else if(Q.getLast()&&Q.getLast().$.nodeName.toLowerCase()=='br')Q.getLast().remove();}if(y){var R=t.getLast();if(R&&R.type==1&&R.getName()=='br')if(c||R.getPrevious(o)||R.getNext(o))R.remove();}if(!S._.nextNode)S._.nextNode=v||t.equals(B)||!B?null:r(t,1,B);return t;}};d.range.prototype.createIterator=function(){return new m(this);};})();j.add('panelbutton',{requires:['button'],onLoad:function(){function m(n){var p=this;var o=p._;if(o.state==0)return;p.createPanel(n);if(o.on){o.panel.hide();return;}o.panel.showBlock(p._.id,p.document.getById(p._.id),4);};k.panelButton=e.createClass({base:k.button,$:function(n){var p=this;var o=n.panel;delete n.panel;p.base(n);p.document=o&&o.parent&&o.parent.getDocument()||a.document;o.block={attributes:o.attributes};p.hasArrow=true;p.click=m;p._={panelDefinition:o};},statics:{handler:{create:function(n){return new k.panelButton(n);}}},proto:{createPanel:function(n){var o=this._;if(o.panel)return;var p=this._.panelDefinition||{},q=this._.panelDefinition.block,r=p.parent||a.document.getBody(),s=this._.panel=new k.floatPanel(n,r,p),t=s.addBlock(o.id,q),u=this;s.onShow=function(){if(u.className)this.element.getFirst().addClass(u.className+'_panel');u.setState(1);o.on=1;if(u.onOpen)u.onOpen();};s.onHide=function(v){if(u.className)this.element.getFirst().removeClass(u.className+'_panel');u.setState(u.modes&&u.modes[n.mode]?2:0);o.on=0;if(!v&&u.onClose)u.onClose();};s.onEscape=function(){s.hide();u.document.getById(o.id).focus();};if(this.onBlock)this.onBlock(s,t);t.onHide=function(){o.on=0;u.setState(2);};}}});},beforeInit:function(m){m.ui.addHandler('panelbutton',k.panelButton.handler);}});a.UI_PANELBUTTON='panelbutton';j.add('floatpanel',{requires:['panel']});(function(){var m={},n=false;function o(p,q,r,s,t){var u=e.genKey(q.getUniqueId(),r.getUniqueId(),p.skinName,p.lang.dir,p.uiColor||'',s.css||'',t||''),v=m[u];if(!v){v=m[u]=new k.panel(q,s);v.element=r.append(h.createFromHtml(v.renderHtml(p),q));v.element.setStyles({display:'none',position:'absolute'});}return v;};k.floatPanel=e.createClass({$:function(p,q,r,s){r.forceIFrame=1;
var t=q.getDocument(),u=o(p,t,q,r,s||0),v=u.element,w=v.getFirst().getFirst();v.disableContextMenu();this.element=v;this._={editor:p,panel:u,parentElement:q,definition:r,document:t,iframe:w,children:[],dir:p.lang.dir};p.on('mode',function(){this.hide();},this);},proto:{addBlock:function(p,q){return this._.panel.addBlock(p,q);},addListBlock:function(p,q){return this._.panel.addListBlock(p,q);},getBlock:function(p){return this._.panel.getBlock(p);},showBlock:function(p,q,r,s,t){var u=this._.panel,v=u.showBlock(p);this.allowBlur(false);n=1;this._.returnFocus=this._.editor.focusManager.hasFocus?this._.editor:new h(a.document.$.activeElement);var w=this.element,x=this._.iframe,y=this._.definition,z=q.getDocumentPosition(w.getDocument()),A=this._.dir=='rtl',B=z.x+(s||0),C=z.y+(t||0);if(A&&(r==1||r==4))B+=q.$.offsetWidth;else if(!A&&(r==2||r==3))B+=q.$.offsetWidth-1;if(r==3||r==4)C+=q.$.offsetHeight-1;this._.panel._.offsetParentId=q.getId();w.setStyles({top:C+'px',left:0,display:''});w.setOpacity(0);w.getFirst().removeStyle('width');if(!this._.blurSet){var D=c?x:new d.window(x.$.contentWindow);a.event.useCapture=true;D.on('blur',function(E){var G=this;if(!G.allowBlur())return;var F=E.data.getTarget();if(F.getName&&F.getName()!='iframe')return;if(G.visible&&!G._.activeChild&&!n){delete G._.returnFocus;G.hide();}},this);D.on('focus',function(){this._.focused=true;this.hideChild();this.allowBlur(true);},this);a.event.useCapture=false;this._.blurSet=1;}u.onEscape=e.bind(function(E){if(this.onEscape&&this.onEscape(E)===false)return false;},this);e.setTimeout(function(){var E=e.bind(function(){var F=w.getFirst();if(v.autoSize){var G=v.element.$;if(b.gecko||b.opera)G=G.parentNode;if(c)G=G.document.body;var H=G.scrollWidth;if(c&&b.quirks&&H>0)H+=(F.$.offsetWidth||0)-(F.$.clientWidth||0)+3;H+=4;F.setStyle('width',H+'px');v.element.addClass('cke_frameLoaded');var I=v.element.$.scrollHeight;if(c&&b.quirks&&I>0)I+=(F.$.offsetHeight||0)-(F.$.clientHeight||0)+3;F.setStyle('height',I+'px');u._.currentBlock.element.setStyle('display','none').removeStyle('display');}else F.removeStyle('height');if(A)B-=w.$.offsetWidth;w.setStyle('left',B+'px');var J=u.element,K=J.getWindow(),L=w.$.getBoundingClientRect(),M=K.getViewPaneSize(),N=L.width||L.right-L.left,O=L.height||L.bottom-L.top,P=A?L.right:M.width-L.left,Q=A?M.width-L.right:L.left;if(A){if(P<N)if(Q>N)B+=N;else if(M.width>N)B-=L.left;else B=B-L.right+M.width;}else if(P<N)if(Q>N)B-=N;else if(M.width>N)B=B-L.right+M.width;else B-=L.left;
var R=M.height-L.top,S=L.top;if(R<O)if(S>O)C-=O;else if(M.height>O)C=C-L.bottom+M.height;else C-=L.top;if(c){var T=new h(w.$.offsetParent),U=T;if(U.getName()=='html')U=U.getDocument().getBody();if(U.getComputedStyle('direction')=='rtl')if(b.ie8Compat)B-=w.getDocument().getDocumentElement().$.scrollLeft*2;else B-=T.$.scrollWidth-T.$.clientWidth;}var V=w.getFirst(),W;if(W=V.getCustomData('activePanel'))W.onHide&&W.onHide.call(this,1);V.setCustomData('activePanel',this);w.setStyles({top:C+'px',left:B+'px'});w.setOpacity(1);},this);u.isLoaded?E():u.onLoad=E;e.setTimeout(function(){x.$.contentWindow.focus();this.allowBlur(true);},0,this);},b.air?200:0,this);this.visible=1;if(this.onShow)this.onShow.call(this);n=0;},hide:function(p){var r=this;if(r.visible&&(!r.onHide||r.onHide.call(r)!==true)){r.hideChild();b.gecko&&r._.iframe.getFrameDocument().$.activeElement.blur();r.element.setStyle('display','none');r.visible=0;r.element.getFirst().removeCustomData('activePanel');var q=p!==false&&r._.returnFocus;if(q){if(b.webkit&&q.type)q.getWindow().$.focus();q.focus();}}},allowBlur:function(p){var q=this._.panel;if(p!=undefined)q.allowBlur=p;return q.allowBlur;},showAsChild:function(p,q,r,s,t,u){if(this._.activeChild==p&&p._.panel._.offsetParentId==r.getId())return;this.hideChild();p.onHide=e.bind(function(){e.setTimeout(function(){if(!this._.focused)this.hide();},0,this);},this);this._.activeChild=p;this._.focused=false;p.showBlock(q,r,s,t,u);if(b.ie7Compat||b.ie8&&b.ie6Compat)setTimeout(function(){p.element.getChild(0).$.style.cssText+='';},100);},hideChild:function(){var p=this._.activeChild;if(p){delete p.onHide;delete p._.returnFocus;delete this._.activeChild;p.hide();}}}});a.on('instanceDestroyed',function(){var p=e.isEmpty(a.instances);for(var q in m){var r=m[q];if(p)r.destroy();else r.element.hide();}p&&(m={});});})();j.add('menu',{beforeInit:function(m){var n=m.config.menu_groups.split(','),o=m._.menuGroups={},p=m._.menuItems={};for(var q=0;q<n.length;q++)o[n[q]]=q+1;m.addMenuGroup=function(r,s){o[r]=s||100;};m.addMenuItem=function(r,s){if(o[s.group])p[r]=new a.menuItem(this,r,s);};m.addMenuItems=function(r){for(var s in r)this.addMenuItem(s,r[s]);};m.getMenuItem=function(r){return p[r];};m.removeMenuItem=function(r){delete p[r];};},requires:['floatpanel']});(function(){a.menu=e.createClass({$:function(n,o){var r=this;o=r._.definition=o||{};r.id=e.getNextId();r.editor=n;r.items=[];r._.listeners=[];r._.level=o.level||1;var p=e.extend({},o.panel,{css:n.skin.editor.css,level:r._.level-1,block:{}}),q=p.block.attributes=p.attributes||{};
!q.role&&(q.role='menu');r._.panelDefinition=p;},_:{onShow:function(){var v=this;var n=v.editor.getSelection();if(c)n&&n.lock();var o=n&&n.getStartElement(),p=v._.listeners,q=[];v.removeAll();for(var r=0;r<p.length;r++){var s=p[r](o,n);if(s)for(var t in s){var u=v.editor.getMenuItem(t);if(u&&(!u.command||v.editor.getCommand(u.command).state)){u.state=s[t];v.add(u);}}}},onClick:function(n){this.hide(false);if(n.onClick)n.onClick();else if(n.command)this.editor.execCommand(n.command);},onEscape:function(n){var o=this.parent;if(o){o._.panel.hideChild();var p=o._.panel._.panel._.currentBlock,q=p._.focusIndex;p._.markItem(q);}else if(n==27)this.hide();return false;},onHide:function(){var o=this;if(c&&!o.parent){var n=o.editor.getSelection();n&&n.unlock(true);}o.onHide&&o.onHide();},showSubMenu:function(n){var v=this;var o=v._.subMenu,p=v.items[n],q=p.getItems&&p.getItems();if(!q){v._.panel.hideChild();return;}var r=v._.panel.getBlock(v.id);r._.focusIndex=n;if(o)o.removeAll();else{o=v._.subMenu=new a.menu(v.editor,e.extend({},v._.definition,{level:v._.level+1},true));o.parent=v;o._.onClick=e.bind(v._.onClick,v);}for(var s in q){var t=v.editor.getMenuItem(s);if(t){t.state=q[s];o.add(t);}}var u=v._.panel.getBlock(v.id).element.getDocument().getById(v.id+String(n));o.show(u,2);}},proto:{add:function(n){if(!n.order)n.order=this.items.length;this.items.push(n);},removeAll:function(){this.items=[];},show:function(n,o,p,q){if(!this.parent){this._.onShow();if(!this.items.length)return;}o=o||(this.editor.lang.dir=='rtl'?2:1);var r=this.items,s=this.editor,t=this._.panel,u=this._.element;if(!t){t=this._.panel=new k.floatPanel(this.editor,a.document.getBody(),this._.panelDefinition,this._.level);t.onEscape=e.bind(function(F){if(this._.onEscape(F)===false)return false;},this);t.onHide=e.bind(function(){this._.onHide&&this._.onHide();},this);var v=t.addBlock(this.id,this._.panelDefinition.block);v.autoSize=true;var w=v.keys;w[40]='next';w[9]='next';w[38]='prev';w[2228224+9]='prev';w[s.lang.dir=='rtl'?37:39]=c?'mouseup':'click';w[32]=c?'mouseup':'click';c&&(w[13]='mouseup');u=this._.element=v.element;u.addClass(s.skinClass);var x=u.getDocument();x.getBody().setStyle('overflow','hidden');x.getElementsByTag('html').getItem(0).setStyle('overflow','hidden');this._.itemOverFn=e.addFunction(function(F){var G=this;clearTimeout(G._.showSubTimeout);G._.showSubTimeout=e.setTimeout(G._.showSubMenu,s.config.menu_subMenuDelay||400,G,[F]);},this);this._.itemOutFn=e.addFunction(function(F){clearTimeout(this._.showSubTimeout);
},this);this._.itemClickFn=e.addFunction(function(F){var H=this;var G=H.items[F];if(G.state==0){H.hide();return;}if(G.getItems)H._.showSubMenu(F);else H._.onClick(G);},this);}m(r);var y=s.container.getChild(1),z=y.hasClass('cke_mixed_dir_content')?' cke_mixed_dir_content':'',A=['<div class="cke_menu'+z+'" role="presentation">'],B=r.length,C=B&&r[0].group;for(var D=0;D<B;D++){var E=r[D];if(C!=E.group){A.push('<div class="cke_menuseparator" role="separator"></div>');C=E.group;}E.render(this,D,A);}A.push('</div>');u.setHtml(A.join(''));k.fire('ready',this);if(this.parent)this.parent._.panel.showAsChild(t,this.id,n,o,p,q);else t.showBlock(this.id,n,o,p,q);s.fire('menuShow',[t]);},addListener:function(n){this._.listeners.push(n);},hide:function(n){var o=this;o._.onHide&&o._.onHide();o._.panel&&o._.panel.hide(n);}}});function m(n){n.sort(function(o,p){if(o.group<p.group)return-1;else if(o.group>p.group)return 1;return o.order<p.order?-1:o.order>p.order?1:0;});};a.menuItem=e.createClass({$:function(n,o,p){var q=this;e.extend(q,p,{order:0,className:'cke_button_'+o});q.group=n._.menuGroups[q.group];q.editor=n;q.name=o;},proto:{render:function(n,o,p){var w=this;var q=n.id+String(o),r=typeof w.state=='undefined'?2:w.state,s=' cke_'+(r==1?'on':r==0?'disabled':'off'),t=w.label;if(w.className)s+=' '+w.className;var u=w.getItems;p.push('<span class="cke_menuitem'+(w.icon&&w.icon.indexOf('.png')==-1?' cke_noalphafix':'')+'">'+'<a id="',q,'" class="',s,'" href="javascript:void(\'',(w.label||'').replace("'",''),'\')" title="',w.label,'" tabindex="-1"_cke_focus=1 hidefocus="true" role="menuitem"'+(u?'aria-haspopup="true"':'')+(r==0?'aria-disabled="true"':'')+(r==1?'aria-pressed="true"':''));if(b.opera||b.gecko&&b.mac)p.push(' onkeypress="return false;"');if(b.gecko)p.push(' onblur="this.style.cssText = this.style.cssText;"');var v=(w.iconOffset||0)*-16;p.push(' onmouseover="CKEDITOR.tools.callFunction(',n._.itemOverFn,',',o,');" onmouseout="CKEDITOR.tools.callFunction(',n._.itemOutFn,',',o,');" '+(c?'onclick="return false;" onmouseup':'onclick')+'="CKEDITOR.tools.callFunction(',n._.itemClickFn,',',o,'); return false;"><span class="cke_icon_wrapper"><span class="cke_icon"'+(w.icon?' style="background-image:url('+a.getUrl(w.icon)+');background-position:0 '+v+'px;"':'')+'></span></span>'+'<span class="cke_label">');if(u)p.push('<span class="cke_menuarrow">','<span>&#',w.editor.lang.dir=='rtl'?'9668':'9658',';</span>','</span>');p.push(t,'</span></a></span>');}}});})();i.menu_groups='clipboard,form,tablecell,tablecellproperties,tablerow,tablecolumn,table,anchor,link,image,flash,checkbox,radio,textfield,hiddenfield,imagebutton,button,select,textarea,div';
(function(){var m;j.add('editingblock',{init:function(n){if(!n.config.editingBlock)return;n.on('themeSpace',function(o){if(o.data.space=='contents')o.data.html+='<br>';});n.on('themeLoaded',function(){n.fireOnce('editingBlockReady');});n.on('uiReady',function(){n.setMode(n.config.startupMode);});n.on('afterSetData',function(){if(!m){function o(){m=true;n.getMode().loadData(n.getData());m=false;};if(n.mode)o();else n.on('mode',function(){if(n.mode){o();n.removeListener('mode',arguments.callee);}});}});n.on('beforeGetData',function(){if(!m&&n.mode){m=true;n.setData(n.getMode().getData(),null,1);m=false;}});n.on('getSnapshot',function(o){if(n.mode)o.data=n.getMode().getSnapshotData();});n.on('loadSnapshot',function(o){if(n.mode)n.getMode().loadSnapshotData(o.data);});n.on('mode',function(o){o.removeListener();b.webkit&&n.container.on('focus',function(){n.focus();});if(n.config.startupFocus)n.focus();setTimeout(function(){n.fireOnce('instanceReady');a.fire('instanceReady',null,n);},0);});n.on('destroy',function(){var o=this;if(o.mode)o._.modes[o.mode].unload(o.getThemeSpace('contents'));});}});a.editor.prototype.mode='';a.editor.prototype.addMode=function(n,o){o.name=n;(this._.modes||(this._.modes={}))[n]=o;};a.editor.prototype.setMode=function(n){this.fire('beforeSetMode',{newMode:n});var o,p=this.getThemeSpace('contents'),q=this.checkDirty();if(this.mode){if(n==this.mode)return;this._.previousMode=this.mode;this.fire('beforeModeUnload');var r=this.getMode();o=r.getData();r.unload(p);this.mode='';}p.setHtml('');var s=this.getMode(n);if(!s)throw '[CKEDITOR.editor.setMode] Unknown mode "'+n+'".';if(!q)this.on('mode',function(){this.resetDirty();this.removeListener('mode',arguments.callee);});s.load(p,typeof o!='string'?this.getData():o);};a.editor.prototype.getMode=function(n){return this._.modes&&this._.modes[n||this.mode];};a.editor.prototype.focus=function(){this.forceNextSelectionCheck();var n=this.getMode();if(n)n.focus();};})();i.startupMode='wysiwyg';i.editingBlock=true;(function(){function m(){var G=this;try{var D=G.getSelection();if(!D||!D.document.getWindow().$)return;var E=D.getStartElement(),F=new d.elementPath(E);if(!F.compare(G._.selectionPreviousPath)){G._.selectionPreviousPath=F;G.fire('selectionChange',{selection:D,path:F,element:E});}}catch(H){}};var n,o;function p(){o=true;if(n)return;q.call(this);n=e.setTimeout(q,200,this);};function q(){n=null;if(o){e.setTimeout(m,0,this);o=false;}};function r(D){function E(I,J){if(!I||I.type==3)return false;
var K=D.clone();return K['moveToElementEdit'+(J?'End':'Start')](I);};var F=D.startContainer,G=D.getPreviousNode(A,null,F),H=D.getNextNode(A,null,F);if(E(G)||E(H,1))return true;if(!(G||H)&&!(F.type==1&&F.isBlockBoundary()&&F.getBogus()))return true;return false;};var s={modes:{wysiwyg:1,source:1},readOnly:c||b.webkit,exec:function(D){switch(D.mode){case 'wysiwyg':D.document.$.execCommand('SelectAll',false,null);D.forceNextSelectionCheck();D.selectionChange();break;case 'source':var E=D.textarea.$;if(c)E.createTextRange().execCommand('SelectAll');else{E.selectionStart=0;E.selectionEnd=E.value.length;}E.focus();}},canUndo:false};function t(D){w(D);var E=D.createText('​');D.setCustomData('cke-fillingChar',E);return E;};function u(D){return D&&D.getCustomData('cke-fillingChar');};function v(D){var E=D&&u(D);if(E)if(E.getCustomData('ready'))w(D);else E.setCustomData('ready',1);};function w(D){var E=D&&D.removeCustomData('cke-fillingChar');if(E){var F,G=D.getSelection().getNative(),H=G&&G.type!='None'&&G.getRangeAt(0);if(E.getLength()>1&&H&&H.intersectsNode(E.$)){F=[G.anchorOffset,G.focusOffset];var I=G.anchorNode==E.$&&G.anchorOffset>0,J=G.focusNode==E.$&&G.focusOffset>0;I&&F[0]--;J&&F[1]--;x(G)&&F.unshift(F.pop());}E.setText(E.getText().replace(/\u200B/g,''));if(F){var K=G.getRangeAt(0);K.setStart(K.startContainer,F[0]);K.setEnd(K.startContainer,F[1]);G.removeAllRanges();G.addRange(K);}}};function x(D){if(!D.isCollapsed){var E=D.getRangeAt(0);E.setStart(D.anchorNode,D.anchorOffset);E.setEnd(D.focusNode,D.focusOffset);return E.collapsed;}};j.add('selection',{init:function(D){if(b.webkit){D.on('selectionChange',function(){v(D.document);});D.on('beforeSetMode',function(){w(D.document);});var E,F;function G(){var I=D.document,J=u(I);if(J){var K=I.$.defaultView.getSelection();if(K.type=='Caret'&&K.anchorNode==J.$)F=1;E=J.getText();J.setText(E.replace(/\u200B/g,''));}};function H(){var I=D.document,J=u(I);if(J){J.setText(E);if(F){I.$.defaultView.getSelection().setPosition(J.$,J.getLength());F=0;}}};D.on('beforeUndoImage',G);D.on('afterUndoImage',H);D.on('beforeGetData',G,null,null,0);D.on('getData',H);}D.on('contentDom',function(){var I=D.document,J=a.document,K=I.getBody(),L=I.getDocumentElement();if(c){var M,N,O=1;K.on('focusin',function(V){if(V.data.$.srcElement.nodeName!='BODY')return;var W=I.getCustomData('cke_locked_selection');if(W){W.unlock(1);W.lock();}else if(M&&O){try{M.select();}catch(X){}M=null;}});K.on('focus',function(){N=1;U();});K.on('beforedeactivate',function(V){if(V.data.$.toElement)return;
N=0;O=1;});c&&D.on('blur',function(){try{I.$.selection.empty();}catch(V){}});L.on('mousedown',function(){O=0;});L.on('mouseup',function(){O=1;});var P;K.on('mousedown',function(V){if(V.data.$.button==2){var W=D.document.$.selection;if(W.type=='None')P=D.window.getScrollPosition();}T();});K.on('mouseup',function(V){if(V.data.$.button==2&&P){D.document.$.documentElement.scrollLeft=P.x;D.document.$.documentElement.scrollTop=P.y;}P=null;N=1;setTimeout(function(){U(true);},0);});K.on('keydown',T);K.on('keyup',function(){N=1;U();});if(I.$.compatMode!='BackCompat'){if(b.ie7Compat||b.ie6Compat){function Q(V,W,X){try{V.moveToPoint(W,X);}catch(Y){}};L.on('mousedown',function(V){function W(ab){ab=ab.data.$;if(Z){var ac=K.$.createTextRange();Q(ac,ab.x,ab.y);Z.setEndPoint(aa.compareEndPoints('StartToStart',ac)<0?'EndToEnd':'StartToStart',ac);Z.select();}};function X(){J.removeListener('mouseup',Y);L.removeListener('mouseup',Y);};function Y(){L.removeListener('mousemove',W);X();Z.select();};V=V.data;if(V.getTarget().is('html')&&V.$.x<L.$.clientWidth&&V.$.y<L.$.clientHeight){var Z=K.$.createTextRange();Q(Z,V.$.x,V.$.y);var aa=Z.duplicate();L.on('mousemove',W);J.on('mouseup',Y);L.on('mouseup',Y);}});}if(b.ie8){L.on('mousedown',function(V){if(V.data.getTarget().is('html')){J.on('mouseup',S);L.on('mouseup',S);}});function R(){J.removeListener('mouseup',S);L.removeListener('mouseup',S);};function S(){R();var V=a.document.$.selection,W=V.createRange();if(V.type!='None'&&W.parentElement().ownerDocument==I.$)W.select();};}}I.on('selectionchange',U);function T(){N=0;};function U(V){if(N){var W=D.document,X=D.getSelection(),Y=X&&X.getNative();if(V&&Y&&Y.type=='None')if(!W.$.queryCommandEnabled('InsertImage')){e.setTimeout(U,50,this,true);return;}var Z;if(Y&&Y.type&&Y.type!='Control'&&(Z=Y.createRange())&&(Z=Z.parentElement())&&(Z=Z.nodeName)&&Z.toLowerCase() in {input:1,textarea:1})return;try{M=Y&&X.getRanges()[0];}catch(aa){}p.call(D);}};}else{I.on('mouseup',p,D);I.on('keyup',p,D);I.on('selectionchange',p,D);}if(b.webkit)I.on('keydown',function(V){var W=V.data.getKey();switch(W){case 13:case 33:case 34:case 35:case 36:case 37:case 39:case 8:case 45:case 46:w(D.document);}},null,null,-1);});D.on('contentDomUnload',D.forceNextSelectionCheck,D);D.addCommand('selectAll',s);D.ui.addButton('SelectAll',{label:D.lang.selectAll,command:'selectAll'});D.selectionChange=function(I){(I?m:p).call(this);};b.ie9Compat&&D.on('destroy',function(){var I=D.getSelection();I&&I.getNative().clear();},null,null,9);
}});a.editor.prototype.getSelection=function(){return this.document&&this.document.getSelection();};a.editor.prototype.forceNextSelectionCheck=function(){delete this._.selectionPreviousPath;};g.prototype.getSelection=function(){var D=new d.selection(this);return!D||D.isInvalid?null:D;};a.SELECTION_NONE=1;a.SELECTION_TEXT=2;a.SELECTION_ELEMENT=3;d.selection=function(D){var G=this;var E=D.getCustomData('cke_locked_selection');if(E)return E;G.document=D;G.isLocked=0;G._={cache:{}};if(c)try{var F=G.getNative().createRange();if(!F||F.item&&F.item(0).ownerDocument!=G.document.$||F.parentElement&&F.parentElement().ownerDocument!=G.document.$)throw 0;}catch(H){G.isInvalid=true;}return G;};var y={img:1,hr:1,li:1,table:1,tr:1,td:1,th:1,embed:1,object:1,ol:1,ul:1,a:1,input:1,form:1,select:1,textarea:1,button:1,fieldset:1,thead:1,tfoot:1};d.selection.prototype={getNative:c?function(){return this._.cache.nativeSel||(this._.cache.nativeSel=this.document.$.selection);}:function(){return this._.cache.nativeSel||(this._.cache.nativeSel=this.document.getWindow().$.getSelection());},getType:c?function(){var D=this._.cache;if(D.type)return D.type;var E=1;try{var F=this.getNative(),G=F.type;if(G=='Text')E=2;if(G=='Control')E=3;if(F.createRange().parentElement)E=2;}catch(H){}return D.type=E;}:function(){var D=this._.cache;if(D.type)return D.type;var E=2,F=this.getNative();if(!F)E=1;else if(F.rangeCount==1){var G=F.getRangeAt(0),H=G.startContainer;if(H==G.endContainer&&H.nodeType==1&&G.endOffset-G.startOffset==1&&y[H.childNodes[G.startOffset].nodeName.toLowerCase()])E=3;}return D.type=E;},getRanges:(function(){var D=c?(function(){function E(G){return new d.node(G).getIndex();};var F=function(G,H){G=G.duplicate();G.collapse(H);var I=G.parentElement(),J=I.ownerDocument;if(!I.hasChildNodes())return{container:I,offset:0};var K=I.children,L,M,N=G.duplicate(),O=0,P=K.length-1,Q=-1,R,S,T;while(O<=P){Q=Math.floor((O+P)/2);L=K[Q];N.moveToElementText(L);R=N.compareEndPoints('StartToStart',G);if(R>0)P=Q-1;else if(R<0)O=Q+1;else if(b.ie9Compat&&L.tagName=='BR'){var U=J.defaultView.getSelection();return{container:U[H?'anchorNode':'focusNode'],offset:U[H?'anchorOffset':'focusOffset']};}else return{container:I,offset:E(L)};}if(Q==-1||Q==K.length-1&&R<0){N.moveToElementText(I);N.setEndPoint('StartToStart',G);S=N.text.replace(/(\r\n|\r)/g,'\n').length;K=I.childNodes;if(!S){L=K[K.length-1];if(L.nodeType!=3)return{container:I,offset:K.length};else return{container:L,offset:L.nodeValue.length};}var V=K.length;
while(S>0&&V>0){M=K[--V];if(M.nodeType==3){T=M;S-=M.nodeValue.length;}}return{container:T,offset:-S};}else{N.collapse(R>0?true:false);N.setEndPoint(R>0?'StartToStart':'EndToStart',G);S=N.text.replace(/(\r\n|\r)/g,'\n').length;if(!S)return{container:I,offset:E(L)+(R>0?0:1)};while(S>0)try{M=L[R>0?'previousSibling':'nextSibling'];if(M.nodeType==3){S-=M.nodeValue.length;T=M;}L=M;}catch(W){return{container:I,offset:E(L)};}return{container:T,offset:R>0?-S:T.nodeValue.length+S};}};return function(){var Q=this;var G=Q.getNative(),H=G&&G.createRange(),I=Q.getType(),J;if(!G)return[];if(I==2){J=new d.range(Q.document);var K=F(H,true);J.setStart(new d.node(K.container),K.offset);K=F(H);J.setEnd(new d.node(K.container),K.offset);if(J.endContainer.getPosition(J.startContainer)&4&&J.endOffset<=J.startContainer.getIndex())J.collapse();return[J];}else if(I==3){var L=[];for(var M=0;M<H.length;M++){var N=H.item(M),O=N.parentNode,P=0;J=new d.range(Q.document);for(;P<O.childNodes.length&&O.childNodes[P]!=N;P++){}J.setStart(new d.node(O),P);J.setEnd(new d.node(O),P+1);L.push(J);}return L;}return[];};})():function(){var E=[],F,G=this.document,H=this.getNative();if(!H)return E;if(!H.rangeCount){F=new d.range(G);F.moveToElementEditStart(G.getBody());E.push(F);}for(var I=0;I<H.rangeCount;I++){var J=H.getRangeAt(I);F=new d.range(G);F.setStart(new d.node(J.startContainer),J.startOffset);F.setEnd(new d.node(J.endContainer),J.endOffset);E.push(F);}return E;};return function(E){var F=this._.cache;if(F.ranges&&!E)return F.ranges;else if(!F.ranges)F.ranges=new d.rangeList(D.call(this));if(E){var G=F.ranges;for(var H=0;H<G.length;H++){var I=G[H],J=I.getCommonAncestor();if(J.isReadOnly())G.splice(H,1);if(I.collapsed)continue;if(I.startContainer.isReadOnly()){var K=I.startContainer;while(K){if(K.is('body')||!K.isReadOnly())break;if(K.type==1&&K.getAttribute('contentEditable')=='false')I.setStartAfter(K);K=K.getParent();}}var L=I.startContainer,M=I.endContainer,N=I.startOffset,O=I.endOffset,P=I.clone();if(L&&L.type==3)if(N>=L.getLength())P.setStartAfter(L);else P.setStartBefore(L);if(M&&M.type==3)if(!O)P.setEndBefore(M);else P.setEndAfter(M);var Q=new d.walker(P);Q.evaluator=function(R){if(R.type==1&&R.isReadOnly()){var S=I.clone();I.setEndBefore(R);if(I.collapsed)G.splice(H--,1);if(!(R.getPosition(P.endContainer)&16)){S.setStartAfter(R);if(!S.collapsed)G.splice(H+1,0,S);}return true;}return false;};Q.next();}}return F.ranges;};})(),getStartElement:function(){var K=this;var D=K._.cache;if(D.startElement!==undefined)return D.startElement;
var E,F=K.getNative();switch(K.getType()){case 3:return K.getSelectedElement();case 2:var G=K.getRanges()[0];if(G){if(!G.collapsed){G.optimize();while(1){var H=G.startContainer,I=G.startOffset;if(I==(H.getChildCount?H.getChildCount():H.getLength())&&!H.isBlockBoundary())G.setStartAfter(H);else break;}E=G.startContainer;if(E.type!=1)return E.getParent();E=E.getChild(G.startOffset);if(!E||E.type!=1)E=G.startContainer;else{var J=E.getFirst();while(J&&J.type==1){E=J;J=J.getFirst();}}}else{E=G.startContainer;if(E.type!=1)E=E.getParent();}E=E.$;}}return D.startElement=E?new h(E):null;},getSelectedElement:function(){var D=this._.cache;if(D.selectedElement!==undefined)return D.selectedElement;var E=this,F=e.tryThese(function(){return E.getNative().createRange().item(0);},function(){var G,H,I=E.getRanges()[0],J=I.getCommonAncestor(1,1),K={table:1,ul:1,ol:1,dl:1};for(var L in K){if(G=J.getAscendant(L,1))break;}if(G){var M=new d.range(this.document);M.setStartAt(G,1);M.setEnd(I.startContainer,I.startOffset);var N=e.extend(K,f.$listItem,f.$tableContent),O=new d.walker(M),P=function(Q,R){return function(S,T){if(S.type==3&&(!e.trim(S.getText())||S.getParent().data('cke-bookmark')))return true;var U;if(S.type==1){U=S.getName();if(U=='br'&&R&&S.equals(S.getParent().getBogus()))return true;if(T&&U in N||U in f.$removeEmpty)return true;}Q.halted=1;return false;};};O.guard=P(O);if(O.checkBackward()&&!O.halted){O=new d.walker(M);M.setStart(I.endContainer,I.endOffset);M.setEndAt(G,2);O.guard=P(O,1);if(O.checkForward()&&!O.halted)H=G.$;}}if(!H)throw 0;return H;},function(){var G=E.getRanges()[0],H,I;for(var J=2;J&&!((H=G.getEnclosedNode())&&H.type==1&&y[H.getName()]&&(I=H));J--)G.shrink(1);return I.$;});return D.selectedElement=F?new h(F):null;},getSelectedText:function(){var D=this._.cache;if(D.selectedText!==undefined)return D.selectedText;var E='',F=this.getNative();if(this.getType()==2)E=c?F.createRange().text:F.toString();return D.selectedText=E;},lock:function(){var D=this;D.getRanges();D.getStartElement();D.getSelectedElement();D.getSelectedText();D._.cache.nativeSel={};D.isLocked=1;D.document.setCustomData('cke_locked_selection',D);},unlock:function(D){var I=this;var E=I.document,F=E.getCustomData('cke_locked_selection');if(F){E.setCustomData('cke_locked_selection',null);if(D){var G=F.getSelectedElement(),H=!G&&F.getRanges();I.isLocked=0;I.reset();if(G)I.selectElement(G);else I.selectRanges(H);}}if(!F||!D){I.isLocked=0;I.reset();}},reset:function(){this._.cache={};},selectElement:function(D){var F=this;
if(F.isLocked){var E=new d.range(F.document);E.setStartBefore(D);E.setEndAfter(D);F._.cache.selectedElement=D;F._.cache.startElement=D;F._.cache.ranges=new d.rangeList(E);F._.cache.type=3;return;}E=new d.range(D.getDocument());E.setStartBefore(D);E.setEndAfter(D);E.select();F.document.fire('selectionchange');F.reset();},selectRanges:function(D){var R=this;if(R.isLocked){R._.cache.selectedElement=null;R._.cache.startElement=D[0]&&D[0].getTouchedStartNode();R._.cache.ranges=new d.rangeList(D);R._.cache.type=2;return;}if(c){if(D.length>1){var E=D[D.length-1];D[0].setEnd(E.endContainer,E.endOffset);D.length=1;}if(D[0])D[0].select();R.reset();}else{var F=R.getNative();if(!F)return;if(D.length){F.removeAllRanges();b.webkit&&w(R.document);}for(var G=0;G<D.length;G++){if(G<D.length-1){var H=D[G],I=D[G+1],J=H.clone();J.setStart(H.endContainer,H.endOffset);J.setEnd(I.startContainer,I.startOffset);if(!J.collapsed){J.shrink(1,true);var K=J.getCommonAncestor(),L=J.getEnclosedNode();if(K.isReadOnly()||L&&L.isReadOnly()){I.setStart(H.startContainer,H.startOffset);D.splice(G--,1);continue;}}}var M=D[G],N=R.document.$.createRange(),O=M.startContainer;if(M.collapsed&&(b.opera||b.gecko&&b.version<10900)&&O.type==1&&!O.getChildCount())O.appendText('');if(M.collapsed&&b.webkit&&r(M)){var P=t(R.document);M.insertNode(P);var Q=P.getNext();if(Q&&!P.getPrevious()&&Q.type==1&&Q.getName()=='br'){w(R.document);M.moveToPosition(Q,3);}else M.moveToPosition(P,4);}N.setStart(M.startContainer.$,M.startOffset);try{N.setEnd(M.endContainer.$,M.endOffset);}catch(S){if(S.toString().indexOf('NS_ERROR_ILLEGAL_VALUE')>=0){M.collapse(1);N.setEnd(M.endContainer.$,M.endOffset);}else throw S;}F.addRange(N);}R.document.fire('selectionchange');R.reset();}},createBookmarks:function(D){return this.getRanges().createBookmarks(D);},createBookmarks2:function(D){return this.getRanges().createBookmarks2(D);},selectBookmarks:function(D){var E=[];for(var F=0;F<D.length;F++){var G=new d.range(this.document);G.moveToBookmark(D[F]);E.push(G);}this.selectRanges(E);return this;},getCommonAncestor:function(){var D=this.getRanges(),E=D[0].startContainer,F=D[D.length-1].endContainer;return E.getCommonAncestor(F);},scrollIntoView:function(){var D=this.getStartElement();D.scrollIntoView();}};var z=d.walker.whitespaces(true),A=d.walker.invisible(1),B=/\ufeff|\u00a0/,C={table:1,tbody:1,tr:1};d.range.prototype.select=c?function(D){var O=this;var E=O.collapsed,F,G,H,I=O.getEnclosedNode();if(I)try{H=O.document.$.body.createControlRange();
H.addElement(I.$);H.select();return;}catch(P){}if(O.startContainer.type==1&&O.startContainer.getName() in C||O.endContainer.type==1&&O.endContainer.getName() in C)O.shrink(1,true);var J=O.createBookmark(),K=J.startNode,L;if(!E)L=J.endNode;H=O.document.$.body.createTextRange();H.moveToElementText(K.$);H.moveStart('character',1);if(L){var M=O.document.$.body.createTextRange();M.moveToElementText(L.$);H.setEndPoint('EndToEnd',M);H.moveEnd('character',-1);}else{var N=K.getNext(z);F=!(N&&N.getText&&N.getText().match(B))&&(D||!K.hasPrevious()||K.getPrevious().is&&K.getPrevious().is('br'));G=O.document.createElement('span');G.setHtml('&#65279;');G.insertBefore(K);if(F)O.document.createText('\ufeff').insertBefore(K);}O.setStartBefore(K);K.remove();if(E){if(F){H.moveStart('character',-1);H.select();O.document.$.selection.clear();}else H.select();O.moveToPosition(G,3);G.remove();}else{O.setEndBefore(L);L.remove();H.select();}O.document.fire('selectionchange');}:function(){this.document.getSelection().selectRanges([this]);};})();(function(){var m=a.htmlParser.cssStyle,n=e.cssLength,o=/^((?:\d*(?:\.\d+))|(?:\d+))(.*)?$/i;function p(r,s){var t=o.exec(r),u=o.exec(s);if(t){if(!t[2]&&u[2]=='px')return u[1];if(t[2]=='px'&&!u[2])return u[1]+'px';}return s;};var q={elements:{$:function(r){var s=r.attributes,t=s&&s['data-cke-realelement'],u=t&&new a.htmlParser.fragment.fromHtml(decodeURIComponent(t)),v=u&&u.children[0];if(v&&r.attributes['data-cke-resizable']){var w=new m(r).rules,x=v.attributes,y=w.width,z=w.height;y&&(x.width=p(x.width,y));z&&(x.height=p(x.height,z));}return v;}}};j.add('fakeobjects',{requires:['htmlwriter'],afterInit:function(r){var s=r.dataProcessor,t=s&&s.htmlFilter;if(t)t.addRules(q);}});a.editor.prototype.createFakeElement=function(r,s,t,u){var v=this.lang.fakeobjects,w=v[t]||v.unknown,x={'class':s,'data-cke-realelement':encodeURIComponent(r.getOuterHtml()),'data-cke-real-node-type':r.type,alt:w,title:w,align:r.getAttribute('align')||''};if(!b.hc)x.src=a.getUrl('images/spacer.gif');if(t)x['data-cke-real-element-type']=t;if(u){x['data-cke-resizable']=u;var y=new m(),z=r.getAttribute('width'),A=r.getAttribute('height');z&&(y.rules.width=n(z));A&&(y.rules.height=n(A));y.populate(x);}return this.document.createElement('img',{attributes:x});};a.editor.prototype.createFakeParserElement=function(r,s,t,u){var v=this.lang.fakeobjects,w=v[t]||v.unknown,x,y=new a.htmlParser.basicWriter();r.writeHtml(y);x=y.getHtml();var z={'class':s,'data-cke-realelement':encodeURIComponent(x),'data-cke-real-node-type':r.type,alt:w,title:w,align:r.attributes.align||''};
if(!b.hc)z.src=a.getUrl('images/spacer.gif');if(t)z['data-cke-real-element-type']=t;if(u){z['data-cke-resizable']=u;var A=r.attributes,B=new m(),C=A.width,D=A.height;C!=undefined&&(B.rules.width=n(C));D!=undefined&&(B.rules.height=n(D));B.populate(z);}return new a.htmlParser.element('img',z);};a.editor.prototype.restoreRealElement=function(r){if(r.data('cke-real-node-type')!=1)return null;var s=h.createFromHtml(decodeURIComponent(r.data('cke-realelement')),this.document);if(r.data('cke-resizable')){var t=r.getStyle('width'),u=r.getStyle('height');t&&s.setAttribute('width',p(s.getAttribute('width'),t));u&&s.setAttribute('height',p(s.getAttribute('height'),u));}return s;};})();j.add('richcombo',{requires:['floatpanel','listblock','button'],beforeInit:function(m){m.ui.addHandler('richcombo',k.richCombo.handler);}});a.UI_RICHCOMBO='richcombo';k.richCombo=e.createClass({$:function(m){var o=this;e.extend(o,m,{title:m.label,modes:{wysiwyg:1}});var n=o.panel||{};delete o.panel;o.id=e.getNextNumber();o.document=n&&n.parent&&n.parent.getDocument()||a.document;n.className=(n.className||'')+' cke_rcombopanel';n.block={multiSelect:n.multiSelect,attributes:n.attributes};o._={panelDefinition:n,items:{},state:2};},statics:{handler:{create:function(m){return new k.richCombo(m);}}},proto:{renderHtml:function(m){var n=[];this.render(m,n);return n.join('');},render:function(m,n){var o=b,p='cke_'+this.id,q=e.addFunction(function(v){var y=this;var w=y._;if(w.state==0)return;y.createPanel(m);if(w.on){w.panel.hide();return;}y.commit();var x=y.getValue();if(x)w.list.mark(x);else w.list.unmarkAll();w.panel.showBlock(y.id,new h(v),4);},this),r={id:p,combo:this,focus:function(){var v=a.document.getById(p).getChild(1);v.focus();},clickFn:q};function s(){var w=this;var v=w.modes[m.mode]?2:0;w.setState(m.readOnly&&!w.readOnly?0:v);w.setValue('');};m.on('mode',s,this);!this.readOnly&&m.on('readOnly',s,this);var t=e.addFunction(function(v,w){v=new d.event(v);var x=v.getKeystroke();switch(x){case 13:case 32:case 40:e.callFunction(q,w);break;default:r.onkey(r,x);}v.preventDefault();}),u=e.addFunction(function(){r.onfocus&&r.onfocus();});r.keyDownFn=t;n.push('<span class="cke_rcombo" role="presentation">','<span id=',p);if(this.className)n.push(' class="',this.className,' cke_off"');n.push(' role="presentation">','<span id="'+p+'_label" class=cke_label>',this.label,'</span>','<a hidefocus=true title="',this.title,'" tabindex="-1"',o.gecko&&o.version>=10900&&!o.hc?'':" href=\"javascript:void('"+this.label+"')\"",' role="button" aria-labelledby="',p,'_label" aria-describedby="',p,'_text" aria-haspopup="true"');
if(b.opera||b.gecko&&b.mac)n.push(' onkeypress="return false;"');if(b.gecko)n.push(' onblur="this.style.cssText = this.style.cssText;"');n.push(' onkeydown="CKEDITOR.tools.callFunction( ',t,', event, this );" onfocus="return CKEDITOR.tools.callFunction(',u,', event);" '+(c?'onclick="return false;" onmouseup':'onclick')+'="CKEDITOR.tools.callFunction(',q,', this); return false;"><span><span id="'+p+'_text" class="cke_text cke_inline_label">'+this.label+'</span>'+'</span>'+'<span class=cke_openbutton><span class=cke_icon>'+(b.hc?'&#9660;':b.air?'&nbsp;':'')+'</span></span>'+'</a>'+'</span>'+'</span>');if(this.onRender)this.onRender();return r;},createPanel:function(m){if(this._.panel)return;var n=this._.panelDefinition,o=this._.panelDefinition.block,p=n.parent||a.document.getBody(),q=new k.floatPanel(m,p,n),r=q.addListBlock(this.id,o),s=this;q.onShow=function(){if(s.className)this.element.getFirst().addClass(s.className+'_panel');s.setState(1);r.focus(!s.multiSelect&&s.getValue());s._.on=1;if(s.onOpen)s.onOpen();};q.onHide=function(t){if(s.className)this.element.getFirst().removeClass(s.className+'_panel');s.setState(s.modes&&s.modes[m.mode]?2:0);s._.on=0;if(!t&&s.onClose)s.onClose();};q.onEscape=function(){q.hide();};r.onClick=function(t,u){s.document.getWindow().focus();if(s.onClick)s.onClick.call(s,t,u);if(u)s.setValue(t,s._.items[t]);else s.setValue('');q.hide(false);};this._.panel=q;this._.list=r;q.getBlock(this.id).onHide=function(){s._.on=0;s.setState(2);};if(this.init)this.init();},setValue:function(m,n){var p=this;p._.value=m;var o=p.document.getById('cke_'+p.id+'_text');if(o){if(!(m||n)){n=p.label;o.addClass('cke_inline_label');}else o.removeClass('cke_inline_label');o.setHtml(typeof n!='undefined'?n:m);}},getValue:function(){return this._.value||'';},unmarkAll:function(){this._.list.unmarkAll();},mark:function(m){this._.list.mark(m);},hideItem:function(m){this._.list.hideItem(m);},hideGroup:function(m){this._.list.hideGroup(m);},showAll:function(){this._.list.showAll();},add:function(m,n,o){this._.items[m]=o||m;this._.list.add(m,n,o);},startGroup:function(m){this._.list.startGroup(m);},commit:function(){var m=this;if(!m._.committed){m._.list.commit();m._.committed=1;k.fire('ready',m);}m._.committed=1;},setState:function(m){var n=this;if(n._.state==m)return;n.document.getById('cke_'+n.id).setState(m);n._.state=m;}}});k.prototype.addRichCombo=function(m,n){this.add(m,'richcombo',n);};j.add('htmlwriter');a.htmlWriter=e.createClass({base:a.htmlParser.basicWriter,$:function(){var o=this;
o.base();o.indentationChars='\t';o.selfClosingEnd=' />';o.lineBreakChars='\n';o.forceSimpleAmpersand=0;o.sortAttributes=1;o._.indent=0;o._.indentation='';o._.inPre=0;o._.rules={};var m=f;for(var n in e.extend({},m.$nonBodyContent,m.$block,m.$listItem,m.$tableContent))o.setRules(n,{indent:1,breakBeforeOpen:1,breakAfterOpen:1,breakBeforeClose:!m[n]['#'],breakAfterClose:1});o.setRules('br',{breakAfterOpen:1});o.setRules('title',{indent:0,breakAfterOpen:0});o.setRules('style',{indent:0,breakBeforeClose:1});o.setRules('pre',{indent:0});},proto:{openTag:function(m,n){var p=this;var o=p._.rules[m];if(p._.indent)p.indentation();else if(o&&o.breakBeforeOpen){p.lineBreak();p.indentation();}p._.output.push('<',m);},openTagClose:function(m,n){var p=this;var o=p._.rules[m];if(n)p._.output.push(p.selfClosingEnd);else{p._.output.push('>');if(o&&o.indent)p._.indentation+=p.indentationChars;}if(o&&o.breakAfterOpen)p.lineBreak();m=='pre'&&(p._.inPre=1);},attribute:function(m,n){if(typeof n=='string'){this.forceSimpleAmpersand&&(n=n.replace(/&amp;/g,'&'));n=e.htmlEncodeAttr(n);}this._.output.push(' ',m,'="',n,'"');},closeTag:function(m){var o=this;var n=o._.rules[m];if(n&&n.indent)o._.indentation=o._.indentation.substr(o.indentationChars.length);if(o._.indent)o.indentation();else if(n&&n.breakBeforeClose){o.lineBreak();o.indentation();}o._.output.push('</',m,'>');m=='pre'&&(o._.inPre=0);if(n&&n.breakAfterClose)o.lineBreak();},text:function(m){var n=this;if(n._.indent){n.indentation();!n._.inPre&&(m=e.ltrim(m));}n._.output.push(m);},comment:function(m){if(this._.indent)this.indentation();this._.output.push('<!--',m,'-->');},lineBreak:function(){var m=this;if(!m._.inPre&&m._.output.length>0)m._.output.push(m.lineBreakChars);m._.indent=1;},indentation:function(){var m=this;if(!m._.inPre)m._.output.push(m._.indentation);m._.indent=0;},setRules:function(m,n){var o=this._.rules[m];if(o)e.extend(o,n,true);else this._.rules[m]=n;}}});j.add('menubutton',{requires:['button','menu'],beforeInit:function(m){m.ui.addHandler('menubutton',k.menuButton.handler);}});a.UI_MENUBUTTON='menubutton';(function(){var m=function(n){var o=this._;if(o.state===0)return;o.previousState=o.state;var p=o.menu;if(!p){p=o.menu=new a.menu(n,{panel:{className:n.skinClass+' cke_contextmenu',attributes:{'aria-label':n.lang.common.options}}});p.onHide=e.bind(function(){this.setState(this.modes&&this.modes[n.mode]?o.previousState:0);},this);if(this.onMenu)p.addListener(this.onMenu);}if(o.on){p.hide();return;}this.setState(1);
p.show(a.document.getById(this._.id),4);};k.menuButton=e.createClass({base:k.button,$:function(n){var o=n.panel;delete n.panel;this.base(n);this.hasArrow=true;this.click=m;},statics:{handler:{create:function(n){return new k.menuButton(n);}}}});})();j.add('dialogui');(function(){var m=function(u){var x=this;x._||(x._={});x._['default']=x._.initValue=u['default']||'';x._.required=u.required||false;var v=[x._];for(var w=1;w<arguments.length;w++)v.push(arguments[w]);v.push(true);e.extend.apply(e,v);return x._;},n={build:function(u,v,w){return new k.dialog.textInput(u,v,w);}},o={build:function(u,v,w){return new k.dialog[v.type](u,v,w);}},p={build:function(u,v,w){var x=v.children,y,z=[],A=[];for(var B=0;B<x.length&&(y=x[B]);B++){var C=[];z.push(C);A.push(a.dialog._.uiElementBuilders[y.type].build(u,y,C));}return new k.dialog[v.type](u,A,z,w,v);}},q={isChanged:function(){return this.getValue()!=this.getInitValue();},reset:function(u){this.setValue(this.getInitValue(),u);},setInitValue:function(){this._.initValue=this.getValue();},resetInitValue:function(){this._.initValue=this._['default'];},getInitValue:function(){return this._.initValue;}},r=e.extend({},k.dialog.uiElement.prototype.eventProcessors,{onChange:function(u,v){if(!this._.domOnChangeRegistered){u.on('load',function(){this.getInputElement().on('change',function(){if(!u.parts.dialog.isVisible())return;this.fire('change',{value:this.getValue()});},this);},this);this._.domOnChangeRegistered=true;}this.on('change',v);}},true),s=/^on([A-Z]\w+)/,t=function(u){for(var v in u){if(s.test(v)||v=='title'||v=='type')delete u[v];}return u;};e.extend(k.dialog,{labeledElement:function(u,v,w,x){if(arguments.length<4)return;var y=m.call(this,v);y.labelId=e.getNextId()+'_label';var z=this._.children=[],A=function(){var B=[],C=v.required?' cke_required':'';if(v.labelLayout!='horizontal')B.push('<label class="cke_dialog_ui_labeled_label'+C+'" ',' id="'+y.labelId+'"',y.inputId?' for="'+y.inputId+'"':'',(v.labelStyle?' style="'+v.labelStyle+'"':'')+'>',v.label,'</label>','<div class="cke_dialog_ui_labeled_content"'+(v.controlStyle?' style="'+v.controlStyle+'"':'')+' role="presentation">',x.call(this,u,v),'</div>');else{var D={type:'hbox',widths:v.widths,padding:0,children:[{type:'html',html:'<label class="cke_dialog_ui_labeled_label'+C+'"'+' id="'+y.labelId+'"'+' for="'+y.inputId+'"'+(v.labelStyle?' style="'+v.labelStyle+'"':'')+'>'+e.htmlEncode(v.label)+'</span>'},{type:'html',html:'<span class="cke_dialog_ui_labeled_content"'+(v.controlStyle?' style="'+v.controlStyle+'"':'')+'>'+x.call(this,u,v)+'</span>'}]};
a.dialog._.uiElementBuilders.hbox.build(u,D,B);}return B.join('');};k.dialog.uiElement.call(this,u,v,w,'div',null,{role:'presentation'},A);},textInput:function(u,v,w){if(arguments.length<3)return;m.call(this,v);var x=this._.inputId=e.getNextId()+'_textInput',y={'class':'cke_dialog_ui_input_'+v.type,id:x,type:v.type},z;if(v.validate)this.validate=v.validate;if(v.maxLength)y.maxlength=v.maxLength;if(v.size)y.size=v.size;if(v.inputStyle)y.style=v.inputStyle;var A=function(){var B=['<div class="cke_dialog_ui_input_',v.type,'" role="presentation"'];if(v.width)B.push('style="width:'+v.width+'" ');B.push('><input ');y['aria-labelledby']=this._.labelId;this._.required&&(y['aria-required']=this._.required);for(var C in y)B.push(C+'="'+y[C]+'" ');B.push(' /></div>');return B.join('');};k.dialog.labeledElement.call(this,u,v,w,A);},textarea:function(u,v,w){if(arguments.length<3)return;m.call(this,v);var x=this,y=this._.inputId=e.getNextId()+'_textarea',z={};if(v.validate)this.validate=v.validate;z.rows=v.rows||5;z.cols=v.cols||20;if(typeof v.inputStyle!='undefined')z.style=v.inputStyle;var A=function(){z['aria-labelledby']=this._.labelId;this._.required&&(z['aria-required']=this._.required);var B=['<div class="cke_dialog_ui_input_textarea" role="presentation"><textarea class="cke_dialog_ui_input_textarea" id="',y,'" '];for(var C in z)B.push(C+'="'+e.htmlEncode(z[C])+'" ');B.push('>',e.htmlEncode(x._['default']),'</textarea></div>');return B.join('');};k.dialog.labeledElement.call(this,u,v,w,A);},checkbox:function(u,v,w){if(arguments.length<3)return;var x=m.call(this,v,{'default':!!v['default']});if(v.validate)this.validate=v.validate;var y=function(){var z=e.extend({},v,{id:v.id?v.id+'_checkbox':e.getNextId()+'_checkbox'},true),A=[],B=e.getNextId()+'_label',C={'class':'cke_dialog_ui_checkbox_input',type:'checkbox','aria-labelledby':B};t(z);if(v['default'])C.checked='checked';if(typeof z.inputStyle!='undefined')z.style=z.inputStyle;x.checkbox=new k.dialog.uiElement(u,z,A,'input',null,C);A.push(' <label id="',B,'" for="',C.id,'"'+(v.labelStyle?' style="'+v.labelStyle+'"':'')+'>',e.htmlEncode(v.label),'</label>');return A.join('');};k.dialog.uiElement.call(this,u,v,w,'span',null,null,y);},radio:function(u,v,w){if(arguments.length<3)return;m.call(this,v);if(!this._['default'])this._['default']=this._.initValue=v.items[0][1];if(v.validate)this.validate=v.valdiate;var x=[],y=this,z=function(){var A=[],B=[],C={'class':'cke_dialog_ui_radio_item','aria-labelledby':this._.labelId},D=v.id?v.id+'_radio':e.getNextId()+'_radio';
for(var E=0;E<v.items.length;E++){var F=v.items[E],G=F[2]!==undefined?F[2]:F[0],H=F[1]!==undefined?F[1]:F[0],I=e.getNextId()+'_radio_input',J=I+'_label',K=e.extend({},v,{id:I,title:null,type:null},true),L=e.extend({},K,{title:G},true),M={type:'radio','class':'cke_dialog_ui_radio_input',name:D,value:H,'aria-labelledby':J},N=[];if(y._['default']==H)M.checked='checked';t(K);t(L);if(typeof K.inputStyle!='undefined')K.style=K.inputStyle;x.push(new k.dialog.uiElement(u,K,N,'input',null,M));N.push(' ');new k.dialog.uiElement(u,L,N,'label',null,{id:J,'for':M.id},F[0]);A.push(N.join(''));}new k.dialog.hbox(u,x,A,B);return B.join('');};k.dialog.labeledElement.call(this,u,v,w,z);this._.children=x;},button:function(u,v,w){if(!arguments.length)return;if(typeof v=='function')v=v(u.getParentEditor());m.call(this,v,{disabled:v.disabled||false});a.event.implementOn(this);var x=this;u.on('load',function(A){var B=this.getElement();(function(){B.on('click',function(C){x.fire('click',{dialog:x.getDialog()});C.data.preventDefault();});B.on('keydown',function(C){if(C.data.getKeystroke() in {32:1}){x.click();C.data.preventDefault();}});})();B.unselectable();},this);var y=e.extend({},v);delete y.style;var z=e.getNextId()+'_label';k.dialog.uiElement.call(this,u,y,w,'a',null,{style:v.style,href:'javascript:void(0)',title:v.label,hidefocus:'true','class':v['class'],role:'button','aria-labelledby':z},'<span id="'+z+'" class="cke_dialog_ui_button">'+e.htmlEncode(v.label)+'</span>');},select:function(u,v,w){if(arguments.length<3)return;var x=m.call(this,v);if(v.validate)this.validate=v.validate;x.inputId=e.getNextId()+'_select';var y=function(){var z=e.extend({},v,{id:v.id?v.id+'_select':e.getNextId()+'_select'},true),A=[],B=[],C={id:x.inputId,'class':'cke_dialog_ui_input_select','aria-labelledby':this._.labelId};if(v.size!=undefined)C.size=v.size;if(v.multiple!=undefined)C.multiple=v.multiple;t(z);for(var D=0,E;D<v.items.length&&(E=v.items[D]);D++)B.push('<option value="',e.htmlEncode(E[1]!==undefined?E[1]:E[0]).replace(/"/g,'&quot;'),'" /> ',e.htmlEncode(E[0]));if(typeof z.inputStyle!='undefined')z.style=z.inputStyle;x.select=new k.dialog.uiElement(u,z,A,'select',null,C,B.join(''));return A.join('');};k.dialog.labeledElement.call(this,u,v,w,y);},file:function(u,v,w){if(arguments.length<3)return;if(v['default']===undefined)v['default']='';var x=e.extend(m.call(this,v),{definition:v,buttons:[]});if(v.validate)this.validate=v.validate;var y=function(){x.frameId=e.getNextId()+'_fileInput';
var z=b.isCustomDomain(),A=['<iframe frameborder="0" allowtransparency="0" class="cke_dialog_ui_input_file" role="presentation" id="',x.frameId,'" title="',v.label,'" src="javascript:void('];A.push(z?"(function(){document.open();document.domain='"+document.domain+"';"+'document.close();'+'})()':'0');A.push(')"></iframe>');return A.join('');};u.on('load',function(){var z=a.document.getById(x.frameId),A=z.getParent();A.addClass('cke_dialog_ui_input_file');});k.dialog.labeledElement.call(this,u,v,w,y);},fileButton:function(u,v,w){if(arguments.length<3)return;var x=m.call(this,v),y=this;if(v.validate)this.validate=v.validate;var z=e.extend({},v),A=z.onClick;z.className=(z.className?z.className+' ':'')+'cke_dialog_ui_button';z.onClick=function(B){var C=v['for'];if(!A||A.call(this,B)!==false){u.getContentElement(C[0],C[1]).submit();this.disable();}};u.on('load',function(){u.getContentElement(v['for'][0],v['for'][1])._.buttons.push(y);});k.dialog.button.call(this,u,z,w);},html:(function(){var u=/^\s*<[\w:]+\s+([^>]*)?>/,v=/^(\s*<[\w:]+(?:\s+[^>]*)?)((?:.|\r|\n)+)$/,w=/\/$/;return function(x,y,z){if(arguments.length<3)return;var A=[],B,C=y.html,D,E;if(C.charAt(0)!='<')C='<span>'+C+'</span>';var F=y.focus;if(F){var G=this.focus;this.focus=function(){G.call(this);typeof F=='function'&&F.call(this);this.fire('focus');};if(y.isFocusable){var H=this.isFocusable;this.isFocusable=H;}this.keyboardFocusable=true;}k.dialog.uiElement.call(this,x,y,A,'span',null,null,'');B=A.join('');D=B.match(u);E=C.match(v)||['','',''];if(w.test(E[1])){E[1]=E[1].slice(0,-1);E[2]='/'+E[2];}z.push([E[1],' ',D[1]||'',E[2]].join(''));};})(),fieldset:function(u,v,w,x,y){var z=y.label,A=function(){var B=[];z&&B.push('<legend'+(y.labelStyle?' style="'+y.labelStyle+'"':'')+'>'+z+'</legend>');for(var C=0;C<w.length;C++)B.push(w[C]);return B.join('');};this._={children:v};k.dialog.uiElement.call(this,u,y,x,'fieldset',null,null,A);}},true);k.dialog.html.prototype=new k.dialog.uiElement();k.dialog.labeledElement.prototype=e.extend(new k.dialog.uiElement(),{setLabel:function(u){var v=a.document.getById(this._.labelId);if(v.getChildCount()<1)new d.text(u,a.document).appendTo(v);else v.getChild(0).$.nodeValue=u;return this;},getLabel:function(){var u=a.document.getById(this._.labelId);if(!u||u.getChildCount()<1)return '';else return u.getChild(0).getText();},eventProcessors:r},true);k.dialog.button.prototype=e.extend(new k.dialog.uiElement(),{click:function(){var u=this;if(!u._.disabled)return u.fire('click',{dialog:u._.dialog});
u.getElement().$.blur();return false;},enable:function(){this._.disabled=false;var u=this.getElement();u&&u.removeClass('cke_disabled');},disable:function(){this._.disabled=true;this.getElement().addClass('cke_disabled');},isVisible:function(){return this.getElement().getFirst().isVisible();},isEnabled:function(){return!this._.disabled;},eventProcessors:e.extend({},k.dialog.uiElement.prototype.eventProcessors,{onClick:function(u,v){this.on('click',function(){this.getElement().focus();v.apply(this,arguments);});}},true),accessKeyUp:function(){this.click();},accessKeyDown:function(){this.focus();},keyboardFocusable:true},true);k.dialog.textInput.prototype=e.extend(new k.dialog.labeledElement(),{getInputElement:function(){return a.document.getById(this._.inputId);},focus:function(){var u=this.selectParentTab();setTimeout(function(){var v=u.getInputElement();v&&v.$.focus();},0);},select:function(){var u=this.selectParentTab();setTimeout(function(){var v=u.getInputElement();if(v){v.$.focus();v.$.select();}},0);},accessKeyUp:function(){this.select();},setValue:function(u){!u&&(u='');return k.dialog.uiElement.prototype.setValue.apply(this,arguments);},keyboardFocusable:true},q,true);k.dialog.textarea.prototype=new k.dialog.textInput();k.dialog.select.prototype=e.extend(new k.dialog.labeledElement(),{getInputElement:function(){return this._.select.getElement();},add:function(u,v,w){var x=new h('option',this.getDialog().getParentEditor().document),y=this.getInputElement().$;x.$.text=u;x.$.value=v===undefined||v===null?u:v;if(w===undefined||w===null){if(c)y.add(x.$);else y.add(x.$,null);}else y.add(x.$,w);return this;},remove:function(u){var v=this.getInputElement().$;v.remove(u);return this;},clear:function(){var u=this.getInputElement().$;while(u.length>0)u.remove(0);return this;},keyboardFocusable:true},q,true);k.dialog.checkbox.prototype=e.extend(new k.dialog.uiElement(),{getInputElement:function(){return this._.checkbox.getElement();},setValue:function(u,v){this.getInputElement().$.checked=u;!v&&this.fire('change',{value:u});},getValue:function(){return this.getInputElement().$.checked;},accessKeyUp:function(){this.setValue(!this.getValue());},eventProcessors:{onChange:function(u,v){if(!c)return r.onChange.apply(this,arguments);else{u.on('load',function(){var w=this._.checkbox.getElement();w.on('propertychange',function(x){x=x.data.$;if(x.propertyName=='checked')this.fire('change',{value:w.$.checked});},this);},this);this.on('change',v);}return null;}},keyboardFocusable:true},q,true);
k.dialog.radio.prototype=e.extend(new k.dialog.uiElement(),{setValue:function(u,v){var w=this._.children,x;for(var y=0;y<w.length&&(x=w[y]);y++)x.getElement().$.checked=x.getValue()==u;!v&&this.fire('change',{value:u});},getValue:function(){var u=this._.children;for(var v=0;v<u.length;v++){if(u[v].getElement().$.checked)return u[v].getValue();}return null;},accessKeyUp:function(){var u=this._.children,v;for(v=0;v<u.length;v++){if(u[v].getElement().$.checked){u[v].getElement().focus();return;}}u[0].getElement().focus();},eventProcessors:{onChange:function(u,v){if(!c)return r.onChange.apply(this,arguments);else{u.on('load',function(){var w=this._.children,x=this;for(var y=0;y<w.length;y++){var z=w[y].getElement();z.on('propertychange',function(A){A=A.data.$;if(A.propertyName=='checked'&&this.$.checked)x.fire('change',{value:this.getAttribute('value')});});}},this);this.on('change',v);}return null;}},keyboardFocusable:true},q,true);k.dialog.file.prototype=e.extend(new k.dialog.labeledElement(),q,{getInputElement:function(){var u=a.document.getById(this._.frameId).getFrameDocument();return u.$.forms.length>0?new h(u.$.forms[0].elements[0]):this.getElement();},submit:function(){this.getInputElement().getParent().$.submit();return this;},getAction:function(){return this.getInputElement().getParent().$.action;},registerEvents:function(u){var v=/^on([A-Z]\w+)/,w,x=function(z,A,B,C){z.on('formLoaded',function(){z.getInputElement().on(B,C,z);});};for(var y in u){if(!(w=y.match(v)))continue;if(this.eventProcessors[y])this.eventProcessors[y].call(this,this._.dialog,u[y]);else x(this,this._.dialog,w[1].toLowerCase(),u[y]);}return this;},reset:function(){var u=this._,v=a.document.getById(u.frameId),w=v.getFrameDocument(),x=u.definition,y=u.buttons,z=this.formLoadedNumber,A=this.formUnloadNumber,B=u.dialog._.editor.lang.dir,C=u.dialog._.editor.langCode;if(!z){z=this.formLoadedNumber=e.addFunction(function(){this.fire('formLoaded');},this);A=this.formUnloadNumber=e.addFunction(function(){this.getInputElement().clearCustomData();},this);this.getDialog()._.editor.on('destroy',function(){e.removeFunction(z);e.removeFunction(A);});}function D(){w.$.open();if(b.isCustomDomain())w.$.domain=document.domain;var E='';if(x.size)E=x.size-(c?7:0);var F=u.frameId+'_input';w.$.write(['<html dir="'+B+'" lang="'+C+'"><head><title></title></head><body style="margin: 0; overflow: hidden; background: transparent;">','<form enctype="multipart/form-data" method="POST" dir="'+B+'" lang="'+C+'" action="',e.htmlEncode(x.action),'">','<label id="',u.labelId,'" for="',F,'" style="display:none">',e.htmlEncode(x.label),'</label>','<input id="',F,'" aria-labelledby="',u.labelId,'" type="file" name="',e.htmlEncode(x.id||'cke_upload'),'" size="',e.htmlEncode(E>0?E:''),'" />','</form>','</body></html>','<script>window.parent.CKEDITOR.tools.callFunction('+z+');','window.onbeforeunload = function() {window.parent.CKEDITOR.tools.callFunction('+A+')}</script>'].join(''));
w.$.close();for(var G=0;G<y.length;G++)y[G].enable();};if(b.gecko)setTimeout(D,500);else D();},getValue:function(){return this.getInputElement().$.value||'';},setInitValue:function(){this._.initValue='';},eventProcessors:{onChange:function(u,v){if(!this._.domOnChangeRegistered){this.on('formLoaded',function(){this.getInputElement().on('change',function(){this.fire('change',{value:this.getValue()});},this);},this);this._.domOnChangeRegistered=true;}this.on('change',v);}},keyboardFocusable:true},true);k.dialog.fileButton.prototype=new k.dialog.button();k.dialog.fieldset.prototype=e.clone(k.dialog.hbox.prototype);a.dialog.addUIElement('text',n);a.dialog.addUIElement('password',n);a.dialog.addUIElement('textarea',o);a.dialog.addUIElement('checkbox',o);a.dialog.addUIElement('radio',o);a.dialog.addUIElement('button',o);a.dialog.addUIElement('select',o);a.dialog.addUIElement('file',o);a.dialog.addUIElement('fileButton',o);a.dialog.addUIElement('html',o);a.dialog.addUIElement('fieldset',p);})();j.add('panel',{beforeInit:function(m){m.ui.addHandler('panel',k.panel.handler);}});a.UI_PANEL='panel';k.panel=function(m,n){var o=this;if(n)e.extend(o,n);e.extend(o,{className:'',css:[]});o.id=e.getNextId();o.document=m;o._={blocks:{}};};k.panel.handler={create:function(m){return new k.panel(m);}};k.panel.prototype={renderHtml:function(m){var n=[];this.render(m,n);return n.join('');},render:function(m,n){var p=this;var o=p.id;n.push('<div class="',m.skinClass,'" lang="',m.langCode,'" role="presentation" style="display:none;z-index:'+(m.config.baseFloatZIndex+1)+'">'+'<div'+' id=',o,' dir=',m.lang.dir,' role="presentation" class="cke_panel cke_',m.lang.dir);if(p.className)n.push(' ',p.className);n.push('">');if(p.forceIFrame||p.css.length){n.push('<iframe id="',o,'_frame" frameborder="0" role="application" src="javascript:void(');n.push(b.isCustomDomain()?"(function(){document.open();document.domain='"+document.domain+"';"+'document.close();'+'})()':'0');n.push(')"></iframe>');}n.push('</div></div>');return o;},getHolderElement:function(){var m=this._.holder;if(!m){if(this.forceIFrame||this.css.length){var n=this.document.getById(this.id+'_frame'),o=n.getParent(),p=o.getAttribute('dir'),q=o.getParent().getAttribute('class'),r=o.getParent().getAttribute('lang'),s=n.getFrameDocument();b.iOS&&o.setStyles({overflow:'scroll','-webkit-overflow-scrolling':'touch'});var t=e.addFunction(e.bind(function(w){this.isLoaded=true;if(this.onLoad)this.onLoad();},this)),u='<!DOCTYPE html><html dir="'+p+'" class="'+q+'_container" lang="'+r+'">'+'<head>'+'<style>.'+q+'_container{visibility:hidden}</style>'+e.buildStyleHtml(this.css)+'</head>'+'<body class="cke_'+p+' cke_panel_frame '+b.cssClass+'" style="margin:0;padding:0"'+' onload="( window.CKEDITOR || window.parent.CKEDITOR ).tools.callFunction('+t+');"></body>'+'</html>';
s.write(u);var v=s.getWindow();v.$.CKEDITOR=a;s.on('key'+(b.opera?'press':'down'),function(w){var z=this;var x=w.data.getKeystroke(),y=z.document.getById(z.id).getAttribute('dir');if(z._.onKeyDown&&z._.onKeyDown(x)===false){w.data.preventDefault();return;}if(x==27||x==(y=='rtl'?39:37))if(z.onEscape&&z.onEscape(x)===false)w.data.preventDefault();},this);m=s.getBody();m.unselectable();b.air&&e.callFunction(t);}else m=this.document.getById(this.id);this._.holder=m;}return m;},addBlock:function(m,n){var o=this;n=o._.blocks[m]=n instanceof k.panel.block?n:new k.panel.block(o.getHolderElement(),n);if(!o._.currentBlock)o.showBlock(m);return n;},getBlock:function(m){return this._.blocks[m];},showBlock:function(m){var r=this;var n=r._.blocks,o=n[m],p=r._.currentBlock,q=!r.forceIFrame||c?r._.holder:r.document.getById(r.id+'_frame');if(p){q.removeAttributes(p.attributes);p.hide();}r._.currentBlock=o;q.setAttributes(o.attributes);a.fire('ariaWidget',q);o._.focusIndex=-1;r._.onKeyDown=o.onKeyDown&&e.bind(o.onKeyDown,o);o.show();return o;},destroy:function(){this.element&&this.element.remove();}};k.panel.block=e.createClass({$:function(m,n){var o=this;o.element=m.append(m.getDocument().createElement('div',{attributes:{tabIndex:-1,'class':'cke_panel_block',role:'presentation'},styles:{display:'none'}}));if(n)e.extend(o,n);if(!o.attributes.title)o.attributes.title=o.attributes['aria-label'];o.keys={};o._.focusIndex=-1;o.element.disableContextMenu();},_:{markItem:function(m){var p=this;if(m==-1)return;var n=p.element.getElementsByTag('a'),o=n.getItem(p._.focusIndex=m);if(b.webkit||b.opera)o.getDocument().getWindow().focus();o.focus();p.onMark&&p.onMark(o);}},proto:{show:function(){this.element.setStyle('display','');},hide:function(){var m=this;if(!m.onHide||m.onHide.call(m)!==true)m.element.setStyle('display','none');},onKeyDown:function(m){var r=this;var n=r.keys[m];switch(n){case 'next':var o=r._.focusIndex,p=r.element.getElementsByTag('a'),q;while(q=p.getItem(++o)){if(q.getAttribute('_cke_focus')&&q.$.offsetWidth){r._.focusIndex=o;q.focus();break;}}return false;case 'prev':o=r._.focusIndex;p=r.element.getElementsByTag('a');while(o>0&&(q=p.getItem(--o))){if(q.getAttribute('_cke_focus')&&q.$.offsetWidth){r._.focusIndex=o;q.focus();break;}}return false;case 'click':case 'mouseup':o=r._.focusIndex;q=o>=0&&r.element.getElementsByTag('a').getItem(o);if(q)q.$[n]?q.$[n]():q.$['on'+n]();return false;}return true;}}});j.add('listblock',{requires:['panel'],onLoad:function(){k.panel.prototype.addListBlock=function(m,n){return this.addBlock(m,new k.listBlock(this.getHolderElement(),n));
};k.listBlock=e.createClass({base:k.panel.block,$:function(m,n){var q=this;n=n||{};var o=n.attributes||(n.attributes={});(q.multiSelect=!!n.multiSelect)&&(o['aria-multiselectable']=true);!o.role&&(o.role='listbox');q.base.apply(q,arguments);var p=q.keys;p[40]='next';p[9]='next';p[38]='prev';p[2228224+9]='prev';p[32]=c?'mouseup':'click';c&&(p[13]='mouseup');q._.pendingHtml=[];q._.items={};q._.groups={};},_:{close:function(){if(this._.started){this._.pendingHtml.push('</ul>');delete this._.started;}},getClick:function(){if(!this._.click)this._.click=e.addFunction(function(m){var o=this;var n=true;if(o.multiSelect)n=o.toggle(m);else o.mark(m);if(o.onClick)o.onClick(m,n);},this);return this._.click;}},proto:{add:function(m,n,o){var r=this;var p=r._.pendingHtml,q=e.getNextId();if(!r._.started){p.push('<ul role="presentation" class=cke_panel_list>');r._.started=1;r._.size=r._.size||0;}r._.items[m]=q;p.push('<li id=',q,' class=cke_panel_listItem role=presentation><a id="',q,'_option" _cke_focus=1 hidefocus=true title="',o||m,'" href="javascript:void(\'',m,"')\" "+(c?'onclick="return false;" onmouseup':'onclick')+'="CKEDITOR.tools.callFunction(',r._.getClick(),",'",m,"'); return false;\"",' role="option">',n||m,'</a></li>');},startGroup:function(m){this._.close();var n=e.getNextId();this._.groups[m]=n;this._.pendingHtml.push('<h1 role="presentation" id=',n,' class=cke_panel_grouptitle>',m,'</h1>');},commit:function(){var m=this;m._.close();m.element.appendHtml(m._.pendingHtml.join(''));delete m._.size;m._.pendingHtml=[];},toggle:function(m){var n=this.isMarked(m);if(n)this.unmark(m);else this.mark(m);return!n;},hideGroup:function(m){var n=this.element.getDocument().getById(this._.groups[m]),o=n&&n.getNext();if(n){n.setStyle('display','none');if(o&&o.getName()=='ul')o.setStyle('display','none');}},hideItem:function(m){this.element.getDocument().getById(this._.items[m]).setStyle('display','none');},showAll:function(){var m=this._.items,n=this._.groups,o=this.element.getDocument();for(var p in m)o.getById(m[p]).setStyle('display','');for(var q in n){var r=o.getById(n[q]),s=r.getNext();r.setStyle('display','');if(s&&s.getName()=='ul')s.setStyle('display','');}},mark:function(m){var p=this;if(!p.multiSelect)p.unmarkAll();var n=p._.items[m],o=p.element.getDocument().getById(n);o.addClass('cke_selected');p.element.getDocument().getById(n+'_option').setAttribute('aria-selected',true);p.onMark&&p.onMark(o);},unmark:function(m){var q=this;var n=q.element.getDocument(),o=q._.items[m],p=n.getById(o);
p.removeClass('cke_selected');n.getById(o+'_option').removeAttribute('aria-selected');q.onUnmark&&q.onUnmark(p);},unmarkAll:function(){var q=this;var m=q._.items,n=q.element.getDocument();for(var o in m){var p=m[o];n.getById(p).removeClass('cke_selected');n.getById(p+'_option').removeAttribute('aria-selected');}q.onUnmark&&q.onUnmark();},isMarked:function(m){return this.element.getDocument().getById(this._.items[m]).hasClass('cke_selected');},focus:function(m){this._.focusIndex=-1;if(m){var n=this.element.getDocument().getById(this._.items[m]).getFirst(),o=this.element.getElementsByTag('a'),p,q=-1;while(p=o.getItem(++q)){if(p.equals(n)){this._.focusIndex=q;break;}}setTimeout(function(){n.focus();},0);}}}});}});a.themes.add('default',(function(){var m={};function n(o,p){var q,r;r=o.config.sharedSpaces;r=r&&r[p];r=r&&a.document.getById(r);if(r){var s='<span class="cke_shared " dir="'+o.lang.dir+'"'+'>'+'<span class="'+o.skinClass+' '+o.id+' cke_editor_'+o.name+'">'+'<span class="'+b.cssClass+'">'+'<span class="cke_wrapper cke_'+o.lang.dir+'">'+'<span class="cke_editor">'+'<div class="cke_'+p+'">'+'</div></span></span></span></span></span>',t=r.append(h.createFromHtml(s,r.getDocument()));if(r.getCustomData('cke_hasshared'))t.hide();else r.setCustomData('cke_hasshared',1);q=t.getChild([0,0,0,0]);!o.sharedSpaces&&(o.sharedSpaces={});o.sharedSpaces[p]=q;o.on('focus',function(){for(var u=0,v,w=r.getChildren();v=w.getItem(u);u++){if(v.type==1&&!v.equals(t)&&v.hasClass('cke_shared'))v.hide();}t.show();});o.on('destroy',function(){t.remove();});}return q;};return{build:function(o,p){var q=o.name,r=o.element,s=o.elementMode;if(!r||s==0)return;if(s==1)r.hide();var t=o.fire('themeSpace',{space:'top',html:''}).html,u=o.fire('themeSpace',{space:'contents',html:''}).html,v=o.fireOnce('themeSpace',{space:'bottom',html:''}).html,w=u&&o.config.height,x=o.config.tabIndex||o.element.getAttribute('tabindex')||0;if(!u)w='auto';else if(!isNaN(w))w+='px';var y='',z=o.config.width;if(z){if(!isNaN(z))z+='px';y+='width: '+z+';';}var A=t&&n(o,'top'),B=n(o,'bottom');A&&(A.setHtml(t),t='');B&&(B.setHtml(v),v='');var C='<style>.'+o.skinClass+'{visibility:hidden;}</style>';if(m[o.skinClass])C='';else m[o.skinClass]=1;var D=h.createFromHtml(['<span id="cke_',q,'" class="',o.skinClass,' ',o.id,' cke_editor_',q,'" dir="',o.lang.dir,'" title="',b.gecko?' ':'','" lang="',o.langCode,'"'+(b.webkit?' tabindex="'+x+'"':'')+' role="application"'+' aria-labelledby="cke_',q,'_arialbl"'+(y?' style="'+y+'"':'')+'>'+'<span id="cke_',q,'_arialbl" class="cke_voice_label">'+o.lang.editor+'</span>'+'<span class="',b.cssClass,'" role="presentation"><span class="cke_wrapper cke_',o.lang.dir,'" role="presentation"><table class="cke_editor" border="0" cellspacing="0" cellpadding="0" role="presentation"><tbody><tr',t?'':' style="display:none"',' role="presentation"><td id="cke_top_',q,'" class="cke_top" role="presentation">',t,'</td></tr><tr',u?'':' style="display:none"',' role="presentation"><td id="cke_contents_',q,'" class="cke_contents" style="height:',w,'" role="presentation">',u,'</td></tr><tr',v?'':' style="display:none"',' role="presentation"><td id="cke_bottom_',q,'" class="cke_bottom" role="presentation">',v,'</td></tr></tbody></table>'+C+'</span>'+'</span>'+'</span>'].join(''));
D.getChild([1,0,0,0,0]).unselectable();D.getChild([1,0,0,0,2]).unselectable();if(s==1)D.insertAfter(r);else r.append(D);o.container=D;D.disableContextMenu();o.on('contentDirChanged',function(E){var F=(o.lang.dir!=E.data?'add':'remove')+'Class';D.getChild(1)[F]('cke_mixed_dir_content');var G=this.sharedSpaces&&this.sharedSpaces[this.config.toolbarLocation];G&&G.getParent().getParent()[F]('cke_mixed_dir_content');});o.fireOnce('themeLoaded');o.fireOnce('uiReady');},buildDialog:function(o){var p=e.getNextNumber(),q=h.createFromHtml(['<div class="',o.id,'_dialog cke_editor_',o.name.replace('.','\\.'),'_dialog cke_skin_',o.skinName,'" dir="',o.lang.dir,'" lang="',o.langCode,'" role="dialog" aria-labelledby="%title#"><table class="cke_dialog',' '+b.cssClass,' cke_',o.lang.dir,'" style="position:absolute" role="presentation"><tr><td role="presentation"><div class="%body" role="presentation"><div id="%title#" class="%title" role="presentation"></div><a id="%close_button#" class="%close_button" href="javascript:void(0)" title="'+o.lang.common.close+'" role="button"><span class="cke_label">X</span></a>'+'<div id="%tabs#" class="%tabs" role="tablist"></div>'+'<table class="%contents" role="presentation">'+'<tr>'+'<td id="%contents#" class="%contents" role="presentation"></td>'+'</tr>'+'<tr>'+'<td id="%footer#" class="%footer" role="presentation"></td>'+'</tr>'+'</table>'+'</div>'+'<div id="%tl#" class="%tl"></div>'+'<div id="%tc#" class="%tc"></div>'+'<div id="%tr#" class="%tr"></div>'+'<div id="%ml#" class="%ml"></div>'+'<div id="%mr#" class="%mr"></div>'+'<div id="%bl#" class="%bl"></div>'+'<div id="%bc#" class="%bc"></div>'+'<div id="%br#" class="%br"></div>'+'</td></tr>'+'</table>',c?'':'<style>.cke_dialog{visibility:hidden;}</style>','</div>'].join('').replace(/#/g,'_'+p).replace(/%/g,'cke_dialog_')),r=q.getChild([0,0,0,0,0]),s=r.getChild(0),t=r.getChild(1);if(c&&!b.ie6Compat){var u=b.isCustomDomain(),v='javascript:void(function(){'+encodeURIComponent('document.open();'+(u?'document.domain="'+document.domain+'";':'')+'document.close();')+'}())',w=h.createFromHtml('<iframe frameBorder="0" class="cke_iframe_shim" src="'+v+'"'+' tabIndex="-1"'+'></iframe>');w.appendTo(r.getParent());}s.unselectable();t.unselectable();return{element:q,parts:{dialog:q.getChild(0),title:s,close:t,tabs:r.getChild(2),contents:r.getChild([3,0,0,0]),footer:r.getChild([3,0,1,0])}};},destroy:function(o){var p=o.container,q=o.element;if(p){p.clearCustomData();p.remove();}if(q){q.clearCustomData();
o.elementMode==1&&q.show();delete o.element;}}};})());a.editor.prototype.getThemeSpace=function(m){var n='cke_'+m,o=this._[n]||(this._[n]=a.document.getById(n+'_'+this.name));return o;};a.editor.prototype.resize=function(m,n,o,p){var v=this;var q=v.container,r=a.document.getById('cke_contents_'+v.name),s=b.webkit&&v.document&&v.document.getWindow().$.frameElement,t=p?q.getChild(1):q;t.setSize('width',m,true);s&&(s.style.width='1%');var u=o?0:(t.$.offsetHeight||0)-(r.$.clientHeight||0);r.setStyle('height',Math.max(n-u,0)+'px');s&&(s.style.width='100%');v.fire('resize');};a.editor.prototype.getResizable=function(m){return m?a.document.getById('cke_contents_'+this.name):this.container;};})();
/*  Copyright Mihai Bazon, 2002-2005  |  www.bazon.net/mishoo
 * -----------------------------------------------------------
 *
 * The DHTML Calendar, version 1.0 "It is happening again"
 *
 * Details and latest version at:
 * www.dynarch.com/projects/calendar
 *
 * This script is developed by Dynarch.com.  Visit us at www.dynarch.com.
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 */

 Calendar=function(firstDayOfWeek,dateStr,onSelected,onClose){this.activeDiv=null;this.currentDateEl=null;this.getDateStatus=null;this.getDateToolTip=null;this.getDateText=null;this.timeout=null;this.onSelected=onSelected||null;this.onClose=onClose||null;this.dragging=false;this.hidden=false;this.minYear=1970;this.maxYear=2050;this.dateFormat=Calendar._TT["DEF_DATE_FORMAT"];this.ttDateFormat=Calendar._TT["TT_DATE_FORMAT"];this.isPopup=true;this.weekNumbers=true;this.firstDayOfWeek=typeof firstDayOfWeek=="number"?firstDayOfWeek:Calendar._FD;this.showsOtherMonths=false;this.dateStr=dateStr;this.ar_days=null;this.showsTime=false;this.time24=true;this.yearStep=2;this.hiliteToday=true;this.multiple=null;this.table=null;this.element=null;this.tbody=null;this.firstdayname=null;this.monthsCombo=null;this.yearsCombo=null;this.hilitedMonth=null;this.activeMonth=null;this.hilitedYear=null;this.activeYear=null;this.dateClicked=false;if(typeof Calendar._SDN=="undefined"){if(typeof Calendar._SDN_len=="undefined")Calendar._SDN_len=3;var ar=new Array();for(var i=8;i>0;){ar[--i]=Calendar._DN[i].substr(0,Calendar._SDN_len);}Calendar._SDN=ar;if(typeof Calendar._SMN_len=="undefined")Calendar._SMN_len=3;ar=new Array();for(var i=12;i>0;){ar[--i]=Calendar._MN[i].substr(0,Calendar._SMN_len);}Calendar._SMN=ar;}};Calendar._C=null;Calendar.is_ie=(/msie/i.test(navigator.userAgent)&&!/opera/i.test(navigator.userAgent));Calendar.is_ie5=(Calendar.is_ie&&/msie 5\.0/i.test(navigator.userAgent));Calendar.is_opera=/opera/i.test(navigator.userAgent);Calendar.is_khtml=/Konqueror|Safari|KHTML/i.test(navigator.userAgent);Calendar.getAbsolutePos=function(el){var SL=0,ST=0;var is_div=/^div$/i.test(el.tagName);if(is_div&&el.scrollLeft)SL=el.scrollLeft;if(is_div&&el.scrollTop)ST=el.scrollTop;var r={x:el.offsetLeft-SL,y:el.offsetTop-ST};if(el.offsetParent){var tmp=this.getAbsolutePos(el.offsetParent);r.x+=tmp.x;r.y+=tmp.y;}return r;};Calendar.isRelated=function(el,evt){var related=evt.relatedTarget;if(!related){var type=evt.type;if(type=="mouseover"){related=evt.fromElement;}else if(type=="mouseout"){related=evt.toElement;}}while(related){if(related==el){return true;}try{related=related.parentNode;}catch(e){related = null;}}return false;};Calendar.removeClass=function(el,className){if(!(el&&el.className)){return;}var cls=el.className.split(" ");var ar=new Array();for(var i=cls.length;i>0;){if(cls[--i]!=className){ar[ar.length]=cls[i];}}el.className=ar.join(" ");};Calendar.addClass=function(el,className){Calendar.removeClass(el,className);el.className+=" "+className;};Calendar.getElement=function(ev){var f=Calendar.is_ie?window.event.srcElement:ev.currentTarget;while(f.nodeType!=1||/^div$/i.test(f.tagName))f=f.parentNode;return f;};Calendar.getTargetElement=function(ev){var f=Calendar.is_ie?window.event.srcElement:ev.target;while(f.nodeType!=1)f=f.parentNode;return f;};Calendar.stopEvent=function(ev){ev||(ev=window.event);if(Calendar.is_ie){ev.cancelBubble=true;ev.returnValue=false;}else{ev.preventDefault();ev.stopPropagation();}return false;};Calendar.addEvent=function(el,evname,func){if(el.attachEvent){el.attachEvent("on"+evname,func);}else if(el.addEventListener){el.addEventListener(evname,func,true);}else{el["on"+evname]=func;}};Calendar.removeEvent=function(el,evname,func){if(el.detachEvent){el.detachEvent("on"+evname,func);}else if(el.removeEventListener){el.removeEventListener(evname,func,true);}else{el["on"+evname]=null;}};Calendar.createElement=function(type,parent){var el=null;if(document.createElementNS){el=document.createElementNS("http://www.w3.org/1999/xhtml",type);}else{el=document.createElement(type);}if(typeof parent!="undefined"){parent.appendChild(el);}return el;};Calendar._add_evs=function(el){with(Calendar){addEvent(el,"mouseover",dayMouseOver);addEvent(el,"mousedown",dayMouseDown);addEvent(el,"mouseout",dayMouseOut);if(is_ie){addEvent(el,"dblclick",dayMouseDblClick);el.setAttribute("unselectable",true);}}};Calendar.findMonth=function(el){if(typeof el.month!="undefined"){return el;}else if(typeof el.parentNode.month!="undefined"){return el.parentNode;}return null;};Calendar.findYear=function(el){if(typeof el.year!="undefined"){return el;}else if(typeof el.parentNode.year!="undefined"){return el.parentNode;}return null;};Calendar.showMonthsCombo=function(){var cal=Calendar._C;if(!cal){return false;}var cal=cal;var cd=cal.activeDiv;var mc=cal.monthsCombo;if(cal.hilitedMonth){Calendar.removeClass(cal.hilitedMonth,"hilite");}if(cal.activeMonth){Calendar.removeClass(cal.activeMonth,"active");}var mon=cal.monthsCombo.getElementsByTagName("div")[cal.date.getMonth()];Calendar.addClass(mon,"active");cal.activeMonth=mon;var s=mc.style;s.display="block";if(cd.navtype<0)s.left=cd.offsetLeft+"px";else{var mcw=mc.offsetWidth;if(typeof mcw=="undefined")mcw=50;s.left=(cd.offsetLeft+cd.offsetWidth-mcw)+"px";}s.top=(cd.offsetTop+cd.offsetHeight)+"px";};Calendar.showYearsCombo=function(fwd){var cal=Calendar._C;if(!cal){return false;}var cal=cal;var cd=cal.activeDiv;var yc=cal.yearsCombo;if(cal.hilitedYear){Calendar.removeClass(cal.hilitedYear,"hilite");}if(cal.activeYear){Calendar.removeClass(cal.activeYear,"active");}cal.activeYear=null;var Y=cal.date.getFullYear()+(fwd?1:-1);var yr=yc.firstChild;var show=false;for(var i=12;i>0;--i){if(Y>=cal.minYear&&Y<=cal.maxYear){yr.innerHTML=Y;yr.year=Y;yr.style.display="block";show=true;}else{yr.style.display="none";}yr=yr.nextSibling;Y+=fwd?cal.yearStep:-cal.yearStep;}if(show){var s=yc.style;s.display="block";if(cd.navtype<0)s.left=cd.offsetLeft+"px";else{var ycw=yc.offsetWidth;if(typeof ycw=="undefined")ycw=50;s.left=(cd.offsetLeft+cd.offsetWidth-ycw)+"px";}s.top=(cd.offsetTop+cd.offsetHeight)+"px";}};Calendar.tableMouseUp=function(ev){var cal=Calendar._C;if(!cal){return false;}if(cal.timeout){clearTimeout(cal.timeout);}var el=cal.activeDiv;if(!el){return false;}var target=Calendar.getTargetElement(ev);ev||(ev=window.event);Calendar.removeClass(el,"active");if(target==el||target.parentNode==el){Calendar.cellClick(el,ev);}var mon=Calendar.findMonth(target);var date=null;if(mon){date=new Date(cal.date);if(mon.month!=date.getMonth()){date.setMonth(mon.month);cal.setDate(date);cal.dateClicked=false;cal.callHandler();}}else{var year=Calendar.findYear(target);if(year){date=new Date(cal.date);if(year.year!=date.getFullYear()){date.setFullYear(year.year);cal.setDate(date);cal.dateClicked=false;cal.callHandler();}}}with(Calendar){removeEvent(document,"mouseup",tableMouseUp);removeEvent(document,"mouseover",tableMouseOver);removeEvent(document,"mousemove",tableMouseOver);cal._hideCombos();_C=null;return stopEvent(ev);}};Calendar.tableMouseOver=function(ev){var cal=Calendar._C;if(!cal){return;}var el=cal.activeDiv;var target=Calendar.getTargetElement(ev);if(target==el||target.parentNode==el){Calendar.addClass(el,"hilite active");Calendar.addClass(el.parentNode,"rowhilite");}else{if(typeof el.navtype=="undefined"||(el.navtype!=50&&(el.navtype==0||Math.abs(el.navtype)>2)))Calendar.removeClass(el,"active");Calendar.removeClass(el,"hilite");Calendar.removeClass(el.parentNode,"rowhilite");}ev||(ev=window.event);if(el.navtype==50&&target!=el){var pos=Calendar.getAbsolutePos(el);var w=el.offsetWidth;var x=ev.clientX;var dx;var decrease=true;if(x>pos.x+w){dx=x-pos.x-w;decrease=false;}else dx=pos.x-x;if(dx<0)dx=0;var range=el._range;var current=el._current;var count=Math.floor(dx/10)%range.length;for(var i=range.length;--i>=0;)if(range[i]==current)break;while(count-->0)if(decrease){if(--i<0)i=range.length-1;}else if(++i>=range.length)i=0;var newval=range[i];el.innerHTML=newval;cal.onUpdateTime();}var mon=Calendar.findMonth(target);if(mon){if(mon.month!=cal.date.getMonth()){if(cal.hilitedMonth){Calendar.removeClass(cal.hilitedMonth,"hilite");}Calendar.addClass(mon,"hilite");cal.hilitedMonth=mon;}else if(cal.hilitedMonth){Calendar.removeClass(cal.hilitedMonth,"hilite");}}else{if(cal.hilitedMonth){Calendar.removeClass(cal.hilitedMonth,"hilite");}var year=Calendar.findYear(target);if(year){if(year.year!=cal.date.getFullYear()){if(cal.hilitedYear){Calendar.removeClass(cal.hilitedYear,"hilite");}Calendar.addClass(year,"hilite");cal.hilitedYear=year;}else if(cal.hilitedYear){Calendar.removeClass(cal.hilitedYear,"hilite");}}else if(cal.hilitedYear){Calendar.removeClass(cal.hilitedYear,"hilite");}}return Calendar.stopEvent(ev);};Calendar.tableMouseDown=function(ev){if(Calendar.getTargetElement(ev)==Calendar.getElement(ev)){return Calendar.stopEvent(ev);}};Calendar.calDragIt=function(ev){var cal=Calendar._C;if(!(cal&&cal.dragging)){return false;}var posX;var posY;if(Calendar.is_ie){posY=window.event.clientY+document.body.scrollTop;posX=window.event.clientX+document.body.scrollLeft;}else{posX=ev.pageX;posY=ev.pageY;}cal.hideShowCovered();var st=cal.element.style;st.left=(posX-cal.xOffs)+"px";st.top=(posY-cal.yOffs)+"px";return Calendar.stopEvent(ev);};Calendar.calDragEnd=function(ev){var cal=Calendar._C;if(!cal){return false;}cal.dragging=false;with(Calendar){removeEvent(document,"mousemove",calDragIt);removeEvent(document,"mouseup",calDragEnd);tableMouseUp(ev);}cal.hideShowCovered();};Calendar.dayMouseDown=function(ev){var el=Calendar.getElement(ev);if(el.disabled){return false;}var cal=el.calendar;cal.activeDiv=el;Calendar._C=cal;if(el.navtype!=300)with(Calendar){if(el.navtype==50){el._current=el.innerHTML;addEvent(document,"mousemove",tableMouseOver);}else addEvent(document,Calendar.is_ie5?"mousemove":"mouseover",tableMouseOver);addClass(el,"hilite active");addEvent(document,"mouseup",tableMouseUp);}else if(cal.isPopup){cal._dragStart(ev);}if(el.navtype==-1||el.navtype==1){if(cal.timeout)clearTimeout(cal.timeout);cal.timeout=setTimeout("Calendar.showMonthsCombo()",250);}else if(el.navtype==-2||el.navtype==2){if(cal.timeout)clearTimeout(cal.timeout);cal.timeout=setTimeout((el.navtype>0)?"Calendar.showYearsCombo(true)":"Calendar.showYearsCombo(false)",250);}else{cal.timeout=null;}return Calendar.stopEvent(ev);};Calendar.dayMouseDblClick=function(ev){Calendar.cellClick(Calendar.getElement(ev),ev||window.event);if(Calendar.is_ie){document.selection.empty();}};Calendar.dayMouseOver=function(ev){var el=Calendar.getElement(ev);if(Calendar.isRelated(el,ev)||Calendar._C||el.disabled){return false;}if(el.ttip){if(el.ttip.substr(0,1)=="_"){el.ttip=el.caldate.print(el.calendar.ttDateFormat)+el.ttip.substr(1);}el.calendar.tooltips.innerHTML=el.ttip;}if(el.navtype!=300){Calendar.addClass(el,"hilite");if(el.caldate){Calendar.addClass(el.parentNode,"rowhilite");}}return Calendar.stopEvent(ev);};Calendar.dayMouseOut=function(ev){with(Calendar){var el=getElement(ev);if(isRelated(el,ev)||_C||el.disabled)return false;removeClass(el,"hilite");if(el.caldate)removeClass(el.parentNode,"rowhilite");if(el.calendar)el.calendar.tooltips.innerHTML=_TT["SEL_DATE"];return stopEvent(ev);}};Calendar.cellClick=function(el,ev){var cal=el.calendar;var closing=false;var newdate=false;var date=null;if(typeof el.navtype=="undefined"){if(cal.currentDateEl){Calendar.removeClass(cal.currentDateEl,"selected");Calendar.addClass(el,"selected");closing=(cal.currentDateEl==el);if(!closing){cal.currentDateEl=el;}}cal.date.setDateOnly(el.caldate);date=cal.date;var other_month=!(cal.dateClicked=!el.otherMonth);if(!other_month&&!cal.currentDateEl)cal._toggleMultipleDate(new Date(date));else newdate=!el.disabled;if(other_month)cal._init(cal.firstDayOfWeek,date);}else{if(el.navtype==200){Calendar.removeClass(el,"hilite");cal.callCloseHandler();return;}date=new Date(cal.date);if(el.navtype==0)date.setDateOnly(new Date());cal.dateClicked=false;var year=date.getFullYear();var mon=date.getMonth();function setMonth(m){var day=date.getDate();var max=date.getMonthDays(m);if(day>max){date.setDate(max);}date.setMonth(m);};switch(el.navtype){case 400:Calendar.removeClass(el,"hilite");var text=Calendar._TT["ABOUT"];if(typeof text!="undefined"){text+=cal.showsTime?Calendar._TT["ABOUT_TIME"]:"";}else{text="Help and about box text is not translated into this language.\n"+"If you know this language and you feel generous please update\n"+"the corresponding file in \"lang\" subdir to match calendar-en.js\n"+"and send it back to <mihai_bazon@yahoo.com> to get it into the distribution  ;-)\n\n"+"Thank you!\n"+"http://dynarch.com/mishoo/calendar.epl\n";}alert(text);return;case-2:if(year>cal.minYear){date.setFullYear(year-1);}break;case-1:if(mon>0){setMonth(mon-1);}else if(year-->cal.minYear){date.setFullYear(year);setMonth(11);}break;case 1:if(mon<11){setMonth(mon+1);}else if(year<cal.maxYear){date.setFullYear(year+1);setMonth(0);}break;case 2:if(year<cal.maxYear){date.setFullYear(year+1);}break;case 100:cal.setFirstDayOfWeek(el.fdow);return;case 50:var range=el._range;var current=el.innerHTML;for(var i=range.length;--i>=0;)if(range[i]==current)break;if(ev&&ev.shiftKey){if(--i<0)i=range.length-1;}else if(++i>=range.length)i=0;var newval=range[i];el.innerHTML=newval;cal.onUpdateTime();return;case 0:if((typeof cal.getDateStatus=="function")&&cal.getDateStatus(date,date.getFullYear(),date.getMonth(),date.getDate())){return false;}break;}if(!date.equalsTo(cal.date)){cal.setDate(date);newdate=true;}else if(el.navtype==0)newdate=closing=true;}if(newdate){ev&&cal.callHandler();}if(closing){Calendar.removeClass(el,"hilite");ev&&cal.callCloseHandler();}};Calendar.prototype.create=function(_par){var parent=null;if(!_par){parent=document.getElementsByTagName("body")[0];this.isPopup=true;}else{parent=_par;this.isPopup=false;}this.date=this.dateStr?new Date(this.dateStr):new Date();var table=Calendar.createElement("table");this.table=table;table.cellSpacing=0;table.cellPadding=0;table.calendar=this;Calendar.addEvent(table,"mousedown",Calendar.tableMouseDown);var div=Calendar.createElement("div");this.element=div;div.className="calendar";if(this.isPopup){div.style.position="absolute";div.style.display="none";}div.appendChild(table);var thead=Calendar.createElement("thead",table);var cell=null;var row=null;var cal=this;var hh=function(text,cs,navtype){cell=Calendar.createElement("td",row);cell.colSpan=cs;cell.className="button";if(navtype!=0&&Math.abs(navtype)<=2)cell.className+=" nav";Calendar._add_evs(cell);cell.calendar=cal;cell.navtype=navtype;cell.innerHTML="<div unselectable='on'>"+text+"</div>";return cell;};row=Calendar.createElement("tr",thead);var title_length=6;(this.isPopup)&&--title_length;(this.weekNumbers)&&++title_length;hh("?",1,400).ttip=Calendar._TT["INFO"];this.title=hh("",title_length,300);this.title.className="title";if(this.isPopup){this.title.ttip=Calendar._TT["DRAG_TO_MOVE"];this.title.style.cursor="move";hh("&#x00d7;",1,200).ttip=Calendar._TT["CLOSE"];}row=Calendar.createElement("tr",thead);row.className="headrow";this._nav_py=hh("&#x00ab;",1,-2);this._nav_py.ttip=Calendar._TT["PREV_YEAR"];this._nav_pm=hh("&#x2039;",1,-1);this._nav_pm.ttip=Calendar._TT["PREV_MONTH"];this._nav_now=hh(Calendar._TT["TODAY"],this.weekNumbers?4:3,0);this._nav_now.ttip=Calendar._TT["GO_TODAY"];this._nav_nm=hh("&#x203a;",1,1);this._nav_nm.ttip=Calendar._TT["NEXT_MONTH"];this._nav_ny=hh("&#x00bb;",1,2);this._nav_ny.ttip=Calendar._TT["NEXT_YEAR"];row=Calendar.createElement("tr",thead);row.className="daynames";if(this.weekNumbers){cell=Calendar.createElement("td",row);cell.className="name wn";cell.innerHTML=Calendar._TT["WK"];}for(var i=7;i>0;--i){cell=Calendar.createElement("td",row);if(!i){cell.navtype=100;cell.calendar=this;Calendar._add_evs(cell);}}this.firstdayname=(this.weekNumbers)?row.firstChild.nextSibling:row.firstChild;this._displayWeekdays();var tbody=Calendar.createElement("tbody",table);this.tbody=tbody;for(i=6;i>0;--i){row=Calendar.createElement("tr",tbody);if(this.weekNumbers){cell=Calendar.createElement("td",row);}for(var j=7;j>0;--j){cell=Calendar.createElement("td",row);cell.calendar=this;Calendar._add_evs(cell);}}if(this.showsTime){row=Calendar.createElement("tr",tbody);row.className="time";cell=Calendar.createElement("td",row);cell.className="time";cell.colSpan=2;cell.innerHTML=Calendar._TT["TIME"]||"&nbsp;";cell=Calendar.createElement("td",row);cell.className="time";cell.colSpan=this.weekNumbers?4:3;(function(){function makeTimePart(className,init,range_start,range_end){var part=Calendar.createElement("span",cell);part.className=className;part.innerHTML=init;part.calendar=cal;part.ttip=Calendar._TT["TIME_PART"];part.navtype=50;part._range=[];if(typeof range_start!="number")part._range=range_start;else{for(var i=range_start;i<=range_end;++i){var txt;if(i<10&&range_end>=10)txt='0'+i;else txt=''+i;part._range[part._range.length]=txt;}}Calendar._add_evs(part);return part;};var hrs=cal.date.getHours();var mins=cal.date.getMinutes();var t12=!cal.time24;var pm=(hrs>12);if(t12&&pm)hrs-=12;var H=makeTimePart("hour",hrs,t12?1:0,t12?12:23);var span=Calendar.createElement("span",cell);span.innerHTML=":";span.className="colon";var M=makeTimePart("minute",mins,0,59);var AP=null;cell=Calendar.createElement("td",row);cell.className="time";cell.colSpan=2;if(t12)AP=makeTimePart("ampm",pm?"pm":"am",["am","pm"]);else cell.innerHTML="&nbsp;";cal.onSetTime=function(){var pm,hrs=this.date.getHours(),mins=this.date.getMinutes();if(t12){pm=(hrs>=12);if(pm)hrs-=12;if(hrs==0)hrs=12;AP.innerHTML=pm?"pm":"am";}H.innerHTML=(hrs<10)?("0"+hrs):hrs;M.innerHTML=(mins<10)?("0"+mins):mins;};cal.onUpdateTime=function(){var date=this.date;var h=parseInt(H.innerHTML,10);if(t12){if(/pm/i.test(AP.innerHTML)&&h<12)h+=12;else if(/am/i.test(AP.innerHTML)&&h==12)h=0;}var d=date.getDate();var m=date.getMonth();var y=date.getFullYear();date.setHours(h);date.setMinutes(parseInt(M.innerHTML,10));date.setFullYear(y);date.setMonth(m);date.setDate(d);this.dateClicked=false;this.callHandler();};})();}else{this.onSetTime=this.onUpdateTime=function(){};}var tfoot=Calendar.createElement("tfoot",table);row=Calendar.createElement("tr",tfoot);row.className="footrow";cell=hh(Calendar._TT["SEL_DATE"],this.weekNumbers?8:7,300);cell.className="ttip";if(this.isPopup){cell.ttip=Calendar._TT["DRAG_TO_MOVE"];cell.style.cursor="move";}this.tooltips=cell;div=Calendar.createElement("div",this.element);this.monthsCombo=div;div.className="combo";for(i=0;i<Calendar._MN.length;++i){var mn=Calendar.createElement("div");mn.className=Calendar.is_ie?"label-IEfix":"label";mn.month=i;mn.innerHTML=Calendar._SMN[i];div.appendChild(mn);}div=Calendar.createElement("div",this.element);this.yearsCombo=div;div.className="combo";for(i=12;i>0;--i){var yr=Calendar.createElement("div");yr.className=Calendar.is_ie?"label-IEfix":"label";div.appendChild(yr);}this._init(this.firstDayOfWeek,this.date);parent.appendChild(this.element);};Calendar._keyEvent=function(ev){var cal=window._dynarch_popupCalendar;if(!cal||cal.multiple)return false;(Calendar.is_ie)&&(ev=window.event);var act=(Calendar.is_ie||ev.type=="keypress"),K=ev.keyCode;if(ev.ctrlKey){switch(K){case 37:act&&Calendar.cellClick(cal._nav_pm);break;case 38:act&&Calendar.cellClick(cal._nav_py);break;case 39:act&&Calendar.cellClick(cal._nav_nm);break;case 40:act&&Calendar.cellClick(cal._nav_ny);break;default:return false;}}else switch(K){case 32:Calendar.cellClick(cal._nav_now);break;case 27:act&&cal.callCloseHandler();break;case 37:case 38:case 39:case 40:if(act){var prev,x,y,ne,el,step;prev=K==37||K==38;step=(K==37||K==39)?1:7;function setVars(){el=cal.currentDateEl;var p=el.pos;x=p&15;y=p>>4;ne=cal.ar_days[y][x];};setVars();function prevMonth(){var date=new Date(cal.date);date.setDate(date.getDate()-step);cal.setDate(date);};function nextMonth(){var date=new Date(cal.date);date.setDate(date.getDate()+step);cal.setDate(date);};while(1){switch(K){case 37:if(--x>=0)ne=cal.ar_days[y][x];else{x=6;K=38;continue;}break;case 38:if(--y>=0)ne=cal.ar_days[y][x];else{prevMonth();setVars();}break;case 39:if(++x<7)ne=cal.ar_days[y][x];else{x=0;K=40;continue;}break;case 40:if(++y<cal.ar_days.length)ne=cal.ar_days[y][x];else{nextMonth();setVars();}break;}break;}if(ne){if(!ne.disabled)Calendar.cellClick(ne);else if(prev)prevMonth();else nextMonth();}}break;case 13:if(act)Calendar.cellClick(cal.currentDateEl,ev);break;default:return false;}return Calendar.stopEvent(ev);};Calendar.prototype._init=function(firstDayOfWeek,date){var today=new Date(),TY=today.getFullYear(),TM=today.getMonth(),TD=today.getDate();this.table.style.visibility="hidden";var year=date.getFullYear();if(year<this.minYear){year=this.minYear;date.setFullYear(year);}else if(year>this.maxYear){year=this.maxYear;date.setFullYear(year);}this.firstDayOfWeek=firstDayOfWeek;this.date=new Date(date);var month=date.getMonth();var mday=date.getDate();var no_days=date.getMonthDays();date.setDate(1);var day1=(date.getDay()-this.firstDayOfWeek)%7;if(day1<0)day1+=7;date.setDate(-day1);date.setDate(date.getDate()+1);var row=this.tbody.firstChild;var MN=Calendar._SMN[month];var ar_days=this.ar_days=new Array();var weekend=Calendar._TT["WEEKEND"];var dates=this.multiple?(this.datesCells={}):null;for(var i=0;i<6;++i,row=row.nextSibling){var cell=row.firstChild;if(this.weekNumbers){cell.className="day wn";cell.innerHTML=date.getWeekNumber();cell=cell.nextSibling;}row.className="daysrow";var hasdays=false,iday,dpos=ar_days[i]=[];for(var j=0;j<7;++j,cell=cell.nextSibling,date.setDate(iday+1)){iday=date.getDate();var wday=date.getDay();cell.className="day";cell.pos=i<<4|j;dpos[j]=cell;var current_month=(date.getMonth()==month);if(!current_month){if(this.showsOtherMonths){cell.className+=" othermonth";cell.otherMonth=true;}else{cell.className="emptycell";cell.innerHTML="&nbsp;";cell.disabled=true;continue;}}else{cell.otherMonth=false;hasdays=true;}cell.disabled=false;cell.innerHTML=this.getDateText?this.getDateText(date,iday):iday;if(dates)dates[date.print("%Y%m%d")]=cell;if(this.getDateStatus){var status=this.getDateStatus(date,year,month,iday);if(this.getDateToolTip){var toolTip=this.getDateToolTip(date,year,month,iday);if(toolTip)cell.title=toolTip;}if(status===true){cell.className+=" disabled";cell.disabled=true;}else{if(/disabled/i.test(status))cell.disabled=true;cell.className+=" "+status;}}if(!cell.disabled){cell.caldate=new Date(date);cell.ttip="_";if(!this.multiple&&current_month&&iday==mday&&this.hiliteToday){cell.className+=" selected";this.currentDateEl=cell;}if(date.getFullYear()==TY&&date.getMonth()==TM&&iday==TD){cell.className+=" today";cell.ttip+=Calendar._TT["PART_TODAY"];}if(weekend.indexOf(wday.toString())!=-1)cell.className+=cell.otherMonth?" oweekend":" weekend";}}if(!(hasdays||this.showsOtherMonths))row.className="emptyrow";}this.title.innerHTML=Calendar._MN[month]+", "+year;this.onSetTime();this.table.style.visibility="visible";this._initMultipleDates();};Calendar.prototype._initMultipleDates=function(){if(this.multiple){for(var i in this.multiple){var cell=this.datesCells[i];var d=this.multiple[i];if(!d)continue;if(cell)cell.className+=" selected";}}};Calendar.prototype._toggleMultipleDate=function(date){if(this.multiple){var ds=date.print("%Y%m%d");var cell=this.datesCells[ds];if(cell){var d=this.multiple[ds];if(!d){Calendar.addClass(cell,"selected");this.multiple[ds]=date;}else{Calendar.removeClass(cell,"selected");delete this.multiple[ds];}}}};Calendar.prototype.setDateToolTipHandler=function(unaryFunction){this.getDateToolTip=unaryFunction;};Calendar.prototype.setDate=function(date){if(!date.equalsTo(this.date)){this._init(this.firstDayOfWeek,date);}};Calendar.prototype.refresh=function(){this._init(this.firstDayOfWeek,this.date);};Calendar.prototype.setFirstDayOfWeek=function(firstDayOfWeek){this._init(firstDayOfWeek,this.date);this._displayWeekdays();};Calendar.prototype.setDateStatusHandler=Calendar.prototype.setDisabledHandler=function(unaryFunction){this.getDateStatus=unaryFunction;};Calendar.prototype.setRange=function(a,z){this.minYear=a;this.maxYear=z;};Calendar.prototype.callHandler=function(){if(this.onSelected){this.onSelected(this,this.date.print(this.dateFormat));}};Calendar.prototype.callCloseHandler=function(){if(this.onClose){this.onClose(this);}this.hideShowCovered();};Calendar.prototype.destroy=function(){var el=this.element.parentNode;el.removeChild(this.element);Calendar._C=null;window._dynarch_popupCalendar=null;};Calendar.prototype.reparent=function(new_parent){var el=this.element;el.parentNode.removeChild(el);new_parent.appendChild(el);};Calendar._checkCalendar=function(ev){var calendar=window._dynarch_popupCalendar;if(!calendar){return false;}var el=Calendar.is_ie?Calendar.getElement(ev):Calendar.getTargetElement(ev);for(;el!=null&&el!=calendar.element;el=el.parentNode);if(el==null){window._dynarch_popupCalendar.callCloseHandler();return Calendar.stopEvent(ev);}};Calendar.prototype.show=function(){var rows=this.table.getElementsByTagName("tr");for(var i=rows.length;i>0;){var row=rows[--i];Calendar.removeClass(row,"rowhilite");var cells=row.getElementsByTagName("td");for(var j=cells.length;j>0;){var cell=cells[--j];Calendar.removeClass(cell,"hilite");Calendar.removeClass(cell,"active");}}this.element.style.display="block";this.hidden=false;if(this.isPopup){window._dynarch_popupCalendar=this;Calendar.addEvent(document,"keydown",Calendar._keyEvent);Calendar.addEvent(document,"keypress",Calendar._keyEvent);Calendar.addEvent(document,"mousedown",Calendar._checkCalendar);}this.hideShowCovered();};Calendar.prototype.hide=function(){if(this.isPopup){Calendar.removeEvent(document,"keydown",Calendar._keyEvent);Calendar.removeEvent(document,"keypress",Calendar._keyEvent);Calendar.removeEvent(document,"mousedown",Calendar._checkCalendar);}this.element.style.display="none";this.hidden=true;this.hideShowCovered();};Calendar.prototype.showAt=function(x,y){var s=this.element.style;s.left=x+"px";s.top=y+"px";this.show();};Calendar.prototype.showAtElement=function(el,opts){var self=this;var p=Calendar.getAbsolutePos(el);if(!opts||typeof opts!="string"){this.showAt(p.x,p.y+el.offsetHeight);return true;}function fixPosition(box){if(box.x<0)box.x=0;if(box.y<0)box.y=0;var cp=document.createElement("div");var s=cp.style;s.position="absolute";s.right=s.bottom=s.width=s.height="0px";document.body.appendChild(cp);var br=Calendar.getAbsolutePos(cp);document.body.removeChild(cp);if(Calendar.is_ie){br.y+=document.body.scrollTop;br.x+=document.body.scrollLeft;}else{br.y+=window.scrollY;br.x+=window.scrollX;}var tmp=box.x+box.width-br.x;if(tmp>0)box.x-=tmp;tmp=box.y+box.height-br.y;if(tmp>0)box.y-=tmp;};this.element.style.display="block";Calendar.continuation_for_the_fucking_khtml_browser=function(){var w=self.element.offsetWidth;var h=self.element.offsetHeight;self.element.style.display="none";var valign=opts.substr(0,1);var halign="l";if(opts.length>1){halign=opts.substr(1,1);}switch(valign){case "T":p.y-=h;break;case "B":p.y+=el.offsetHeight;break;case "C":p.y+=(el.offsetHeight-h)/2;break;case "t":p.y+=el.offsetHeight-h;break;case "b":break;}switch(halign){case "L":p.x-=w;break;case "R":p.x+=el.offsetWidth;break;case "C":p.x+=(el.offsetWidth-w)/2;break;case "l":p.x+=el.offsetWidth-w;break;case "r":break;}p.width=w;p.height=h+40;self.monthsCombo.style.display="none";fixPosition(p);self.showAt(p.x,p.y);};if(Calendar.is_khtml)setTimeout("Calendar.continuation_for_the_fucking_khtml_browser()",10);else Calendar.continuation_for_the_fucking_khtml_browser();};Calendar.prototype.setDateFormat=function(str){this.dateFormat=str;};Calendar.prototype.setTtDateFormat=function(str){this.ttDateFormat=str;};Calendar.prototype.parseDate=function(str,fmt){if(!fmt)fmt=this.dateFormat;this.setDate(Date.parseDate(str,fmt));};Calendar.prototype.hideShowCovered=function(){if(!Calendar.is_ie&&!Calendar.is_opera)return;function getVisib(obj){var value=obj.style.visibility;if(!value){if(document.defaultView&&typeof(document.defaultView.getComputedStyle)=="function"){if(!Calendar.is_khtml)value=document.defaultView. getComputedStyle(obj,"").getPropertyValue("visibility");else value='';}else if(obj.currentStyle){value=obj.currentStyle.visibility;}else value='';}return value;};var tags=new Array("applet","iframe","select");var el=this.element;var p=Calendar.getAbsolutePos(el);var EX1=p.x;var EX2=el.offsetWidth+EX1;var EY1=p.y;var EY2=el.offsetHeight+EY1;for(var k=tags.length;k>0;){var ar=document.getElementsByTagName(tags[--k]);var cc=null;for(var i=ar.length;i>0;){cc=ar[--i];p=Calendar.getAbsolutePos(cc);var CX1=p.x;var CX2=cc.offsetWidth+CX1;var CY1=p.y;var CY2=cc.offsetHeight+CY1;if(this.hidden||(CX1>EX2)||(CX2<EX1)||(CY1>EY2)||(CY2<EY1)){if(!cc.__msh_save_visibility){cc.__msh_save_visibility=getVisib(cc);}cc.style.visibility=cc.__msh_save_visibility;}else{if(!cc.__msh_save_visibility){cc.__msh_save_visibility=getVisib(cc);}cc.style.visibility="hidden";}}}};Calendar.prototype._displayWeekdays=function(){var fdow=this.firstDayOfWeek;var cell=this.firstdayname;var weekend=Calendar._TT["WEEKEND"];for(var i=0;i<7;++i){cell.className="day name";var realday=(i+fdow)%7;if(i){cell.ttip=Calendar._TT["DAY_FIRST"].replace("%s",Calendar._DN[realday]);cell.navtype=100;cell.calendar=this;cell.fdow=realday;Calendar._add_evs(cell);}if(weekend.indexOf(realday.toString())!=-1){Calendar.addClass(cell,"weekend");}cell.innerHTML=Calendar._SDN[(i+fdow)%7];cell=cell.nextSibling;}};Calendar.prototype._hideCombos=function(){this.monthsCombo.style.display="none";this.yearsCombo.style.display="none";};Calendar.prototype._dragStart=function(ev){if(this.dragging){return;}this.dragging=true;var posX;var posY;if(Calendar.is_ie){posY=window.event.clientY+document.body.scrollTop;posX=window.event.clientX+document.body.scrollLeft;}else{posY=ev.clientY+window.scrollY;posX=ev.clientX+window.scrollX;}var st=this.element.style;this.xOffs=posX-parseInt(st.left);this.yOffs=posY-parseInt(st.top);with(Calendar){addEvent(document,"mousemove",calDragIt);addEvent(document,"mouseup",calDragEnd);}};Date._MD=new Array(31,28,31,30,31,30,31,31,30,31,30,31);Date.SECOND=1000;Date.MINUTE=60*Date.SECOND;Date.HOUR=60*Date.MINUTE;Date.DAY=24*Date.HOUR;Date.WEEK=7*Date.DAY;Date.parseDate=function(str,fmt){var today=new Date();var y=0;var m=-1;var d=0;var a=str.split(/\W+/);var b=fmt.match(/%./g);var i=0,j=0;var hr=0;var min=0;for(i=0;i<a.length;++i){if(!a[i])continue;switch(b[i]){case "%d":case "%e":d=parseInt(a[i],10);break;case "%m":m=parseInt(a[i],10)-1;break;case "%Y":case "%y":y=parseInt(a[i],10);(y<100)&&(y+=(y>29)?1900:2000);break;case "%b":case "%B":for(j=0;j<12;++j){if(Calendar._MN[j].substr(0,a[i].length).toLowerCase()==a[i].toLowerCase()){m=j;break;}}break;case "%H":case "%I":case "%k":case "%l":hr=parseInt(a[i],10);break;case "%P":case "%p":if(/pm/i.test(a[i])&&hr<12)hr+=12;else if(/am/i.test(a[i])&&hr>=12)hr-=12;break;case "%M":min=parseInt(a[i],10);break;}}if(isNaN(y))y=today.getFullYear();if(isNaN(m))m=today.getMonth();if(isNaN(d))d=today.getDate();if(isNaN(hr))hr=today.getHours();if(isNaN(min))min=today.getMinutes();if(y!=0&&m!=-1&&d!=0)return new Date(y,m,d,hr,min,0);y=0;m=-1;d=0;for(i=0;i<a.length;++i){if(a[i].search(/[a-zA-Z]+/)!=-1){var t=-1;for(j=0;j<12;++j){if(Calendar._MN[j].substr(0,a[i].length).toLowerCase()==a[i].toLowerCase()){t=j;break;}}if(t!=-1){if(m!=-1){d=m+1;}m=t;}}else if(parseInt(a[i],10)<=12&&m==-1){m=a[i]-1;}else if(parseInt(a[i],10)>31&&y==0){y=parseInt(a[i],10);(y<100)&&(y+=(y>29)?1900:2000);}else if(d==0){d=a[i];}}if(y==0)y=today.getFullYear();if(m!=-1&&d!=0)return new Date(y,m,d,hr,min,0);return today;};Date.prototype.getMonthDays=function(month){var year=this.getFullYear();if(typeof month=="undefined"){month=this.getMonth();}if(((0==(year%4))&&((0!=(year%100))||(0==(year%400))))&&month==1){return 29;}else{return Date._MD[month];}};Date.prototype.getDayOfYear=function(){var now=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var then=new Date(this.getFullYear(),0,0,0,0,0);var time=now-then;return Math.floor(time/Date.DAY);};Date.prototype.getWeekNumber=function(){var d=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var DoW=d.getDay();d.setDate(d.getDate()-(DoW+6)%7+3);var ms=d.valueOf();d.setMonth(0);d.setDate(4);return Math.round((ms-d.valueOf())/(7*864e5))+1;};Date.prototype.equalsTo=function(date){return((this.getFullYear()==date.getFullYear())&&(this.getMonth()==date.getMonth())&&(this.getDate()==date.getDate())&&(this.getHours()==date.getHours())&&(this.getMinutes()==date.getMinutes()));};Date.prototype.setDateOnly=function(date){var tmp=new Date(date);this.setDate(1);this.setFullYear(tmp.getFullYear());this.setMonth(tmp.getMonth());this.setDate(tmp.getDate());};Date.prototype.print=function(str){var m=this.getMonth();var d=this.getDate();var y=this.getFullYear();var wn=this.getWeekNumber();var w=this.getDay();var s={};var hr=this.getHours();var pm=(hr>=12);var ir=(pm)?(hr-12):hr;var dy=this.getDayOfYear();if(ir==0)ir=12;var min=this.getMinutes();var sec=this.getSeconds();s["%a"]=Calendar._SDN[w];s["%A"]=Calendar._DN[w];s["%b"]=Calendar._SMN[m];s["%B"]=Calendar._MN[m];s["%C"]=1+Math.floor(y/100);s["%d"]=(d<10)?("0"+d):d;s["%e"]=d;s["%H"]=(hr<10)?("0"+hr):hr;s["%I"]=(ir<10)?("0"+ir):ir;s["%j"]=(dy<100)?((dy<10)?("00"+dy):("0"+dy)):dy;s["%k"]=hr;s["%l"]=ir;s["%m"]=(m<9)?("0"+(1+m)):(1+m);s["%M"]=(min<10)?("0"+min):min;s["%n"]="\n";s["%p"]=pm?"PM":"AM";s["%P"]=pm?"pm":"am";s["%s"]=Math.floor(this.getTime()/1000);s["%S"]=(sec<10)?("0"+sec):sec;s["%t"]="\t";s["%U"]=s["%W"]=s["%V"]=(wn<10)?("0"+wn):wn;s["%u"]=w+1;s["%w"]=w;s["%y"]=(''+y).substr(2,2);s["%Y"]=y;s["%%"]="%";var re=/%./g;if(!Calendar.is_ie5&&!Calendar.is_khtml)return str.replace(re,function(par){return s[par]||par;});var a=str.match(re);for(var i=0;i<a.length;i++){var tmp=s[a[i]];if(tmp){re=new RegExp(a[i],'g');str=str.replace(re,tmp);}}return str;};Date.prototype.__msh_oldSetFullYear=Date.prototype.setFullYear;Date.prototype.setFullYear=function(y){var d=new Date(this);d.__msh_oldSetFullYear(y);if(d.getMonth()!=this.getMonth())this.setDate(28);this.__msh_oldSetFullYear(y);};window._dynarch_popupCalendar=null;
/*  Copyright Mihai Bazon, 2002, 2003  |  http://dynarch.com/mishoo/
 * ---------------------------------------------------------------------------
 *
 * The DHTML Calendar
 *
 * Details and latest version at:
 * http://dynarch.com/mishoo/calendar.epl
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 *
 * This file defines helper functions for setting up the calendar.  They are
 * intended to help non-programmers get a working calendar on their site
 * quickly.  This script should not be seen as part of the calendar.  It just
 * shows you what one can do with the calendar, while in the same time
 * providing a quick and simple method for setting it up.  If you need
 * exhaustive customization of the calendar creation process feel free to
 * modify this code to suit your needs (this is recommended and much better
 * than modifying calendar.js itself).
 */

 Calendar.setup=function(params){function param_default(pname,def){if(typeof params[pname]=="undefined"){params[pname]=def;}};param_default("inputField",null);param_default("displayArea",null);param_default("button",null);param_default("eventName","click");param_default("ifFormat","%Y/%m/%d");param_default("daFormat","%Y/%m/%d");param_default("singleClick",true);param_default("disableFunc",null);param_default("dateStatusFunc",params["disableFunc"]);param_default("dateText",null);param_default("firstDay",null);param_default("align","Br");param_default("range",[1900,2999]);param_default("weekNumbers",true);param_default("flat",null);param_default("flatCallback",null);param_default("onSelect",null);param_default("onClose",null);param_default("onUpdate",null);param_default("date",null);param_default("showsTime",false);param_default("timeFormat","24");param_default("electric",true);param_default("step",2);param_default("position",null);param_default("cache",false);param_default("showOthers",false);param_default("multiple",null);var tmp=["inputField","displayArea","button"];for(var i in tmp){if(typeof params[tmp[i]]=="string"){params[tmp[i]]=document.getElementById(params[tmp[i]]);}}if(!(params.flat||params.multiple||params.inputField||params.displayArea||params.button)){alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");return false;}function onSelect(cal){var p=cal.params;var update=(cal.dateClicked||p.electric);if(update&&p.inputField){p.inputField.value=cal.date.print(p.ifFormat);if(typeof p.inputField.onchange=="function")p.inputField.onchange();}if(update&&p.displayArea)p.displayArea.innerHTML=cal.date.print(p.daFormat);if(update&&typeof p.onUpdate=="function")p.onUpdate(cal);if(update&&p.flat){if(typeof p.flatCallback=="function")p.flatCallback(cal);}if(update&&p.singleClick&&cal.dateClicked)cal.callCloseHandler();};if(params.flat!=null){if(typeof params.flat=="string")params.flat=document.getElementById(params.flat);if(!params.flat){alert("Calendar.setup:\n  Flat specified but can't find parent.");return false;}var cal=new Calendar(params.firstDay,params.date,params.onSelect||onSelect);cal.showsOtherMonths=params.showOthers;cal.showsTime=params.showsTime;cal.time24=(params.timeFormat=="24");cal.params=params;cal.weekNumbers=params.weekNumbers;cal.setRange(params.range[0],params.range[1]);cal.setDateStatusHandler(params.dateStatusFunc);cal.getDateText=params.dateText;if(params.ifFormat){cal.setDateFormat(params.ifFormat);}if(params.inputField&&typeof params.inputField.value=="string"){cal.parseDate(params.inputField.value);}cal.create(params.flat);cal.show();return false;}var triggerEl=params.button||params.displayArea||params.inputField;triggerEl["on"+params.eventName]=function(){var dateEl=params.inputField||params.displayArea;var dateFmt=params.inputField?params.ifFormat:params.daFormat;var mustCreate=false;var cal=window.calendar;if(dateEl)params.date=Date.parseDate(dateEl.value||dateEl.innerHTML,dateFmt);if(!(cal&&params.cache)){window.calendar=cal=new Calendar(params.firstDay,params.date,params.onSelect||onSelect,params.onClose||function(cal){cal.hide();});cal.showsTime=params.showsTime;cal.time24=(params.timeFormat=="24");cal.weekNumbers=params.weekNumbers;mustCreate=true;}else{if(params.date)cal.setDate(params.date);cal.hide();}if(params.multiple){cal.multiple={};for(var i=params.multiple.length;--i>=0;){var d=params.multiple[i];var ds=d.print("%Y%m%d");cal.multiple[ds]=d;}}cal.showsOtherMonths=params.showOthers;cal.yearStep=params.step;cal.setRange(params.range[0],params.range[1]);cal.params=params;cal.setDateStatusHandler(params.dateStatusFunc);cal.getDateText=params.dateText;cal.setDateFormat(dateFmt);if(mustCreate)cal.create();cal.refresh();if(!params.position)cal.showAtElement(params.button||params.displayArea||params.inputField,params.align);else cal.showAt(params.position[0],params.position[1]);return false;};return cal;};
// ** I18N

// Calendar EN language
// Author: Mihai Bazon, <mihai_bazon@yahoo.com>
// Encoding: any
// Distributed under the same terms as the calendar itself.

// For translators: please use UTF-8 if possible.  We strongly believe that
// Unicode is the answer to a real internationalized world.  Also please
// include your contact information in the header, as can be seen above.

// full day names
Calendar._DN = new Array
("Sunday",
 "Monday",
 "Tuesday",
 "Wednesday",
 "Thursday",
 "Friday",
 "Saturday",
 "Sunday");

// Please note that the following array of short day names (and the same goes
// for short month names, _SMN) isn't absolutely necessary.  We give it here
// for exemplification on how one can customize the short day names, but if
// they are simply the first N letters of the full name you can simply say:
//
//   Calendar._SDN_len = N; // short day name length
//   Calendar._SMN_len = N; // short month name length
//
// If N = 3 then this is not needed either since we assume a value of 3 if not
// present, to be compatible with translation files that were written before
// this feature.

// short day names
Calendar._SDN = new Array
("Sun",
 "Mon",
 "Tue",
 "Wed",
 "Thu",
 "Fri",
 "Sat",
 "Sun");

// First day of the week. "0" means display Sunday first, "1" means display
// Monday first, etc.
Calendar._FD = 0;

// full month names
Calendar._MN = new Array
("January",
 "February",
 "March",
 "April",
 "May",
 "June",
 "July",
 "August",
 "September",
 "October",
 "November",
 "December");

// short month names
Calendar._SMN = new Array
("Jan",
 "Feb",
 "Mar",
 "Apr",
 "May",
 "Jun",
 "Jul",
 "Aug",
 "Sep",
 "Oct",
 "Nov",
 "Dec");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "About the calendar";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"For latest version visit: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Date selection:\n" +
"- Use the \xab, \xbb buttons to select year\n" +
"- Use the " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " buttons to select month\n" +
"- Hold mouse button on any of the above buttons for faster selection.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Time selection:\n" +
"- Click on any of the time parts to increase it\n" +
"- or Shift-click to decrease it\n" +
"- or click and drag for faster selection.";

Calendar._TT["PREV_YEAR"] = "Prev. year (hold for menu)";
Calendar._TT["PREV_MONTH"] = "Prev. month (hold for menu)";
Calendar._TT["GO_TODAY"] = "Go Today";
Calendar._TT["NEXT_MONTH"] = "Next month (hold for menu)";
Calendar._TT["NEXT_YEAR"] = "Next year (hold for menu)";
Calendar._TT["SEL_DATE"] = "Select date";
Calendar._TT["DRAG_TO_MOVE"] = "Drag to move";
Calendar._TT["PART_TODAY"] = " (today)";

// the following is to inform that "%s" is to be the first day of week
// %s will be replaced with the day name.
Calendar._TT["DAY_FIRST"] = "Display %s first";

// This may be locale-dependent.  It specifies the week-end days, as an array
// of comma-separated numbers.  The numbers are from 0 to 6: 0 means Sunday, 1
// means Monday, etc.
Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Close";
Calendar._TT["TODAY"] = "Today";
Calendar._TT["TIME_PART"] = "(Shift-)Click or drag to change value";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%Y-%m-%d";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "wk";
Calendar._TT["TIME"] = "Time:";
var Suggestions = (function($){

  var requests = {};

  var findRequest = function(params){
    return requests[requestClass(params)];
  };

  var requestClass = function(params){
    return params.type+'_'+params.id;
  };

  var init = function(el){
    el
      .delegate('a.follow', 'click', function(){ follow(this); })
      .delegate('a.close-x', 'click', function(){ dismiss(this); });
  };

  var follow = function(linkEl){
    var followedEl = grabSuggestionEl(linkEl);
    var params = suggestionParams(followedEl);
    if (findRequest(params)) { return; }

    followedEl.addClass('load_mask');
    requests[requestClass(params)] = $.ajax({
      url: '/suggestions/follow',
      data: params,
      type: 'POST',
      success: function(data){
        SPICEWORKS.fire("suggestion:followed", {suggestion: {type: params.type, id: params.id}, response: data, followedEl: followedEl});
        SPICEWORKS.fire("connection:followed", {type: params.type, id: params.id});
      },
      failure: function(data){
        // remove the suggestion from the page in the odd event this fails
        replaceSuggestion(followedEl,"");
      }
    });
  };

  // response for following via the homepage
  var replaceWithNext = function(ev){
    var memo = ev.memo;
    replaceSuggestion(memo.followedEl, memo.response.suggestion);
    GoogleAnalytics.trackEvent("NewFeed", "Followed "+memo.suggestion.type, memo.suggestion.id);
  };

  // response for following most everywhere else
  var updateAsFollowed = function(ev){
    var memo = ev.memo;
    updateSuggestion(memo.followedEl, memo.response.suggestion);
    GoogleAnalytics.trackEvent("GroupWelcomeSuggestion", "Followed "+memo.suggestion.type, memo.suggestion.id);
  };

  var updateSuggestion = function(followedEl){
    followedEl
      .removeClass('load_mask')
      .find('.follow_status')
        .html('Following')
        .effect('highlight');
  };

  var dismiss = function(linkEl){
    var dismissedEl = grabSuggestionEl(linkEl);
    var params = suggestionParams(dismissedEl);
    if (findRequest(params)) { return; }

    dismissedEl.addClass('load_mask');
    requests[requestClass(params)] = $.ajax({
      url: 'suggestions/dismiss',
      data: params,
      type: 'POST',
      success: function(data){
        replaceSuggestion(dismissedEl, data.suggestion);
      },
      failure: function(data){
        // remove the suggestion from the page in the odd event this fails
        replaceSuggestion(dismissedEl,"");
      }
    });
  };

  var grabSuggestionEl = function(linkEl){
    return $(linkEl).parents('.suggestion');
  };

  var suggestionParams = function(suggestionEl){
    return {
      id: suggestionEl.attr('data-id'),
      type: suggestionEl.attr('data-type'),
      from_url: suggestionEl.attr('data-from-url'),
      stm_source: "recommendation",
      stm_medium: "organic",
      stm_campaign: "home_page"
    };
  };
  var replaceSuggestion = function(oldEl, newHtml){
    oldEl.replaceWith(newHtml);
  };

  return {
    replaceSuggestion: replaceSuggestion,
    suggestionParams: suggestionParams,
    grabSuggestionEl: grabSuggestionEl,
    init: init,
    replaceWithNext: replaceWithNext,
    updateAsFollowed: updateAsFollowed
  };
})(jQuery);
(function($) {
  SUI || (SUI = {});

  var Helpers = {
    icon: function(icon, options) {
      var availableColors = ["dark", "light", "blue"];
      var availableIcons = ["remove", "add", "minus", "success", "search",
          "up", "down", "left", "right", "move", "gear", "viewtiles",
          "viewicons", "viewlist", "download", "print", "edit", "copy",
          "share", "email", "stardark", "starorange", "starhalf",
          "stargray", "pagercurrent", "pageralt"];
      _.defaults(options || (options = {}), {
        color: availableColors.first(),
        html: false
      });
      if(_(availableColors).include(options.color) && _(availableIcons).include(icon)) {
        var $icon = $("<i></i>").addClass("icon-" + icon).addClass("icon-" + options.color);
        return options.html ? $icon.wrap("<p>").parent().html() : $icon;
      } else { throw "ArgumentError"; }
    },
    rating: function(rating, options) {
      _.defaults(options || (options = {}), {
        max: 5,
        html: false,
        title: undefined,
        totalRatings: undefined
      });
      if(rating < 0) { rating = 0; }
      if(rating > options.max) { rating = options.max; }
      var full = Math.floor(rating),
        decimal = rating - full,
        empty = options.max - full - 1,
        stars = $("<span></span>").addClass("stars"),
        suiRating = $("<span></span>").addClass("sui-rating").append(stars);

      _(full).times(function() {
        stars.append(SUI.icon("starorange"));
      });
      if(full < options.max) {
        if(decimal >= 0 && decimal < 0.25) { stars.append(SUI.icon("stargray")); }
        else if(decimal >= 0.25 && decimal < 0.75) { stars.append(SUI.icon("starhalf")); }
        else { stars.append(SUI.icon("starorange")); }
        _(empty).times(function() {
          stars.append(SUI.icon("stargray"));
        });
      }

      if(typeof options.totalRatings !== 'undefined') {
        $("<span></span>")
          .addClass("total-ratings")
          .text("(" + options.totalRatings + ")")
          .appendTo(suiRating);
      }

      if(typeof options.title !== 'undefined') {
        suiRating.attr("title", options.title);
      }

      return options.html ? suiRating.wrap("<p>").parent().html() : suiRating;
    }
  };

  _.extend(SUI, Helpers);
})(jQuery);
/************************************************************
* About: SUIstickybox is a plugin to allow boxes
*   to stick to the window as the user scrolls past them.
*   To Use, simply call on whatever box you want to stick to
*   the window and when the user scrolls passed it, it will
*   "stick" to the window.
* Author: DavidBrear (davidbr)
* Date: 1/25/2012
************************************************************/


(function($){

  //add a class for when the box is stuck.
  //  options:
  //    stickyClass: class to apply when 'stuck'
  //    fixedHeaderHeight: the height of any fixed navigation on the page
  $.fn.SUIstickybox = function(options)
  {
    if( $UI.mobileView() ) { return; }

    $(this).each( function(idx, el) {
      var new_sticky = new StickyBox(el, options);
      $(window).scroll( function(evt) {
  new_sticky.updateTop();
      });
    });
  };

  function StickyBox(el, options)
  {
    this.el = $(el);

    var defaultHeaderHeight = jQuery('nav.navbar .primary').height();

    this.options = $.extend({'stickyClass':'', 'fixedHeaderHeight':defaultHeaderHeight}, options);

    this.original_position = this.el.css('position');
    this.original_left = this.el.css('left');
    this.original_top = this.el.css('top');
    this.original_width = this.el.width();
    this.original_z_index = this.el.css('z-index');

    if( this.options.width ) { this.options.width += 'px'; }

    this.off_left = undefined;
    this.off_top = undefined;
    this.placeHolder = createPlaceHolder(this.el);

    this.resetElement = function() {
      this.el.removeClass(this.options.stickyClass);
      this.el.css('position', this.original_position);
      this.el.css('left', this.original_left);
      this.el.css('top', this.original_top);
      this.el.css('z-index', this.original_z_index);
      this.placeHolder.hide();
      this.off_left = undefined;
      this.off_top = undefined;
    };

    this.updateTop = function()
    {
      if(this.off_left === undefined) {
        this.off_left = this.el.offset().left;
      }
      if(this.off_top === undefined) {
  this.off_top = this.el.offset().top - this.options.fixedHeaderHeight;
      }
      if($(window).scrollTop() > this.off_top)
      {
  this.el.css('width', this.options.width || this.original_width);
  this.el.css('top', this.options.fixedHeaderHeight + 'px');
  this.el.css('left', this.off_left);
  this.el.css('position', 'fixed');
  this.el.css('z-index', 999);
  this.el.addClass(this.options.stickyClass);
  this.placeHolder.show();
      }
      else
      {
        this.resetElement();
      }
    };

    var self = this;

    $(window).resize( function() {
      self.resetElement();
      self.updateTop();
    });
  }

  function createPlaceHolder(el)
  {
    $place_holder = el.clone(false);
    $place_holder.attr('id', $place_holder.attr('id') + '_placeholder');
    $place_holder.html('abcd');
    $place_holder.css('width', el.width());
    $place_holder.css('height', el.height());
    $place_holder.css('visibility', 'hidden');
    $place_holder.hide();
    el.after($place_holder);
    return $place_holder;
  }
})(jQuery);
/*******************************/
/* Join-And-Login Pseudo-Modal */
/*******************************/
/* The pseudo-modal box that includes the Join form _and_ Login form. Also includes the "mainModal" */
/* which is the instance of the "pseudo-modal" that actually pops up on most pages as a real modal  */

var JoinAndLogin = {
  modalShowing: (window.location.pathname == '/join' || window.location.pathname == '/login'),
  mainModalSelector: '#join-login-modal > .modal',
  mainModal: null,

  init: function() {
    this.mainModal = jQuery(this.mainModalSelector);

    jQuery('.login-toggle > a').click( function(event) {
      event.preventDefault();
      JoinAndLogin.switchToLogin( jQuery(this).parents('.modal') );
    });

    jQuery('.join-toggle > a').click( function(event) {
      event.preventDefault();
      JoinAndLogin.switchToJoin( jQuery(this).parents('.modal') );
    });

    jQuery('a[data-toggle="password_reset"]').click( function(event) {
      event.preventDefault();
      JoinAndLogin.switchToPasswordReset( jQuery(this).parents('.modal') );
    });

    jQuery('.join-login-box.modal').on( 'shown', function(event) {
      var modal = jQuery(event.currentTarget);
      if( modal.hasClass('login-mode') ) {
        modal.find('input[name="login[email]"]').focus();
      }
      else {
        modal.find('input[name="registration[first_name]"]').focus();
      }
    });

    JoinAndLogin.registerModalLaunchTrigger();
  },

  show: function() {
    if( !this.mainModal || this.modalShowing ) { return; }
    this.mainModal.on('hide', function () {
      JoinAndLogin.modalShowing = false
    });
    this.mainModal.modal('show');
    this.modalShowing = true;
  },
  hide: function() {
    if( !this.mainModal || !this.modalShowing ) { return; }
    this.mainModal.modal('hide');
    this.modalShowing = false;
  },
  showJoin: function(options) {
    if( !this.mainModal ) { return; }
    if( options && options.message ) {
      this.mainModal.find('.message').html(options.message).show();
    }
    JoinAndLogin.switchToJoin( this.mainModal );
    JoinAndLogin.show();
  },
  showLogin: function() {
    if( !this.mainModal ) { return; }
    JoinAndLogin.switchToLogin( this.mainModal );
    JoinAndLogin.show();
  },
  registerModalLaunchTrigger: function() {
    jQuery(document).on( 'click', 'a[data-toggle="modal"][data-modal-name="join"]', function(event) {
      event.preventDefault();
      JoinAndLogin.showJoin();
    });

    jQuery(document).on( 'click', 'a[data-toggle="modal"][data-modal-name="login"]', function(event) {
      event.preventDefault();
      JoinAndLogin.showLogin();
    });
  },
  switchToJoin: function(modal) {
    modal.find('.register-form').attr('style',''); /* Clear the 'hide' style */
    modal.find('.login-form').attr('style',''); /* Clear the 'hide' style */

    if( modal.is(':visible') ) {
      modal.find('.login-form').fadeOut( function() {
        modal.find('.register-form').hide();
        modal.removeClass('login-mode');
        modal.removeClass('password-reset-mode');
        if( !modal.find('.social-register').is(':visible') ) {
          JoinAndLogin.blindInSocialAndPassword(modal);
        }
        modal.addClass('join-mode');
        modal.find('.register-form').delay(200).fadeIn();
      });
    }
    else {
      modal.removeClass('login-mode');
      modal.addClass('join-mode');
    }
  },
  switchToLogin: function(modal) {
    modal.find('.register-form').attr('style',''); /* Clear the 'hide' style */
    modal.find('.login-form').attr('style',''); /* Clear the 'hide' style */

    if( modal.is(':visible') ) {
      modal.find('.register-form').fadeOut( function() {
        modal.find('.login-form').hide();
        modal.removeClass('join-mode');
        modal.addClass('login-mode');
        modal.find('.login-form').delay(200).fadeIn();
      });
    }
    else {
      modal.removeClass('join-mode');
      modal.addClass('login-mode');
    }
  },
  switchToPasswordReset: function(modal) {
    var loginForm = modal.find('.login-form');

    var passwordRow = loginForm.find('input[type="password"]').parents('.control-group');

    var oldAction = loginForm.attr('action');
    loginForm.attr( 'action', loginForm.attr('data-alternate-action') );
    loginForm.attr( 'data-alternate-action', oldAction );

    if( passwordRow.is(':visible') ) { /* Going _into_ password reset mode */
      // Want to use normal HTML form for login (for browser password autofill) so we have to
      // enable/disable json_form() when we switch to/from password reset
      loginForm.json_form();

      modal.addClass('password-reset-mode');

      modal.find('.social-register').hide('blind');
      modal.find('.or-divider').hide('blind');
      passwordRow.hide('blind');
    }
    else {
      // Want to use normal HTML form for login (for browser password autofill) so we have to
      // enable/disable json_form() when we switch to/from password reset
      loginForm.json_form('destroy');

      modal.removeClass('password-reset-mode');
      JoinAndLogin.blindInSocialAndPassword(modal);
    }
  },
  blindInSocialAndPassword: function(modal) {
    modal.find('.social-register').show('blind');
    modal.find('.or-divider').show('blind');
    modal.find('.login-form input[type="password"]').parents('.control-group').show('blind');
  }
};

jQuery(function() {
  JoinAndLogin.init();
});

/***********************************************************************/
/* Join functionality _not_ related to the Join-And-Login Pseudo-Modal */
/***********************************************************************/
var Join = {
  showModal: function() {
    if (Application.inDevelopment()) {
      console.log( "Join.showModal is deprecated. Please use JoinAndLogin.showJoin()." );
    }
    JoinAndLogin.showJoin();
  },
  hideModal: function() {
    if (Application.inDevelopment()) {
      console.log( "Join.hideModal is deprecated. Please use JoinAndLogin.hide()." );
    }
    JoinAndLogin.hide();
  },
  initCheckboxes: function() {
    $$('ul.bundles li').each(function(element) {
      var checkbox = element.down('input[type=checkbox]');
      var checked = element.down('div.checkbox span.checked');
      var unchecked = element.down('div.checkbox span.unchecked');
      if(checkbox.checked) {
        unchecked.hide();
        element.addClassName('checked');
      }
      else {
        checked.hide();
      }
      element.observe('click', Join.toggleCheckbox.curry(element));
    });
  },
  toggleCheckbox: function(list_item) {
    var checkbox = list_item.down('input.checkbox');
    var checked = list_item.down('div.checkbox span.checked');
    var unchecked = list_item.down('div.checkbox span.unchecked');
    if(checkbox.checked) {
      checked.hide();
      unchecked.show();
      list_item.removeClassName('checked');
      checkbox.checked = false;
    }
    else {
      unchecked.hide();
      checked.show();
      list_item.addClassName('checked');
      checkbox.checked = true;
    }
  },
  checkSpicy: function(form) {
    /*get the names of the spicy picks and removed them from the form so the info is not cloging the logs*/
    var spicyCheckBox = form.down('#spicy_picks input.checkbox');
    var spicyNames = $('spicy_picks_names');
    var extraData = spicyNames.readAttribute('value');

    if (spicyCheckBox.checked === false) { /* if its NOT checked*/
       spicyNames.remove();
    }
  },
  checkCaptchaAndSubmitVerifyForm: function(clicked_image,correct_image,image_name) {
    var errorField = jQuery('#it_captcha .error');
    errorField.html('').hide();

    // If user already succeeded, don't do anything
    if( this.captcha_success === true ) { return; }

    if( this.captcha_click_count === undefined || this.captcha_click_count === null ) {
      this.captcha_click_count = 0;
    }

    // Max out at 11
    if( this.captcha_click_count < 10 ) {
      this.captcha_click_count += 1;
    }
    else {
      this.captcha_click_count = 'MAX';
    }

    GoogleAnalytics.trackEvent('Join', 'Captcha Click ' + this.captcha_click_count, image_name);

    if( clicked_image != correct_image ) {
      errorField.html('Nope. We\'re pretty sure that\'s IT related. Care to give it another go?').show();
      GoogleAnalytics.trackEvent('Join', 'Captcha Failure Click', 'Click ' + this.captcha_click_count);
      return;
    }
    else {
      GoogleAnalytics.trackEvent('Join', 'Captcha Success Click', 'Click ' + this.captcha_click_count);
      this.captcha_success = true;
    }

    jQuery.ajax('/join/get_random_code', {
      success: function(data) {
        errorField.removeClass('error').addClass('success');
        errorField.html('You ARE human! Processing your registration...')
        errorField.show();

        var form = jQuery('#it_captcha form.bot-form');
        form.append('<input type="hidden" name="code" id="code" value="' + data  + '" />');
        form.submit();
      },
      error: function() {
        errorField.html("Sorry, there was an error! Please try again or <a href='mailto:support@spiceworks.com'>contact support</a>.").show();
      }
    });
  },
  guestState: function(data) {
        if( this.guest_state === null || this.guest_state === undefined ) {
            this.guest_state = {};
        }

        if( data !== null && data !== undefined ) {
            if( data.content_type != this.guest_state.content_type ) {
                this.guest_state = data;
            }
            else {
                jQuery.extend( this.guest_state, data );
            }
        }

        var date = new Date();
        date.setTime( date.getTime()+(1*24*60*60*1000) );
        Cookie.set('guest_state', JSON.stringify( this.guest_state ), { path: '/', expires: date } );

        return this.guest_state;
  },
  addParamToReferer: function( name, value ) {
    var fieldValue = jQuery('#referer').val();

    if( jQuery.trim(fieldValue) == '' ) {
      fieldValue = '/?';
    }

    var queryLocation = fieldValue.indexOf('?');

    if( queryLocation < 0 ) {
      fieldValue += '?';
    }
    else if( queryLocation != fieldValue.length-1 ) {
      fieldValue += '&';
    }

    jQuery('#referer').val( fieldValue + name + '=' + value );
  },
  addOptimizelyParamToReferer: function( name, value ) {
    Join.addParamToReferer( 'optimizely_' + name, value );
  },
  addOptimizelyVariationName: function( variation_name ) {
    Join.addOptimizelyParamToReferer( 'variation', variation_name );
  },
  showPhotoModal: function(fromDigest) {
    var cookieName = 'photo_modal_shown';

    if( !Cookie.get(cookieName) || fromDigest ) {
      var date = new Date();
      date.setTime( date.getTime()+(1*24*60*60*1000) );
      Cookie.set(cookieName, 'PhotoModalShown', { path: '/', expires: date } );

      if( !fromDigest ) {
        setTimeout( function() {
          jQuery('#photo-join-modal').modal('show');
          jQuery('#marketer-photo-join-modal').modal('show');
        }, 6000 );
      }
    }
  }
};

/************************************************************************/
/* Login functionality _not_ related to the Join-And-Login Pseudo-Modal */
/************************************************************************/
var Login = {
  showConnectExisting:function() {
    jQuery("#setup_new_account").slideUp(250, function() {
      jQuery("#setup_existing_connection").slideDown(250);
    });
  },
  showSetupNew:function() {
    jQuery("#setup_existing_connection").slideUp(250, function() {
      jQuery("#setup_new_account").slideDown(250);
    });
  },
  socialJoinWindowName: 'sw_social_join',
  showSocialSiteLogin: function(social_nw_provider_name, referer_url) {
    if( Join.guest_state === null || Join.guest_state === undefined ) {
      GoogleAnalytics.trackEvent("Join", social_nw_provider_name + " button clicked", "No Guest State");
    } else {
      GoogleAnalytics.trackEvent("Join", social_nw_provider_name + " button clicked", "With Guest State", 1);
    }

    JoinAndLogin.hide();

    if (referer_url !== undefined  &&  referer_url !== null  && referer_url.length > 0) {
      Cookie.set('social_auth_referer_url', referer_url, {path: '/'});
    } else {
      where = document.location;
      Cookie.set('social_auth_referer_url', where, {path: '/'});
    }

    var window_opts = (social_nw_provider_name == 'daniweb' ) ? "width=1024,height=430" : "width=760,height=430";
    window.open("/auth/" + social_nw_provider_name, Login.socialJoinWindowName, window_opts);
  }
};
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var SpiceworksAnalytics = (function($){

  var STATS_AJAX_URL = "/api/community_stats.json";

  function addEvent(controller, action, params) {
    try {
      if (controller == null || action == null) {
        return false;
      }
      params = params || {};

      $.post( STATS_AJAX_URL, $.extend(params, { c: controller, a: action }) );
    } catch (e) {
      // We don't want recording analytics to ever interfere with the
      // functioning of the application, so if an error occurs, just
      if (console && console.log) {
        console.log(e);
      }
    }
  }

  return {
    addEvent: addEvent
  };

})(jQuery);
/*************************************************************************************************/
/*  MobileCollapsedLinkLists */
/*************************************************************************************************/

$(function($) {

  window.MobileCollapsedLinkLists = {
    findAndCollapse: function() {
      if( ! $UI.mobileView() ) { return; }
      
      jQuery("[data-mobile-collapse]").each(function(index, section) {
        var min = 3
        if(jQuery(section).find("li").length > min) {
          var name = jQuery(section).attr("data-mobile-collapse");
          var additional = jQuery('<ul class="collapsed-more-links" style="display: none;" id="' + name  + '_more_links"></ul>');
          jQuery(section).after(additional);
          jQuery(section).find("li").each(function(index, item) {
            if(index >= min) {
              additional.append(item);
            }
          });
          jQuery(section).after('<a href="#" class="collapsed-see-more" id="' + name + '_see_more">+ See More</a>');
          jQuery("#" + name + "_see_more").click(function(e) {
            e.preventDefault();
            jQuery("#" + name + "_see_more").hide();
            jQuery("#" + name + "_more_links").slideDown();
          });
        }
      });
    }
  };

  $(function() { MobileCollapsedLinkLists.findAndCollapse(); });
  $(document).ajaxComplete( MobileCollapsedLinkLists.findAndCollapse );
  document.observe( 'ajax:completed', MobileCollapsedLinkLists.findAndCollapse );

}(jQuery));


/*************************************************************************************************/
/*  MovingSecitons */
/*************************************************************************************************/
$(function($) {

  window.MobileMovingSections = {
    findAndMove: function() {
      if( ! $UI.mobileView() ) { return; }

      jQuery("[data-mobile-target]").each(function(index, section) {
        var value = jQuery(section).attr("data-mobile-target");
        if(jQuery("[data-mobile-destination='" + value  + "']").length > 0) {
          jQuery("[data-mobile-destination='" + value + "']").append(jQuery(section).clone());
        }
      });
    }
  };

  $(function() { MobileMovingSections.findAndMove(); });
  $(document).ajaxComplete( MobileMovingSections.findAndMove );
  document.observe( 'ajax:completed', MobileMovingSections.findAndMove );

}(jQuery));


/*************************************************************************************************/
/*  MobileTabs - Convert tabs to sui-droplist if they are too wide to fit on the display         */
/*************************************************************************************************/

!(function($) {

  window.MobileTabs = {
    findAndConvert: function() {
      if( ! $UI.mobileView() ) { return; }

      $(".tabbed_menu ul, .nav-tabs, .rounded_tabs ul, .local_nav ul.sui-side-navigation, .section-navbar").each( function( index, tabs ) {
        if( MobileTabs.tabsNeedDropdown( $(tabs) ) && ! $(tabs).hasClass('sui-dropdown-menu') ) {
          MobileTabs.convert( $(tabs) );
        }
      });
    },
    convert: function(tabs) {
      var dropdown = $('<div class="sui-dropdown mobile-tabs"></div>');

      dropdown.insertBefore( tabs );
      dropdown.html( tabs );
      tabs.addClass('sui-dropdown-menu');

      tabs.removeClass('nav').removeClass('nav-tabs');

      dropdown.prepend( $('<a href="#" class="sui-dropdown-toggle sui-bttn" data-toggle="dropdown" onclick="return false;"></a>') );
      MobileTabs.updateActive( dropdown, tabs.find('li.active a, li a.active') );

      tabs.find('a').on( 'click', function() {
        MobileTabs.updateActive( dropdown, $(this) );
      });

      tabs.parents('.local_nav').on( 'change', function(event) {
        MobileTabs.updateActive( dropdown, $(event.target).find('li.active a, li a.active') );
      });
    },
    tabsNeedDropdown: function(tabs) {
      var total_width = 0;
      tabs.find("li").each(function(index, item) {
        total_width += $(item).outerWidth(true);
      });
      return total_width >= $(tabs).parent().width();
    },
    updateActive: function(dropdown, activeItem ) {
      dropdown.find('.sui-dropdown-toggle').html( activeItem.text() + ' <span class="caret"></span>' );
    }
  };
  $(function() { MobileTabs.findAndConvert(); });
  $(document).ajaxComplete( MobileTabs.findAndConvert );
  document.observe( 'ajax:completed', MobileTabs.findAndConvert );

}(jQuery));

/*************************************************************************************************/
/*  MobilePagination - Convert pagination to next/prev button and sui-droplist for page numbers  */
/*************************************************************************************************/

!(function($) {

  window.MobilePagination = {
    findAndConvert: function() {
      if( ! $UI.mobileView() ) { return; }

      $('.pages, .pagination').each( function(index,pages) {
        if( ! $(pages).find('ul').hasClass('sui-dropdown-menu') ) {
          MobilePagination.convert( $(pages) );
        }
      });
    },
    convert: function(pages) {
      var nextLink = pages.find('.next,.next_page');
      var prevLink = pages.find('.prev,.previous,.previous_page');

      pages.find('.next,.next_page,.prev,.previous,.previous_page').addClass('mobile-page-bttn');
      prevLink.addClass('previous').html('Previous');
      nextLink.addClass('next').html('Next');

      var numberedLinks = pages.find('ul');
      if( numberedLinks.find('*').size() > 0 ) {
        var wrapper = $('<div class="mobile-page-numbers"></div>');
        var dropdown = $('<div class="sui-dropdown"></div>');

        wrapper.append(dropdown);

        wrapper.insertBefore( numberedLinks );
        dropdown.html( numberedLinks );
        numberedLinks.addClass('sui-dropdown-menu');
        numberedLinks.find('li').removeClass('active');
        numberedLinks.find('li.gap').addClass('divider').html('');
        numberedLinks.find('li span.gap').parent().addClass('divider').html('');

        var currentPage = numberedLinks.find('li .current').html();
        dropdown.prepend( $('<a href="#" class="sui-dropdown-toggle" data-toggle="dropdown" onclick="return false;">Page ' + currentPage + ' <span class="caret"></span></a>') );

        numberedLinks.find('li > *').each( function(index, el) { $(el).html( 'Page ' + $(el).html() ); });

        numberedLinks.find('a').on( 'click', function() {
          MobilePagination.updateActive( dropdown, $(this) );
        });
      }
    },
    updateActive: function(dropdown, activeItem) {
      dropdown.find('.sui-dropdown-toggle').html( activeItem.text() + ' <span class="caret"></span>' );
    }
  };
  $(function() { MobilePagination.findAndConvert(); });
  $(document).ajaxComplete( MobilePagination.findAndConvert );
  document.observe( 'ajax:completed', MobilePagination.findAndConvert );

}(jQuery));
(function() {
  this.JST || (this.JST = {});
  this.JST["backbone/teleporter/templates/result"] = function(obj){var __p=[],print=function(){__p.push.apply(__p,arguments);};with(obj||{}){__p.push('<div class="background ',  type ,'"></div>\n<div class="name name-',  type ,'">',  name ,'</div>\n<div class="subtext">',  subtext ,'</div>\n');}return __p.join('');};
}).call(this);



$UI.app.module('Teleporter', function(Teleporter, App, Backbone, Marionette, $, _) {
  "use strict";

  Teleporter.Models      = {};
  Teleporter.Collections = {};
  Teleporter.Views       = {};

  App.addRegions({
    'ResultsRegion': '#teleporter .results ul'
  });

  Teleporter.Models.Result = Backbone.Model.extend({
    defaults: {
      selected: false
    }
  });

  Teleporter.Collections.Results = Backbone.Collection.extend({
    model: Teleporter.Models.Result,
    url: '/teleport/search',
    initialize: function() {
      this.on('reset', function(event) {
        if(this.length > 0) {
          this.first().set('selected', true);
        }
      });
    }
  });

  /*===========================================================================
   * Views
   *=========================================================================*/

  Teleporter.Views.Result = Backbone.Marionette.ItemView.extend({
    template: JST['backbone/teleporter/templates/result'],
    tagName: 'li',
    modelEvents: {
      'change': 'render'
    },
    events: {
      'click': 'submit',
      'hover': 'hover',
      'mouseleave': 'unhover'
    },
    submit: function(event) {
      // submit this to the controller!
      var params = {
        id:   this.model.get('id'),
        type: this.model.get('type')
      };

      var query = $('#teleporter input').val()
      if(this.model.get('type') === 'Search') {
        params.query = query;
      }

      GoogleAnalytics.trackEvent('QuickNav', 'Item selected', this.model.get('name') + ' - ' + params.type + ' - "' + query + '"');

      // yes, this is kind of a hack, but bear with me plz...
      window.location = '/teleport?' + jQuery.param(params);
    },
    hover: function(event) {
      // change the currently selected thing
      $('#teleporter li').removeClass('current');
      $(event.target).addClass('current');
    },
    unhover: function(event) {
      $(event.target).removeClass('current');
    },
    onRender: function(event) {
      // add the "selected" class if the boolean is set!
      if(this.model.get('selected')) {
        this.$el.addClass('current');
      }
    }
  });

  Teleporter.Views.Results = Backbone.Marionette.CollectionView.extend({
    itemView: Teleporter.Views.Result
  });

  /*===========================================================================
   * Controller
   *=========================================================================*/

  Teleporter.Controller = Backbone.Marionette.Controller.extend({
    curItem: 1,
    animationSpeed: 0.2,
    fadeIn: function() {
      GoogleAnalytics.trackEvent('QuickNav', 'Opened');
      $('#teleporter').fadeIn(this.animationSpeed);
      var input = $('#teleporter input');
      input.val('');
      input.focus();
      this.curItem = 0;
    },
    fadeOut: function() {
      $('#teleporter').fadeOut(this.animationSpeed, function() {
        $('a.brand').focus();
      });
      this.curItem = 0;
    },
    // add more here, for the sake of readability ಠ_ಠ
    keycodes: {
      q: 81,
      tab: 9
    }
  });

  /*===========================================================================
   * Initializer
   *=========================================================================*/

  Teleporter.addInitializer(function(options) {
    var results = new Teleporter.Collections.Results();
    var resultsView = new Teleporter.Views.Results({collection: results});

    // set up a few events
    var controller = new Teleporter.Controller();
    var input = $('#teleporter input');

    // update when keys are pressed
    input.keyup(function(event) {
      // don't fetch if it's the arrow keys!
      if(_.contains([38,40], event.keyCode)) {
        event.preventDefault();
        return true;
      }

      var elem = $(event.target);
      results.fetch({
        data: { q: elem.val() },
        processData: true,
        reset: true,
        success: function() {
          // reset the current item to the top when we get stuff back
          controller.curItem = 0;
        }
      });

      $('#teleporter .results').show();
    });

    // fade out when we lose focus
    input.blur(controller.fadeOut);

    // "state machine" for detecting keystroke combination (tab + q)
    var waitForQ = false;

    // event listener for triggering the dialog
    $(document).keydown(function(event) {
      var key = event.keyCode;
      if(key === controller.keycodes.tab) {
        waitForQ = true;
      } else if(key === controller.keycodes.q && waitForQ) {
        // SHOW THE THING
        event.preventDefault();
        results.reset();
        controller.fadeIn();

        waitForQ = false;
        return true; // exit out, ignore the rest of the code
      } else {
        waitForQ = false;
      }

      return true;
    });

    // if they let go of tab while waiting for the Q key just cancel everything
    $(document).keyup(function(event) {
      var key = event.keyCode;
      if(waitForQ && key === controller.keycodes.tab) {
        waitForQ = false;
      }
    });

    // handle everything key-wise inside the dialog...
    $(document).keydown(function(event) {
      var key = event.keyCode;

      if(key === 27) {
        // escape key
        controller.fadeOut();
      } else if(_.contains([38,40], key) && $('#teleporter').is(':visible')) {
        event.preventDefault();
        
        // arrow keys
        if(key === 38) {        // up arrow
          if(controller.curItem === 1) {
            controller.curItem = results.length;
          } else {
            controller.curItem--;
          }
        } else if(key === 40) { // down arrow
          if(controller.curItem === (results.length)) {
            controller.curItem = 1;
          } else {
            controller.curItem++;
          }
        }

        $('#teleporter li').removeClass('current');
        $('#teleporter li:nth-child(' + controller.curItem + ')').addClass('current');
      } else if(key === 13 && $('#teleporter').is(':visible')) {
        event.preventDefault();
        // oh no, they pressed ENTER! Simulate a click event out of laziness...
        $('#teleporter li.current').click();
      }
    });

    App.ResultsRegion.show(resultsView);
  });
});
var MspProfile = {
  init: function($) {
    MspProfile.initEmployeeHoverEvents($);

    MspProfile.initColorPicker($);
    // start the backbone application!
    MspProfile.initBackbone();
  },
  initColorPicker: function($) {
    var container = $('.color-picker');
    // sorry about the mess :(
    var colors = [[5,40,58],[4,16,75],[13,2,45],[34,0,47],[48,2,20],[75,0,2],[70,20,1],[70,39,3],[67,47,3],[82,80,4],[62,71,6],[31,51,12],[11,89,123],[6,44,154],[32,4,99],[75,1,103],[100,14,48],[165,6,6],[154,44,5],[150,84,5],[148,106,6],[183,177,8],[135,153,14],[63,104,29],[18,145,207],[7,67,254],[57,0,164],[129,1,171],[168,24,75],[252,39,17],[251,83,8],[253,154,9],[250,189,9],[255,255,50],[209,234,42],[101,178,51],[71,204,252],[98,148,254],[113,42,253],[197,50,254],[231,87,142],[253,116,111],[252,147,104],[254,186,98],[253,209,98],[253,251,131],[229,242,125],[162,216,122],[191,238,255],[201,219,255],[206,187,255],[237,185,253],[246,201,219],[252,208,204],[254,218,205],[254,232,202],[255,239,202],[253,254,211],[248,250,211],[216,234,201],[255,255,255],[255,255,255],[255,255,255],[239,239,239],[208,208,208],[176,176,176],[149,149,149],[108,108,108],[70,70,70],[49,49,49],[29,29,29],[0,0,0]];

    $.each(colors, function() {
      var r = this[0];
      var g = this[1];
      var b = this[2];
      var elem = $('<div class="color">');
      var bg_css = 'rgb(' + r + ',' + g + ',' + b + ')';
      elem.css('background', bg_css);
      elem.attr('data-bg-color', bg_css);
      elem.appendTo(container);

      elem.click(function(event) {
        // update the color-bar color, save to server
        $('.color-bar').css('background-color', bg_css);
        $('.color-picker .selected').removeClass('selected');
        elem.addClass('selected');

        // update preview
        $('.color-bar-preview').css('background-color', bg_css);

        // update things server-side
        $.post('/service-providers/save_about', {
          id: MSP_PROFILE_ID,
          'msp_profile[color]': bg_css
        });
      });
    });

    // add the custom thingy -- prepend to white one

    // highlight the existing color (if it exists, if not no biggie)
    jQuery('.color[data-bg-color="' + jQuery('.color-bar').css('background-color').gsub(' ', '') + '"]').last().addClass('selected');

    // init background select event
    $('.backgrounds .background').click(function(event) {
      $('.backgrounds .background').removeClass('selected');
      var elem = $(event.target);
      elem.addClass('selected');
      var base_path = '//static.spiceworks.com/assets/community/msps/backgrounds/';
      var bg_name = elem.attr('data-name');
      var background = base_path + bg_name + '.png';
      $('.color-bar').css('background-image', 'url(' + background + ')');

      // update preview
      $('.color-bar-preview').css('background-image', 'url(' + background + ')');

      // save this preference to the server!
      $.post('/service-providers/save_about', {
        id: MSP_PROFILE_ID,
        'msp_profile[background_image]': bg_name
      });
    });

    // highlight current background
    jQuery('.background[data-name="' + jQuery('.color-bar').attr('data-bg') + '"]').addClass('selected');
  },
  initBackbone: function() {
    MspProfile.locations = new SPICEWORKS.MspProfile.Collections.MspLocations;
    MspProfile.locations.fetch();
    SPICEWORKS.MspProfile.start({locations: MspProfile.locations});
  },
  unpublish: function() {
    // POST request to update things server-side
    jQuery.post('/service-providers/save_about', {
      id: MSP_PROFILE_ID,
      'msp_profile[published]': false
    }).then(function() {
      window.location.reload(true);
    });
  },
  publish: function() {
    // POST request to update things server-side
    jQuery.post('/service-providers/save_about', {
      id: MSP_PROFILE_ID,
      'msp_profile[published]': true
    }).then(function() {
      window.location.reload(true);
    });
  },
  deleteProfile: function() {
    // SHOW THAT MODAL THING
    jQuery('#delete_modal').modal('show');
  },
  undeleteProfile: function() {
    jQuery.post('/service-providers/update', {
      id: MSP_PROFILE_ID,
      ajax: true,
      msp_profile: {
        deleted: false
      }
    }).then(function() {
      document.location.reload();
    });
  },
  showEditReferences: function() {
    if(!jQuery('#msp_edit_references').is(':visible')) {
      jQuery('#msp_references').hide();
      jQuery('#msp_edit_references').show();
    }

    jQuery('#msp_edit_references form').on('ajax:success', function() {
      //var data = CKEDITOR.instances['msp_profile_references'].getData();
      var data = jQuery('#msp_profile_references').val();
      jQuery('.msp-references-data').html(_.escape(data));
      MspProfile.cancelEditReferences();
    });
  },
  cancelEditReferences: function() {
    if(jQuery('#msp_edit_references').is(':visible')) {
      jQuery('#msp_edit_references').hide();
      jQuery('#msp_references').show();
    }
  },
  showEditRates: function() {
    if(!jQuery('#msp_edit_rates').is(':visible')) {
      jQuery('#msp_rates').hide();
      jQuery('#msp_edit_rates').show();
    }

    jQuery('#msp_edit_rates form').on('ajax:success', function(event) {
      event.preventDefault();
      var data = jQuery('#msp_profile_rates').val();
      jQuery('.msp-rates-data').html(_.escape(data));
      MspProfile.cancelEditRates();
    });
  },
  cancelEditRates: function() {
    if(jQuery('#msp_edit_rates').is(':visible')) {
      jQuery('#msp_edit_rates').hide();
      jQuery('#msp_rates').show();
    }
  },
  joinModal: null,
  saveNewInfoAndLoginOrJoin: function( event ) {
    event.preventDefault();

    var form = jQuery(event.target);

    if( !MspProfile.checkMspCreationForm(form) ) {
      return;
    }

    var msp_data = { content_type: 'MspProfileStart' };

    jQuery.each( ['company_name','city','country','state','zip_code'], function(index,field) {
      msp_data[field] = form.find(':input[name="msp_profile_start[' + field + ']"]').val();
    });

    Join.guestState( msp_data );

    if( !this.joinModal ) {
      jQuery('#msp-join-modal .modal .modal-header h3').html('Step 1: Create Spiceworks Account');
      jQuery('#msp-join-modal .modal .message').html('To manage your page, <strong>you need a Spiceworks account</strong>.').show();
      this.joinModal = jQuery('#msp-join-modal .modal');
      this.joinModal.addClass('msp-join-modal');
    }
    this.joinModal.modal('show');
  },
  loggedInCheck: function(event) {
    var form = jQuery(event.target);

    if( !MspProfile.checkMspCreationForm(form) ) {
      event.preventDefault();
    }
  },
  checkMspCreationForm: function(form) {
    var errors = false;
    var max_lengths = { 'company_name': 255, 'state': 50, 'city': 50, 'zip_code': 20 };
    [ 'company_name', 'city', 'country', 'state', 'zip_code' ].each( function(field_name) {
      var field = form.find('[name="msp_profile_start[' + field_name + ']"]');
      var control_group = field.parents('.control-group');

      control_group.removeClass('error');
      control_group.find('.controls .help-inline').remove();

      if( field.val() === null || field.val() === '' ) {
        control_group.addClass('error');
        control_group.find('.controls').append('<span class="help-inline">is required</span>');
        errors = true;
      }
      else if( max_lengths[field_name] && field.val().length > max_lengths[field_name] ) {
        control_group.addClass('error');
        control_group.find('.controls').append('<span class="help-inline">is too long (max ' + max_lengths[field_name] + ')</span>');
        errors = true;
      }
    });

    return !errors;
  },
  deleteLogo: function() {
    var deleteForm = jQuery('#edit_logo_modal form[data-action="destroy"]');
    if( window.confirm('Are you sure?') ) {
      deleteForm.submit();
      MspProfile.updateProgress();
    }
  },
  primaryLocation: {},
  otherLocations: [],
  openPrimaryLocationEditModal: function() {
    var data = MspProfile.primaryLocation;
    data.id = MspProfile.primaryLocation.id;
    var modal = jQuery('#edit_all_locations_modal');

    modal.find('form').msp_location_form( 'loadData', data );

    modal.find('input[name="id"]').val( data.id );
    modal.modal('show');
  },
  addLocation: function() {
    mspId = MSP_PROFILE_ID;

    var modal = jQuery('#edit_location_modal');
    modal.find('.modal-header h3').text('New Location');

    var form = modal.find('form[data-form-for="MspLocation"]');
    form.attr('action', 'http://community.spiceworks.com/msp_location');
    form.find('input').val('');
    form.msp_location_form( 'loadData', { id: mspId, country: MspProfile.defaultCountry } );
    modal.find('#msp_location_address1').focus();

    modal.modal('show');
  },
  editLocationById: function( data ) {
    jQuery('#edit_all_locations_modal').modal('hide');

    var modal = jQuery('#edit_location_modal');
    modal.find('.modal-header h3').text('Edit Location');

    var form = modal.find('form[data-form-for="MspLocation"]');
    form.attr('action', 'http://community.spiceworks.com/msp_location/update');
    form.msp_location_form( 'loadData', data );
    form.find('.delete-link').show();

    modal.find('form[data-action="destroy"] input[name="id"]').val( data.id );

    modal.modal('show');
  },
  deleteMember: function(_link) {
    var link = jQuery(_link);
    var mspId = link.attr('data-msp-id');
    var memberName = link.attr('data-member-name');

    if( window.confirm('Are you sure you want to remove this member?') ) {
      jQuery.ajax({
        type: "POST",
        url: 'http://community.spiceworks.com/service-providers/remove_user',
        data: { id: mspId, user_name:memberName },
        success: function() { link.parents('li.with_actions').fadeOut(); },
        error: function() { alert('Well, that didn\'t work as expected. Contact support if this happens again.'); }
      });
    }
  },
  editMode: false,
  initEmployeeHoverEvents: function($) {
    $('.employees-list img').mouseenter(function(event) {
      var elem = $(event.target);
      var id = elem.attr('data-id');
      $('.employee-details').hide();
      $('.employee-details[data-id="' + id + '"]').show();
    });

    $('.employees-list img').mouseleave(function(event) {
      $('.employee-details').hide();

      // show the first employee's details by default
      $('.employees-list img').first().trigger('mouseenter');
    });

    $('.employees-list img').first().trigger('mouseenter');
  },
  enableEditing: function($) {
    $('.done-editing-button').show();
    $('.edit-button').hide();
    $('.edit-field').fadeIn();
    $('.image-box').fadeIn();
    $('.edit-button').fadeOut();
    $('.contact-us-button').fadeOut();
    //$('#unpublished-bar').hide();
    MspProfile.editMode = true;

    GoogleAnalytics.trackEvent('MspProfile', 'Edit profile enabled');
  },
  disableEditing: function($) {
    $('.done-editing-button').hide();
    $('.edit-button').show();
    $('.edit-field').fadeOut();
    $('.edit-button').fadeIn();
    $('.contact-us-button').fadeIn();
    $('#msp-locations-container').slideUp();

    //if(!MSP_PUBLISHED) {
    //  $('#unpublished-bar').fadeIn();
    //}

    MspProfile.editMode = false;
  },
  updateProgress: function() {
    // retrieve new percentage!
    jQuery.ajax('/service-providers/' + '/completeness/' + MSP_PROFILE_ID)
    .done(function(resp) {
      if(resp.completeness === 100) {
        jQuery('.completeness-container').hide();
      } else {
        jQuery('.completeness-container').show();
      }
      jQuery('#completeness_bar').progressBar(resp.completeness);
      delete resp.completeness;
      jQuery.each(resp, function(name, val) {
        var elem = jQuery('#' + name);
        val ? elem.hide() : elem.show();
      });
    });
  },
  replaceLogo: function(img) {
    jQuery(img).attr('src', "//static.spiceworks.com/assets/community/icons/big/no_msp_logo-943b435eeeb3a88fc615d2d876fe6d23.png");
  },
  suggestService: function(elem) {
    var suggestion = jQuery('#suggested_service').val();
    jQuery.post('/service-providers/suggest_service', {suggestion: suggestion}, function(data) {
      if(data.success) {
        jQuery('#suggestion_success_message').show();
        jQuery('#suggested_service').val('');
      }
    });
  }
};

!function($) {

  "use strict";

 /* MspLocationForm PUBLIC CLASS DEFINITION
  * ========================================= */

  var MspLocationForm = function ( form_element, options ) {
    this.$form = $(form_element);
    this.options = options;
    init.call(this);
  };

  MspLocationForm.prototype = {
    constructor: MspLocationForm,

    loadData: function( data ) {
      var self = this;

      jQuery.each( data, function( name, value ) {
        /* Notice that this selector will find both state fields because the hidden one is named "not_state" */
        /* If that changes this will break */
        self.$form.find('[name*="' + name + '"]').val( value );
      });
      countryChanged.call(this);

      this.$form.find('input[name="id"]').val( data.id );
    }
  };

 /* MspLocationForm PRIVATE METHODS
  * =============================== */

  function init() {
    var self = this;
    this.$countrySelect = this.$form.find(':input[name*="country"]');
    this.$countrySelect.change( $.proxy(countryChanged, this) );
    hideStateSelectOrInput.call(this);
  }

  function hideStateSelectOrInput() {
    var inUSA = this.$countrySelect.val() == 'United States';
    var fieldToHide = this.$form.find( inUSA ? 'input[name*="state"]' : 'select[name*="state"]' );
    fieldToHide.attr('name', 'not_state');
    fieldToHide.parents('.control-group').hide();
  }

  function countryChanged() {
    var select_field = this.$form.find('select[name*="state"]');
    var text_field = this.$form.find('input[name*="state"]');
    var not_state_name = 'not_state'; /* This name is important, see note above about selector */

    if( this.$countrySelect.val() == 'United States' ) {
      if( text_field.attr('name') != not_state_name ) {
        select_field.attr('name', text_field.attr('name'));
        text_field.attr('name', not_state_name);
      }

      select_field.parents('.control-group').show();
      text_field.parents('.control-group').hide();
    }
    else {
      if( select_field.attr('name') != not_state_name ) {
        text_field.attr('name', select_field.attr('name') );
        select_field.attr('name', not_state_name);
      }

      text_field.parents('.control-group').show();
      select_field.parents('.control-group').hide();
    }
  }

 /* MspLocationForm PLUGIN DEFINITION
  * ================================= */

  $.fn.msp_location_form = function ( option, methodOptions ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('msp_location_form')
        , options = typeof option == 'object' && option
      if (!data) $this.data('msp_location_form', (data = new MspLocationForm(this, options)))
      if (option == 'loadData') data.loadData( methodOptions );
    });
  };

  $.fn.msp_location_form.Constructor = MspLocationForm;

  $(function () {
    jQuery('form[data-form-for="MspLocation"]').each( function(index,el) {
      $(el).msp_location_form();
    });
  });

}( window.jQuery );

var MspLocation = {
  expandMap:function(){
    var map_wrapper = $('service_providers_map');
    if(map_wrapper.hasClassName('expanded')){
      map_wrapper.removeClassName('expanded');
      map_wrapper.down('div.menu a.expand').update('Expand map');
    } else {
      map_wrapper.addClassName('expanded');
      map_wrapper.down('div.menu a.expand').update('Collapse map');
    }
    Map.resizeMap();
  }
};


if (typeof UrlHelpers === 'undefined') { UrlHelpers = {}; }

UrlHelpers.asset_path = function(path) {
    if( path[0] == '/' ) {
      return '//static.spiceworks.com/' + path.substring(1);
    }
    else {
      return '//static.spiceworks.com/assets/' + path;
    }
};

UrlHelpers.invitation_join_waiting_list_path = function() {
  return "/invitation/join_waiting_list";
};

UrlHelpers.invitation_activate_code_path = function() {
  return "/invitation/activate_code";
};

UrlHelpers.invitation_check_invitation_status_path = function() {
  return "/invitation/check_invitation_status";
};

UrlHelpers.invitation_peer_code_generate_path = function() {
  return "/invitation/peer_code_generate";
};


if (typeof SocialHelpers === 'undefined') { SocialHelpers = {}; }

SocialHelpers.sharePath = function( siteName, title, contentLink ) {
  var shareUrl = '';

  contentLink = 'http://community.spiceworks.com' + contentLink;
  title = encodeURIComponent(title);

  switch (siteName) {
    case 'twitter':
      shareUrl = 'http://twitter.com/intent/tweet?text=' + title + ' ' + contentLink;
      break;
    case 'facebook':
      shareUrl = 'http://www.facebook.com/sharer.php?u=' + contentLink + '&amp;t=' + title;
      break;
    case 'linkedin':
      shareUrl = 'http://www.linkedin.com/shareArticle?mini=true&amp;url=' + contentLink + '&amp;title=' + title;
      break;
    case 'reddit':
      shareUrl = 'http://www.reddit.com/submit?url=' + contentLink + '&amp;title=' + title;
      break;
    case 'googleplus':
      shareUrl = 'https://plus.google.com/share?url=' + contentLink + '&amp;title=' + title;
      break;
    case 'mail':
      shareUrl = 'mailto:?subject=Spiceworks%20Community:' + title + '&body=I%20wanted%20to%20share%20this%20page%20from%20the%20Spiceworks%20IT%20Community%20with%20you:%0D%0A' + contentLink;
      break;
  }

  return shareUrl;
}

if (typeof UIHelpers === 'undefined') { UIHelpers = {}; }

UIHelpers.socialSharingDropdown = function() {

}
;
