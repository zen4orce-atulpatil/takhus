/*Description : This class is used as a Domain class for Projects VF page, SHE VF component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class SHEDomain {
	 /*Description : Purpose of this method is to save the project */
     public static boolean saveSHEProduct(Product__c productRecord,boolean allSHEFunctions,boolean erpData){
		boolean isSuccess = true;
        List<Product__c> productLst = new List<Product__c>();
        productRecord.All_SHE_Function__c = allSHEFunctions;
        productRecord.SHE_ERP__c = erpData;
        productLst.add(productRecord);
        Database.UpsertResult[] results = Database.upsert(productLst,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    /*Description : Purpose of this method is to save/submit the project to MFG department.*/
    public static void  submitProjectToMFG(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'MFG';
		upsert prjToUpsert;         
    }
}