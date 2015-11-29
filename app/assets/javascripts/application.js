// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require best_in_place
//= require turbolinks
//= require_tree .


/* --------------------------------------------------
   User Profile Popup
-------------------------------------------------- */

$(document).on('ready page:load', function () {
    $(".login-section").click(function(e) {
        $(".user-popup").toggle();
        e.stopPropagation();
    });

    $(document).click(function(e) {
        if (!$(e.target).is('.user-popup, .user-popup*')) {
            $(".user-popup").hide();
        }
    });
});

/* --------------------------------------------------
   Best In Place
-------------------------------------------------- */

$(document).on('ready page:load', function () {
  $(".best_in_place").best_in_place();
});

/* --------------------------------------------------
   Edit Link sections
-------------------------------------------------- */

$(document).on('ready page:load', function () {
    $('body').on('click','.edit-link-button',function(e){
     $(this).siblings(".editable").toggle();
     $(this).siblings(".editable").children(".link-info").css({"background-color":"rgba(255,0,0,0.05)", "border-left":"1px dotted #CCC", "border-right":"1px dotted #CCC", "color":"#555"});
     $(this).find(".edit-icons").toggle();
     e.stopPropagation();
    });
});

$(document).on('ready page:load', function () {
    $('body').on('click','.show-url-button',function(e){
     $(this).siblings(".link-url").toggle();
     $(this).siblings(".link-url").css({"border-top":"1px solid #E1E1E1"});
       e.stopPropagation();
    });
});

/* --------------------------------------------------
   Updating the best_in_place fields
-------------------------------------------------- */

// Sidebar Collections
$(document).on('ready page:load', function () {
  $('.best_in_place_title').bind("ajax:success", function () {
      $(".sidebar-collection-links-wrapper").load(" .sidebar-collection-links-wrapper");
    });
});

// $(document).on('ready page:load', function () {
//     $('body').on('click', '.check-button', function(){
//       var container  =  $(this).parents(".edit-link-button").siblings(".link-show-info").children(".onion");
//      container.load( container);
//     });
// });

/* --------------------------------------------------
   Share collection popup
-------------------------------------------------- */
$(document).on('ready page:load', function () {
    //open the invitation form when a share button is clicked 
    $( ".share-collection" ) 
            .button() 
            .click(function() { 
                //assign this specific Share link element into a variable called "a" 
                var a = this; 
                  
                //First, set the title of the Dialog box to display the collection name 
                $("#invitation_form").attr("title", "Share '" + $(a).attr("collection_title") + "' with others" ); 
                  
                //a hack to display the different collection names correctly 
                $("#ui-dialog-title-invitation_form").text("Share '" + $(a).attr("collection_title") + "' with others");  
                  
                //then put the collection_id of the Share link into the hidden field "collection_id" of the invite form 
                $("#collection_id").val($(a).attr("collection_id")); 
                  
                $( "#invitation_form" ).dialog({ 
                    height: 300, 
                    width: 600, 
                    modal: true, 
                    buttons: { 
                        //First button 
                        "Share": function() { 
                            //get the url to post the form data to 
                            var post_url = $("#invitation_form form").attr("action"); 
                              
                            //serialize the form data and post it the url with ajax 
                            $.post(post_url,$("#invitation_form form").serialize(), null, "script"); 
                              
                            return false; 
                        }, 
                        //Second button 
                        Cancel: function() { 
                            $( this ).dialog( "close" ); 
                        } 
                    }, 
                    close: function() { 
                  
                    } 
                });
                  
                return false; 
            }); 
});