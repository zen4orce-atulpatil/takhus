/*Description : This class is used as a Domain class QA_QC_Specification component.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class QA_QC_SpecificationDomain {
    
    //Description:- Purpose of this method is to Insert/Update PM_QA_Spec__c records.
    public static boolean upsertQaQcSpecification(List<PM_QA_Spec__c> lstQaQcSpecfication){
    	boolean isSuccess = true;
        if(lstQaQcSpecfication.size()>0){
            List<Database.UpsertResult> results = Database.upsert(lstQaQcSpecfication, true);
            for(Database.UpsertResult varResult : results){
                if(!varResult.isSuccess()){
                    isSuccess = false;
                }
            }
        }    
        return isSuccess;
    }
    
    //Description:- Purpose of this method is to delete PM_QA_Spec__c records.
    public static boolean deleteQaQcSpecification(List<PM_QA_Spec__c> lstQaQcSpecficationToDelete){
    	boolean isSuccess = true;
        if(lstQaQcSpecficationToDelete.size()>0){
            List<Database.DeleteResult> results = Database.delete(lstQaQcSpecficationToDelete,true);
            for(Database.DeleteResult varResult : results){
                if(!varResult.isSuccess()){
                    isSuccess = false;
                }
            }
        }
        return isSuccess;
    }
    
    /*Description : Purpose of this method is to save/submit the project to supply chain department.*/
    public static void  submitProjectToSHE(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'SHE';
		upsert prjToUpsert;         
     }
    
    //Description:- Purpose of this method is to insert sharing record. 
    public static void insertSharedRecord(Product__share shareProduct){
         Database.SaveResult sr = Database.insert(shareProduct,false);
    }
}