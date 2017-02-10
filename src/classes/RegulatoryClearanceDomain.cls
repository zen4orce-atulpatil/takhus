/*Description : This class is used as a domain class for Regulatory clearance controller. Purpose of this class is to  manipulate
Regulatory clearance  data
Created By : Mustafa 
Created Date : November 2016 */
public class RegulatoryClearanceDomain {

    /*Description : Purpose of this method is to upsert RegulatoryClearance record*/
    public static boolean upsertRegulatoryClearance(List<PM_Regulatory_Clearance__c> regClearanceList){
		boolean isSuccess = true;
    	Database.UpsertResult[] results = Database.upsert(regClearanceList,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }

    /*Description : Purpose of this method is to update RegulatoryClearance record*/
    public static boolean updateRegulatoryClearanceProduct(Product__c productRec){
       Database.SaveResult results = Database.Update(productRec);
       return results.isSuccess();
    }
    
    /*Description : Purpose of this method is to save/submit the project to SHE department.*/
    public static boolean  submitProjectToQAQC(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'QA/QC';
		Database.SaveResult results = Database.Update(prjToUpsert);
        return results.isSuccess();
    }
}