(function($) {

	$.fn.bp_task = function(task,settings) {
		var config = {
			id: 0,
			template: $("<div>"),
			onMouseOver: "",
			onMouseOut: ""
		};
		
		if (settings) $.extend(config, settings);
		
		var container = this;
		
		render(this);
		
		container.mouseover(function(){
			// console.log("mouseout");
		});
		
		container.mouseout(function(){
			// console.log("mouseout");
		});
		
		function update(){
			console.log("update");
		}
		
		function destroy(){
			console.log("destroy");
		}
		
    	function render(self){
			console.log("render",config.template);
			container.append(config.template.clone());
			container.data("task",task);
			// container.data("type","task");
			container.find(".subject").html(task.description);
			// container.draggable();
		}
	
		function initComment(){
			if (comment.length > 0){
				container.find("div.comment textarea").val(comment);
				container.find("span.comment").attr("title",comment + " (Click to Edit)");
			} else {
				container.find("span.comment").addClass("add");
			}
		}
	
		function initInsights(){
			container.find(".insight_field").autocomplete(available_insights);
			if (insights.length > 0){
				container.find("div.insights").show();
				container.find(".empty_message").hide();
				jQuery.each(insights, function() {if (this != ""){renderTag(this.toString())}});
			} else {
				container.find("span.insights").addClass("add");
			}
		}

		function initToolBox(){
			container.find("span.trash").click(function(){destroy()});
			container.find("span.comment").click(function(){attachComment()});
			container.find("span.insights").click(function(){attachInsights()});
			container.find(".insight_button").click(function(){addTags();})
			container.find("div.comment input.comment_button").click(function(){submitComment();})
		}
	
		function attachInsights(){
			container.find(".insight_form").slideToggle();
			
			if (container.find(".insight_form:visible")){
				container.find("div.insights").show();
			}else{
				// When closing the insight form, leave insights list open if populated
				(insights && insights.length > 0) ? container.find("div.insights").show() : container.find("div.insights").slideToggle();
			}
		}
	
		function attachComment(){
			container.find("div.comment").slideToggle();
		}
		
		function submitComment(){
			comment = container.find("div.comment textarea").val();
			container.find("span.comment").removeClass("add");
			update();
		}
	
		function addTags(){
			arrNewInsights = container.find(".insight_field").val().split(",");
			if (arrNewInsights.length > 0){
				container.find("span.insights").removeClass("add");
				container.find(".empty_message").hide();
				jQuery.each(arrNewInsights, function() {
					if (this != ""){addTag(this)}
				});
			}
			container.find(".insight_field").val("");
		}
	
		function addTag(strTag){
			// strTag = strTag.toLowerCase();
			strTag = strTag.toString();
			if (insights.indexOf(strTag) < 0){
				insights.push(strTag);
				renderTag(strTag);
				update();
			}
		}
	
		function renderTag(strTag){
			tag = $('<div>').addClass("insight")
			tag.click(function(){removeTag(this,strTag)});
			tag.append($('<a>').html("*"));
			tag.append($('<span>').html(strTag));
			container.find("div.insights").prepend(tag)
		}
	
		function removeTag(elTag,strTag){
			arr_updated = new Array();
			jQuery.each(insights, function() {
				if (this != strTag){
					arr_updated.push(this);
				}
			});
			insights = arr_updated;
			if (insights.length < 1){
				container.find("span.insights").addClass("add");
				container.find(".empty_message").show();
			}
			$(elTag).hide();
			update();
		}
		
		return this; 
		
	}
 
 })(jQuery);

