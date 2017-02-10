/** modal open for delete**/
    function showModal() {
        
      $('#myModal').modal('show');
      return false;
        
    }
      /* Function for Modal for marketing */
            function captureModalInput(sumbitButton){
                var oppComment = document.getElementById('comment').value;
                debugger;
               
                modalSumbitBtn(sumbitButton,oppComment)
                
                

            }
            function setBtnClicked(buttonClicked){
                if(buttonClicked=='reject'){
                    $(".saveCreateBtn").hide();
                    $("#approvelabel").hide();
                    $("#rejectlabel").show();
                    $("#comment").attr("placeholder", "Rejection Comments");
                }
                else{
                    $(".saveCreateBtn").show();
                    $("#approvelabel").show();
                    $("#rejectlabel").hide();
                    $("#comment").attr("placeholder", "Approval Comments");
                }
            }
    /** **/  
      /** data table**/
      $(document).ready(function() {
          
          /** hide and show opportunity create opp wizard**/
           $("#CreateNewOpp").hide();
          $("#newOppB").click(function(){
            $("#CreateNewOpp").show();
              
		});
          
          var handleDataTableButtons = function() {
          if ($("#datatable-buttons").length) {
            $("#datatable-buttons").DataTable({
              dom: "Bfrtip",
              buttons: [
                {
                  extend: "copy",
                  className: "btn-sm"
                },
                {
                  extend: "csv",
                  className: "btn-sm"
                },
                {
                  extend: "excel",
                  className: "btn-sm"
                },
                {
                  extend: "pdfHtml5",
                  className: "btn-sm"
                },
                {
                  extend: "print",
                  className: "btn-sm"
                },
              ],
              responsive: true
            });
          }
        };

        TableManageButtons = function() {
          "use strict";
          return {
            init: function() {
              handleDataTableButtons();
            }
          };
        }();

        $('#datatable').dataTable();

        $('#datatable-keytable').DataTable({
          keys: true
        });

        $('#datatable-responsive').DataTable();

        $('#datatable-scroller').DataTable({
          ajax: "js/datatables/json/scroller-demo.json",
          deferRender: true,
          scrollY: 380,
          scrollCollapse: true,
          scroller: true
        });

        $('#datatable-fixed-header').DataTable({
          fixedHeader: true
        });

        var $datatable = $('#datatable-checkbox');

        $datatable.dataTable({
          'order': [[ 1, 'asc' ]],
          'columnDefs': [
            { orderable: false, targets: [0] }
          ]
        });
        $datatable.on('draw.dt', function() {
          $('input').iCheck({
            checkboxClass: 'icheckbox_flat-green'
          });
        });

        TableManageButtons.init();
      });
  
              /** wizard**/  
     $(document).ready(function() {
          
        $('#wizard').smartWizard({
            transitionEffect: 'slide',
            onLeaveStep: leaveAStepCallback,
            onFinish: onFinishCallback,
            onShowStep: onShowStep
        });
          
		function onShowStep(obj, context) {
            debugger;
            $(".buttonPrevious").unbind("click").click(function (e) {
                e.preventDefault();
                $("#wizard").smartWizard("goBackward");
               
            });

            $(".buttonNext").unbind("click").click(function (e) {
                e.preventDefault();
                $("#wizard").smartWizard("goForward");
                
            });
        }

        function leaveAStepCallback(obj, context) {

            $(".buttonPrevious").unbind("click");
            $(".buttonNext").unbind("click");

            return true;
        }

          function onFinishCallback(objs, context) {
			
            
        }
          

        $('.buttonNext').addClass('btn btn-success');
        $('.buttonPrevious').addClass('btn btn-primary');
          $('.buttonFinish').addClass('btn btn-danger');/**finish rename as submit **/
          $('.buttonSave').addClass('btn btn-info');
          /** save opp**/
          $('.buttonSave').click(function(){
              MyFuncUpdateOpp();
    			
			});
         $('.buttonFinish').click(function(){
              MyFuncUpdateOpp();
    			
			});
      });
     /** wizard**/ 
             
        /** tooltip on button**/ 
        $(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
            
}); 