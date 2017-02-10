/*Description : This class is used as a Domain class for Mfg Component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class MFGDomain {

    //Description:- Purpose of this method is to update product record
	public static boolean saveMFGProduct(Product__c productRecord,boolean allFunctions,boolean mfgERP){
		boolean isSuccess = true;
        List<Product__c> productLst = new List<Product__c>();
        productRecord.All_MFG_Function__c = allFunctions;
        productRecord.MFG_ERP__c = mfgERP;
        productLst.add(productRecord);
        Database.UpsertResult[] results = Database.upsert(productLst,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    
    //Description:- Purpose of this method is to submit project to waehouse department
    public static void  submitProjectToWH(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'Warehouse';
		upsert prjToUpsert;         
    }
}