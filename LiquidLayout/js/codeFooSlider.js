$.fn.codeFooSlider = function(settings){
	settings = $.extend({
		slideTime:500,
		slideEasing:"easeInOutQuad",
		maxHeight:400,
		slideMargins:160
	}, settings);
	
	return this.each(function(){
		var slider = $(this);
		var currentSlide = 0;
		$(this).css('overflow','hidden');
		
		
		
		// Fix first slide size on load	
		 $('.slide:eq('+currentSlide+') img', slider).load(function(){
			fixSize();				
		});
		 
		//Add a margin to the bottom of all the slides for spice
		$('.slide').css('margin', '0 0 '+settings.slideMargins+ 'px 0');
			
		// setup thumbnails and mini buttons
		$('.slide', slider).each(function(index){
			var thumbName = $(this).find('img').attr('src').replace(/.jpg$/i, "_thumb.jpg");
			$('#largeControls').append('<li class="thumbBtn" slide="'+index+'"><img src="'+thumbName+'"></li>');
			$('#smallControls').append('<li class="dotBtn" slide="'+index+'"><img src="img/clear.png" ></li>');
			$('#smallControls').width($('.dotBtn').length*40);
			
		});
		
		
		$('.thumbBtn:first-child, .dotBtn:first-child').addClass('selected');
		//Click events for thumbnail and mini buttons
		$('.thumbBtn, .dotBtn').click(function(){
			$('.thumbBtn, .dotBtn').removeClass('selected');
			$('.dotBtn[slide="'+$(this).attr('slide')+'"], .thumbBtn[slide="'+$(this).attr('slide')+'"]').addClass('selected');
			changeSlide($(this).attr('slide'),800);
		});
			
		// change the slide to Target, if Target > total slides or < 0, loop around 
		function changeSlide(Target, AnimSpeed){
			// get the 
			var allBefore = 0;
			$('.slideImg', slider).slice(0, Target).each(function(){
				allBefore += $(this).height() + settings.slideMargins;
			})
			//Do the animation
			slider.animate({scrollTop:allBefore, maxHeight:$('.slide:eq('+Target+')', slider).height()},{duration:AnimSpeed,queue:false});
			currentSlide=Target;
		};
		
		//fixes the current image size and adjusts the frame to fit
		function fixSize(){
			slider.css('maxHeight',$('.slide:eq('+currentSlide+')', slider).height());
			if($('.slide:eq('+currentSlide+') img', slider).height()>=settings.maxHeight){
				$('.slide:eq('+currentSlide+') img', slider).css('max-width','none');
				$('.slide:eq('+currentSlide+') img', slider).css('height','400');
			}	
		}
		
		//resize the gallery window on browser size change.
		$(window).resize(function(){
				
				if($('.slide:eq('+currentSlide+') img', slider).height()>=settings.maxHeight){
					$('.slide img', slider).css('max-width','none');
					$('.slide img', slider).css('height',settings.maxHeight);
					
				}
				if($('.slide:eq('+currentSlide+')', slider).width()<=$('.slide:eq('+currentSlide+') img', slider).width()){
					$('.slide img', slider).css('max-width','100%');
					$('.slide img', slider).css('height','auto');
				}
				//Feels smoother on resize if we animate this
				changeSlide(currentSlide,100);
				slider.css('maxHeight',$('.slide:eq('+currentSlide+')', slider).height());
				
		});
		
		
		fixSize();
		
	});
};