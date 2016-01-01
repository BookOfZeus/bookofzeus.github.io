/**
 * jTextHighlighter 1.0
 * 10/14/12
 *
 * Book Of Zeus <http://www.bookofzeus.com>
 * Copyright (c) 2009 Book Of Zeus
 */
$.fn.outerHTML = function() {
    return (!this.length) ? this : (this[0].outerHTML || (
      function(el) {
          var div = document.createElement('div');
          div.appendChild(el.cloneNode(true));
          var contents = div.innerHTML;
          div = null;
          return contents;
    })(this[0]));
}
jQuery.fn.jthighlight = function(word) {
	if($('mark.'+word).length) {
		return;
	}
	$("p:contains('" + word + "')").each(function() {
		var css = word.toLowerCase();
		var newWord = $('<mark>').addClass(css).html(word);
		var newHTML = $(this).html().replace(word, newWord.outerHTML());
		$(this).html(newHTML);
	});
};
jQuery.fn.clearHighlight = function(word) {
	var cls = '';
	if(typeof word != 'undefined') {
		cls = '.'+word;
	}
	$('mark'+cls).each(function() {
		$(this).contents().unwrap();
	});
};
$(document).ready(function() {
	$('p').dblclick(function(e) {
		var range = window.getSelection() || document.getSelection() || document.selection.createRange();
		var word = $.trim(range.toString());
		if(word != '') {
			$('p').jthighlight(word);
			range.collapse(range.anchorNode, range.anchorOffset);
		}
		e.stopPropagation();
	});
	$('p').on('dblclick','mark',function(e) {
		var word = $(this).html().toLowerCase();
		$('mark.'+word).each(function() {
			$(this).contents().unwrap();
		});
		e.stopPropagation();
	});
	$('#clearHighlight').click(function() {
		$('p').clearHighlight();
	});
});
