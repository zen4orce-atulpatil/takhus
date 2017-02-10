/*Description : This class is used as a Domain class for Warehouse component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/

public class WarehouseDomain {
	 //Description:- Purpose of this method is to update product record
	public static boolean saveWHProduct(Product__c productRecord,boolean allWhFunctions,boolean whERP){
		boolean isSuccess = true;
        List<Product__c> productLst = new List<Product__c>();
        productRecord.All_WH_Function__c = allWhFunctions;
        productRecord.WH_ERP__c = whERP;
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
    public static void  submitProjectToCosting(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'Costing';
		upsert prjToUpsert;         
    }
}