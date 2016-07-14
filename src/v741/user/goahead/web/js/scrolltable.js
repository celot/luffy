(function($) {
	$.fn.createScrollableTable = function(options) {
		var defaults = {
			width: '100%',
			height: '200px'
		};
		var options = $.extend(defaults, options);

		return this.each(function() {
			var table = $(this);
			prepareTable(table);
		});

		function prepareTable(table) {
			var tableName = table.attr('name');

			// wrap the current table (will end up being just body table)
			var bodyWrap = table.wrap('<div></div>')
									.parent()
									.attr('id', tableName + '_body_wrap')
									.css({
										width: options.width,
										'max-height': options.height,
										overflow: 'auto',
										'border-bottom': '1px solid #e0e0e0'
									});

			// wrap the body
			var tableWrap = bodyWrap.wrap('<div></div>')
									.parent()
									.attr('id', tableName + '_table_wrap')
									.css({
										overflow: 'hidden',
										display: 'inline-block'
									});

			// clone the header
			var headWrap = $(document.createElement('div'))
									.attr('Id', tableName + '_head_wrap')
									.prependTo(tableWrap)
									.css({
										width: options.width,
										overflow: 'hidden'
									});

			var headTable = table.clone(true)
									.attr('Id', tableName + '_head')
									.appendTo(headWrap)
									.css({
										width: options.width
									});
			// remove the extra html
			headTable.find('tbody').remove();
			table.find('thead').remove();
			table.find('caption').remove();
			table.find("tr:odd").css({background: "#e0e0e0"});

			
			if( !window.getComputedStyle) {
			    window.getComputedStyle = function(e) {return e.currentStyle};
			}
						
			var div = document.getElementById(tableName + '_body_wrap');
			var scrollbarWidth = div.offsetWidth - div.clientWidth 
					- parseFloat(getComputedStyle(div).borderLeftWidth) 
					- parseFloat(getComputedStyle(div).borderRightWidth);

			// size the header columns to match the body
			var headAll = headTable.find('thead tr td');
			var allBodyFirstCols = table.find('tbody tr:first td');
			
			var allBodyCols = table.find('tbody tr td');
			allBodyCols.each(function(index, element) {$(element).css({border:'none'})});

			var colLenArry = new Array(allBodyFirstCols.length);
			for(var i = 0; i<allBodyFirstCols.length;i++) {
				colLenArry[i] = $(allBodyFirstCols[i]).width();
			}
			colLenArry[allBodyFirstCols.length-1] += (scrollbarWidth);
			for(var i=0; i<headAll.length; i++) {
				$(headAll[i]).width(Math.ceil(colLenArry[i]));
			}
		}
	};
})(jQuery);
