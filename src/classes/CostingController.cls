/*
Description : Purpose of this Class id to Handle Save and Edit Operation of Costing question component.
Created By : Mustafa
Created Date : November 2016
*/
public class CostingController {

    public Product__c productRecord{get;set;}
    public Project__c projectRecord{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public String selectedUser{get;set;}
    public boolean erpData{get;set;}
    
    /*Description : purpose of this method is save the Costing product.*/
    public void saveProduct(){
        boolean isSuccessProject = false;
        boolean isSuccessProduct = false;
        if(CostingDomain.saveCostingProduct(productRecord,erpData)){
           isSuccessProduct = true;
           
        }
        if(CostingDomain.saveCostingProject(projectRecord)){
           isSuccessProject = true;
        }
        if(isSuccessProject == true && isSuccessProduct ==true){
           notificationType = 'success';
           notificationMessage = Label.ProjectCompleteMessage; 
        }
        //
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approving request');
                req.setAction('Approve');
                req.setNextApproverIds(new Id[] {null});//  Selection of next Approver, 
                Id workItemId = getWorkItemId(projectRecord.id); 
                if(workItemId == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Approval_Process_Initiated_Error));
                }
                else{
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                }
      //  
    }
     //Purpose of this method is to get ProcessInstanceWorkitem record for given object.
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        try{
            for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                where p.ProcessInstance.TargetObjectId =: targetObjectId])
            {
                retVal  =  workItem.Id;
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return retVal;
    }
}