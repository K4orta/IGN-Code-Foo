/* Author:
	Erik Sy Wong
*/

// License plate pattern class and methods
function LicensePattern(){
	//Initalize member variables
	this.DIGITS 			= "0123456789";
	this.LETTERS 			= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	this.popSize 			= 0;
	this.totalPlates 		= 0;
	this.base 				= 0;
	this.numSecondBaseChars = 0;
	this.excess 			= 0;
	this.patternLength	 	= 0;
	this.pattern 			= "";
}

LicensePattern.prototype.figurePattern = function(PopulationSize){
	//Reset member variables 
	this.popSize 			= PopulationSize;
	this.totalPlates 		= 0;
	this.base 				= 0;
	this.numSecondBaseChars = 0;
	this.patternLength 		= 0;
	this.excess 			= Infinity;
	
	//The "All/Mostly Letters" and "All/Mostly Numbers" patterns are the two types that I want to check for the lowest number of excess plates.
	this.solve(this.LETTERS.length, this.DIGITS.length);
	this.solve(this.DIGITS.length, this.LETTERS.length);
	
	//Format the solved pattern into a string
	var digits = "";
	var letters = "";
	var cb = this.base;
	for(var i=0;i<this.patternLength;++i){
		if(i>=this.patternLength-this.numSecondBaseChars)
			cb=cb==this.LETTERS.length?this.DIGITS.length:this.LETTERS.length;
		
		if(cb==this.LETTERS.length){
			letters += "X";
		}else{
			digits += "0";
		}
	}
	this.pattern = letters+digits;
}

// Tests a letter/number dominate pattern to find the permutation that provides the lowest number of excess plates
LicensePattern.prototype.solve = function(FirstBase, SecondBase){
	// Figure out how many characters this type of pattern will need to have
	var pLength = Math.ceil(Math.log(this.popSize) / Math.log(FirstBase));
	// log(1) == 0 so check to make sure if population == 1 that pLength isn't set to 0;
	if(this.popSize==1) pLength = 1;
	var tPlates=0;
	var curExcess=0;
	//Iterate through the number of character to find the best combination of letters and numbers 
	for(var i=0;i<pLength;++i){
		// Total number of plates is caluated based on current number to letter iteration 
		tPlates = Math.pow(FirstBase,pLength-i)*Math.pow(SecondBase,i);
		curExcess = tPlates - this.popSize;
		 //Check to see if this result is better than what we currently have
		if(tPlates>=this.popSize && curExcess<this.excess){
			this.numSecondBaseChars = i;
			this.base = FirstBase;
			this.excess = curExcess;
			this.totalPlates = tPlates;
			this.patternLength = pLength;
		}
	}

}

// Generates a sample plate based on Pattern argument 
LicensePattern.prototype.generateSample = function(Pattern){
	Pattern = (typeof Pattern == 'undefined'?this.pattern:Pattern);
	var samplePat = "";
	for(var i=0;i<Pattern.length;++i){
		if(Pattern.charAt(i)=="X"){
			samplePat+=this.getRandomChar(this.LETTERS);
		}else{
			samplePat+=this.getRandomChar(this.DIGITS);
		}	
	}
	return samplePat;
}

//Returns a random character from a passed String
LicensePattern.prototype.getRandomChar = function(Source){
	return Source.substr(parseInt(Math.random()*Source.length),1);
}

// Web site functionality

$(document).ready(function(){
	var curPlate= new LicensePattern();
	// Set up inital text for population textfield
	$('#popForm input[type="text"]').val("Enter a population").css('color','#AAA').focus(function(){
		if($(this).val() == "Enter a population"){
			$(this).val('').css('color','#000');
		}
	}).blur(function(){
		if($(this).val() == ""){
			$(this).val('Enter a population').css('color','#AAA');
		}
	});
	
	$('#popForm').submit(function(){
		// Grab user input and begin solve
		curPlate.figurePattern(parseInt($('#popInput').val().replace(/[,a-zA-Z]/g,'')));
		
		//Display result 
		formatResult(curPlate);

		//Makes the sample license plate visible if it is hidden 
		if($('#resultContain').is(':hidden'))
			$('#solveResult').animate({'height':$('#resultContain').outerHeight()},{duration:600, complete:function(){
				$('#resultContain').fadeIn(200);
				$(this).css('height','auto');
			}
			});
		return false;
	});
	
	// Setup example population buttons
	$('#populationPicker li').click(function(){
		if($('#popInput').val() == "Enter a population"){
			$('#popInput').val('').css('color','#000');
		}
		$('#popInput').val($(this).attr('pop'));
		$('#popForm').submit();
	});
	
	$('#altPlateSelector li a').click(function(){
		$('#samplePlate').css('background-image', 'url('+$(this).attr('href')+')')
		.removeClass().addClass($(this).attr('pc'));
		return false;
	});

});

// Takes a LicensePattern Object and displays select member variables
function formatResult(Plate){
	$('#platePattern').text(Plate.pattern);
	$('#plateTotal').text(Plate.totalPlates);
	$('#plateExcess').text(Plate.excess==Infinity?0:Plate.excess);
	$('#samplePlate').text(Plate.generateSample(Plate.pattern));
}