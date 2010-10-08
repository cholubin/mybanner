;window.jQuery && (function($, window, undefined) {
	var oRootElement = $.browser.msie ? document.body : window
	,sCursorNameX = $.browser.msie ? 'e-resize' : 'ew-resize'
	,sCursorNameY = $.browser.msie ? 'n-resize' : 'ns-resize'
	,sCursorNameXY = $.browser.msie ? 'se-resize' : 'nwse-resize'
	,delayInit = function() {
		var $this = this
		,loadSkin = this.loadSkin;
		this.loadSkin = function() {
			loadSkin.call($this);
			$this.initResize();
		};
	};

	$.extend(WYMeditor.editor.prototype, {
		 initResize: function() {
			if(this._box === undefined) {
				delayInit.call(this);
				return;
			}
			var $this = this
			,minWidth, maxWidth, dragMode, bDragging = false
			,dragElement = $(this._box).find('.wym_iframe > iframe')
			,onIframeLoad = $(dragElement).get(0).onload
			,iDragDeltaX,iDragDeltaY, fDragRatioX = -1, fDragRatioY = -1

			,catchEvents = function(e) {
				if($(e.target).is('.wym_resize_Y, .wym_resize_X, .wym_resize_XY')) {
					initDrag(e);
					return false;
				}
			}

			,initDrag = function(e) {
				if(bDragging) {
					stopDrag();
					return false;
				}
				bDragging = true;
				dragMode = $(e.target).is('.wym_resize_Y') ? 'Y' : $(e.target).is('.wym_resize_X') ? 'X' : 'XY';

				var cursorName = dragMode === 'Y' ? sCursorNameY : dragMode === 'X' ? sCursorNameX : sCursorNameXY;
				$('head')
					.append('<style class="cursorImportant" type="text/css">body * {cursor: '+cursorName+' !important;}</style>');
				$(dragElement)
					.parent()
						.css('position', 'relative')
					.end()
					.css('visibility', 'hidden')
					.after(
						$('<div class="wym_iframe_masque" />')
							.css({
								 position: 'absolute'
								,top: '1px'
								,left: '0'
								,width: '100%'
								,height: '100%'
								,background: '#e8f0fa'
								,border: '1px dashed gray'
							})
					);
				if(dragMode !== 'Y') {
					iDragDeltaX = $(dragElement).width() + ((e.clientX + $(document).scrollLeft()) * fDragRatioX);
					$(oRootElement).bind('mousemove.wym_resize', dragX);
				}
				if(dragMode !== 'X') {
					iDragDeltaY = $(dragElement).height() + ((e.clientY + $(document).scrollTop()) * fDragRatioY);
					$(oRootElement).bind('mousemove.wym_resize', dragY);
				}
				$(oRootElement)
					.bind('mouseup.wym_resize', stopDrag);
				return false;
			}

			,dragX = function(e) {
				$(dragElement)
					.width(iDragDeltaX - ((e.clientX + $(document).scrollLeft()) * fDragRatioX));
				return false;
			}

			,dragY = function(e) {
				$(dragElement)
					.height(iDragDeltaY - ((e.clientY + $(document).scrollTop()) * fDragRatioY));
				return false;
			}

			,stopDrag = function() {
				$('head')
					.children('.cursorImportant')
						.remove();
				$(oRootElement)
					.unbind('mousemove.wym_resize')
					.unbind('mouseup.wym_resize');
				$(dragElement)
					.parent()
						.css('position', '')
					.end()
					.css({
						 visibility		: 'visible'
					})
					.next('.wym_iframe_masque')
						.remove();
				bDragging = false;
				return false;
			}

			,prepare = function() {
				maxWidth = dragElement.width();
				$($this._box)
					.css({
						 'float'		: 'left'
						,position		: 'relative'
						,'margin-top'	: '0'
					})
					.append(
						$('<div class="wym_resize_Y" />')
							.css({
								 position		: 'absolute'
								,bottom			: '0'
								,left			: '-5px'
								,height			: '3px'
								,width			: '100%'
								,margin			: '0 0 -3px auto'
								,border			: '1px solid silver'
								,'border-width'	: '1px 0 1px'
								,cursor			: sCursorNameY
							})
					)
					.append(
						$('<div class="wym_resize_X" />')
							.css({
								 position		: 'absolute'
								,right			: '0'
								,top			: '-5px'
								,width			: '3px'
								,height			: '100%'
								,margin			: '0 -3px 0 0'
								,border			: '1px solid silver'
								,'border-width'	: '0 1px 0 1px'
								,cursor			: sCursorNameX
							})
					)
					.append(
						$('<div class="wym_resize_XY" />')
							.css({
								 position		: 'absolute'
								,right			: '0'
								,bottom			: '0'
								,width			: '5px'
								,height			: '5px'
								,margin			: '0 -3px -3px 0'
								,border			: '1px solid silver'
								,cursor			: sCursorNameXY
							})
					);


				dragElement
					.css('width', $.browser.safari ? 'auto' : '100%')
					.parent()
						.css({
							 width			: 'auto'
							,'margin-right'	: '5px'
						})
						.parent()
							.css('overflow', 'hidden')
						.end()
						.siblings()
							.css('clear', 'both');
			}

			,finish = function() {
				minWidth = dragElement.width();
				dragElement
					.css({
						 width			: maxWidth
						,'max-width'	: maxWidth
						,'min-width'	: minWidth
						,'min-height'	: '100px'
					})
					.parent()
						.css('float', 'left');
			};

			dragElement.get(0).onload = function() {};

			$($this._box)
				.wrap('<div />')
					.parent()
						.css({
							 overflow		: 'hidden'
							,'padding'		: '0 5px 5px 0'
							,'margin-top'	: $($this._box).css('margin-top')
						})
						.mousedown(catchEvents);

			dragElement
				.after('<div>')
				.next()
					.each(function() {
						dragElement
							.remove()
							.one('load', function(e) {
								prepare();
								if(typeof onIframeLoad === 'function')
									onIframeLoad.call(dragElement.get(0), e);
								finish();
							})
							.insertBefore(this);
					})
					.remove();
		}
	});
})(window.jQuery, this);