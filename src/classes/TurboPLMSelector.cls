/*Description : This class is selector class  Purpose of this class is to perform DML operations
Created By : Mustafa
Created Date : November 2016*/
public with sharing class TurboPLMSelector {
	
	/*Description : Purpose of this method to get all open task*/
    public static List<Task> getOpenTask(String uid){
        List<Task> lstOpenTask = new List<Task>([select Subject,WhatId,Status,ActivityDate from task where OwnerId=:uid]);
        return lstOpenTask;
    }
    
    // important - change lstDueTask query where condition "ActivityDate<today"
    /*Description : Purpose of this method is get all Over Due Task*/ 
    public static List<Task> getOverDueTask(String uid){
        List<Task> lstDueTask = new List<Task>([select Subject,WhatId,Status,ActivityDate from task where OwnerId=:uid]);
        return lstDueTask;
    }
    
    /*Description : Purpose of this method is to get all Opportunities of sales department.*/ 
    public static List<Opportunity> getAllOpportunitiesForSales(){  
        List<Opportunity> oppList =   [SELECT ID,
                                        Name, 
                                        StageName,
                                        CloseDate,
                                        Amount,
                                        Approval_Status__c ,
                                        AccountId,
                                        Customer_Name__c,
                                        Description,
                                        Approver__c,
                                        Approve_Reject_Comment__c
                                        FROM Opportunity WHERE 
                                        OwnerID =: UserInfo.getUserId() ORDER BY LastModifiedDate DESC];
          System.debug('oplist'+oppList);
        return oppList;
    }
    
    /*Description : Purpose of this method is to get all Opportunities of Marketing department.*/ 
    public static List<Opportunity> getAllOpportunitiesForMarketing()
    {
        List<Opportunity> oppList =   [SELECT ID,
                                        Name, 
                                        StageName,
                                        CloseDate,
                                        Amount,
                                        Approval_Status__c,
                                        AccountId,
                                        Customer_Name__c,
                                        Description,
                                       Approver__c
                                       , Approve_Reject_Comment__c
                                        FROM Opportunity WHERE 
                                        Approval_Status__c in ('Submitted','Approved') ORDER BY LastModifiedDate DESC];
        								//Approver__c =: UserInfo.getUserId()
        return oppList;
    }
    
    /*Description : Purpose of this method is to get opportunity details for edit.*/ 
    public static Opportunity getOppDetails(String opId){
         Opportunity opp ; 
         if(opId != 'null'){
             
            opp = [select Name, 
                        StageName,
                   		AccountId,
                   		Amount,
                   		Customer_Name__c,
                   		CloseDate,
                   		Description,
                   		Approver__c,
                   		Approval_Status__c  from opportunity where ID =: opId];
         }
         if(opp != null)
         {
            return opp;
         }
         else
         {
            return new Opportunity();
         }
    }
    
    /*Description : Purpose of this method is to get the Applications list*/
    public static List<Applications__c> getApplication(){
        List<Applications__c> lstPMApplication = [select Id,Name from Applications__c];
        return lstPMApplication;
    }
    
    /*Description : Purpose of this method is to get the Products list*/
    Public static List<Product__c> getProducts(){
        List<Product__c> lstProduct = [select Name,Tradename__c from Product__c];
        return lstProduct;
    } 
    
    /*Description : Purpose of this method is to get the package size list*/
    public static List<Pkg_Size__c> getPkgSize(){
        List<Pkg_Size__c> lstpkgSize = [select Id, Name from Pkg_Size__c];
        return lstpkgSize;
    }
    
    /*Description : Purpose of this method is to get the chem regulations list*/
    public static List<Chem_Regulation__c> getChemRegulation(){
        List<Chem_Regulation__c> lstChemRegulation = [select id,Name from Chem_Regulation__c];   
        return lstChemRegulation;
    }
    
    /*Description : Purpose of this method is to get all the project details to display in data table*/
   public static List<Project__c> getAllProjects()
   {
       List<Project__c> ProjectList = [SELECT Project__c.Product__r.id,Project__c.Product__r.Tradename__c,Project__c.Product__r.Name,Approval_Status__c,CreatedById,CreatedDate,Department__c,Id,LastModifiedDate,Name,Product__c,Project_Description__c,Project_Type__c,Status__c FROM Project__c ORDER BY LastModifiedDate DESC];
       		
       return ProjectList;
   }
    
    /*Description : Purpose of this method is to return map of all project records.*/
   public static map<Id,Project__c> mapAllProjects(){
    	List<Project__c> ProjectList = [SELECT Id,Name FROM Project__c];
        map<Id,Project__c> mapAllProjects = new map<Id,Project__c>(ProjectList);
        return mapAllProjects;
    }
    
    /*Description : Purpose of this method is to return Project__c record for given projectId.*/
    public static Project__c getProjectById(String projid){
        Project__c pro = [SELECT Id,Product__r.Name, Product__r.Tradename__c,Name,Project_Type__c,Approval_Status__c,Department__c FROM Project__c where id=:projid];
        return pro;
    }
     
    /*Description : Purpose of this method is to get  product details*/
    public static Product__c getProductDetails(String productId){
        Product__c Product = [select Id, Name, Tradename__c, Product_Description__c from Product__c where Id=:productId];
        return Product;
    }
    
    /*Description : Purpose of this method is to get all Applications list*/
     public static List<PM_Application__c> getPMApplication(String productId){
        list<PM_Application__c> listOfPmApp = new list<PM_Application__c>();
        listOfPmApp = [SELECT Applications__r.name,Application__c,Comments__c,Id,LastModifiedDate,Name,Project__r.name 
        								     FROM PM_Application__c 
        								     where Project__c=:productId ORDER BY LastModifiedDate DESC];
        return listOfPmApp;
     }
     /*Description : Purpose of this method is to get all chemRegulation */
    public static List<PM_Regulatory_Clearance__c> getPMPMRegulatoryClearance(String productId){
         List<PM_Regulatory_Clearance__c> lstPMRegulatoryClearance = [SELECT CreatedById,CreatedDate,Id,LastModifiedDate,Name,Notes__c,
        															 Project__r.name,Regulatory_List__r.name,Reg_Clearance__c 
        															 FROM PM_Regulatory_Clearance__c 
        															 where Project__c=:productId  ORDER BY LastModifiedDate DESC];
        return lstPMRegulatoryClearance;
    }
    
    /*Description : Purpose of this method is to get all product package sizes */
    public static List<Product_Pkg__c> getProductPkg(String productId){
       List<Product_Pkg__c> lstProductPkg = [SELECT Name,Package_Name__c,
                                              Pkg_Size__r.name,Product_Name__c,Product__r.name,Projects_and_Approval__r.name,
                                              Project_Approval_Completion_Flag__c,Region__c,LastModifiedDate,id
                                              FROM Product_Pkg__c
        									  where Product__c=:productId  ORDER BY LastModifiedDate DESC];
        return lstProductPkg;
    }
    
    /*Description : Purpose of this method is to get all users details */
    public static map<String,Id> getUsers(){
        map<String,Id> mapUser = new map<String,Id>();
        List<User> lstUsers = [select id,Name from User];
        for(User usr:lstUsers){
            mapUser.put(usr.Name,usr.Id);
        }
        return mapUser;
    }

    /*Description : Purpose of this method is to get  project details*/
    public static Project__c getProjectDetails(String projectID){
        Project__c project= [select id,Product__c from Project__c where id=:projectID];
        return project;
    }
    
    /*Description : Purpose of this method is to get  product packages list to delete */
    public static List<Product_Pkg__c> getProductPkgLstToDelete(List<Pkg_Size__c> lstPkgSizeIds){
        List<Product_Pkg__c> lstProductPkg = [select Id,Name from Product_Pkg__c where Pkg_Size__c IN:lstPkgSizeIds];
        return lstProductPkg;
    }
    
    /*Description : Purpose of this method is to get  PM Regulatory Clearance List list to delete */
    public static List<PM_Regulatory_Clearance__c> getPMRegulatoryClearanceLstToDelete(List<Chem_Regulation__c> lstChemRegIds){
        List<PM_Regulatory_Clearance__c> lstPMRegulatoryClearance = [select id,Name from PM_Regulatory_Clearance__c where Regulatory_List__c IN:lstChemRegIds];
        return lstPMRegulatoryClearance;
    }
    
    /*Description : Purpose of this method is get the pending approval processes for user.*/
    public static List<ProcessInstanceWorkItem> getProcessInstanceWorkItemRecord(String prjId){
        List<ProcessInstanceWorkItem> workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId
        From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: prjId];
        return workItemList;
    }
    
     /*Description : Purpose of this method is to return all RawMaterial__c recoeds.*/
    public static List<RawMaterial__c> getAllRawMaterial(){
         List<RawMaterial__c> rawMaterialList = new list<RawMaterial__c>();
         rawMaterialList = [select Id, name,R_Description__c  from RawMaterial__c];
         return rawMaterialList;   
    }
    
    /*Description : Purpose of this method is to return all Reg_Inventory__c recoeds.*/
    public static List<Reg_Inventory__c> getAllRegInventory(){
        List<Reg_Inventory__c> regInventoryList =  new  List<Reg_Inventory__c>();
        regInventoryList  = [SELECT CAS__c,EC_Inventory__c,IECSC__c,TSCA__c,CAS_Description__c,(select Name,Regulation__c,Flag__c,Country__c from Reg_Inventory_Detail__r WHERE Flag__c='N') from Reg_Inventory__c];
        return regInventoryList;
         
    }
    
    /*Description : Purpose of this method is to return Product__c object of selected product.*/
    public static Product__c getProductById(String productId){
        Product__c prod= new Product__c();
        prod =[SELECT BOM_Total__c,Id,LastModifiedDate,Name,OwnerId,
               Product_Description__c,Product_Number__c,Project_Type__c,
               Researcher__c,Status__c,Tradename__c 
               FROM Product__c
               WHERE Id=:productId];
        return prod;
    }
    
    /*Description : Purpose of this method is to return Where_Used__c(Bom) list of selected product.*/
    public static list<Where_Used__c> getBomsByProductId(String productId){
       list<Where_Used__c> listOfBoms = new List<Where_Used__c>();
    	
    	listOfBoms = [SELECT Id,LastModifiedDate,Name,Percent__c,
    				  Product__c,RNumber__r.name,RNumber__r.Id,R_Description__c,Status__c 
    				  FROM Where_Used__c
                      WHERE Product__c=:productId  ORDER BY LastModifiedDate DESC];
        
        return listOfBoms;
    }
    
    /*Description : Purpose of this method is to return PM_Approved_WH__c list of selected product.*/
    public static list<PM_Approved_WH__c> getPmApprovedWhByProductId(String productId){
       list<PM_Approved_WH__c> listOfApprWh = new list<PM_Approved_WH__c>();
    	listOfApprWh = [SELECT City__c,Id,LastModifiedDate,Name,Product__r.name,
                        Warehouse_Number__c,Warehouse__r.name 
                        FROM PM_Approved_WH__c
                        WHERE Product__c=:productId  ORDER BY LastModifiedDate DESC];
        return listOfApprWh;
    }
    
    
    /*Description : Purpose of this method is to return PM_Mix_Instruction__c list of selected product.*/
    public static list<PM_Mix_Instruction__c> getPmMixInstructionByProductId(String productId){
         list<PM_Mix_Instruction__c> listOfInst = new list<PM_Mix_Instruction__c>();
    	 
    	 listOfInst = [SELECT Blend_RXN__c,Blend__c,Id,LastModifiedDate,Mixing_Details__c,
    	 			   Name,Order_of_Addition__c,Project__r.name,RXN__c 
    	 			   FROM PM_Mix_Instruction__c
                       WHERE Project__r.id =: productId 
                       ORDER BY LastModifiedDate DESC];
                       
          return listOfInst;   
    }
    
    /*Description : Purpose of this method is to return PM_Approved_Mfg_Plant__c list of selected product.*/
    public static list<PM_Approved_Mfg_Plant__c> getPmApprovedMfgPlantByProductId(String productid){
        
        list<PM_Approved_Mfg_Plant__c> listOfPmApprProd = new list<PM_Approved_Mfg_Plant__c>();
        listOfPmApprProd = [SELECT City__c,Id,LastModifiedDate,Name,Plant_Number__c,
                            Plant__r.name,Product__r.name FROM PM_Approved_Mfg_Plant__c
                            WHERE Product__c=:productId  ORDER BY LastModifiedDate DESC];
        return listOfPmApprProd;
    }
    
    /*Description : Purpose of this method is to return PM_Physical_Properties__c list of selected product.*/
    public static list<PM_Physical_Properties__c> getPhyPropertiesByProductId(String productId){
         list<PM_Physical_Properties__c> listOfPhyProp = new  list<PM_Physical_Properties__c>();
    	 
    	 listOfPhyProp = [ SELECT Id,LastModifiedDate,
                          	Name,Parameter__c,
                          	Physical_Properties__r.Id,
                          	Physical_Properties__r.name,
    	 				   	Project__r.name,UOM__c,Value__c 
    	 				   	FROM PM_Physical_Properties__c
                           	WHERE Project__c=:productId  ORDER BY LastModifiedDate DESC];
                           
        return listOfPhyProp;
        
    }
    
    /*Description : Purpose of this method is to return PM_QA_Spec__c list of selected product.*/
    public static list<PM_QA_Spec__c> getPmQaQcSpecsByProductId(String productId){
       list<PM_QA_Spec__c> listOfPmSpec = new list<PM_QA_Spec__c>();
    	
    	listOfPmSpec = [SELECT Id,
                        		LastModifiedDate,
                        		Name,
                        		Parameter__c,
                        		Product__r.name,
    							QA_Spec__r.name,
                        		QA_Spec__r.Id,
                        		Range__c,
                        		SystemModstamp,Test_Description__c,
    							Test_Method__r.name,
                        		UOM__c 
    							FROM PM_QA_Spec__c
                        		WHERE Product__c=:productId  ORDER BY LastModifiedDate DESC];
                        
         return listOfPmSpec;
    }
    
    /*Description : Purpose of this method is to return PM_Composition__c list of selected product.*/
    public static list<PM_Composition__c> getPmCompositionsByProductId(String productId){
        list<PM_Composition__c> listOfPmComp = new list<PM_Composition__c>();
    	
    	listOfPmComp= [SELECT Id,CAS_Description__c,CAS__c,EC_Inventory__c,Regulatory__r.Id,IECSC__c,
    				   LastModifiedDate,Name,Percent__c,Project__r.name,RegID__c,
    				   TSCA__c 
    				   FROM PM_Composition__c
                       WHERE Project__c=:productId  ORDER BY LastModifiedDate DESC];
                       
        return listOfPmComp;	    
    }
    
    /*Description : Purpose of this method is to return list of all Physical_Properties__c records.*/
    public static list<Physical_Properties__c> getAllPhyicalProperties(){
        list<Physical_Properties__c> listOfPhyProps = new list<Physical_Properties__c> ();
        listOfPhyProps = [SELECT Id,UOM__c,Name FROM Physical_Properties__c];
        return listOfPhyProps;
    }
    
    /*Description : Purpose of this method is to return list of all QA_Spec__c records.*/
    public static list<QA_Spec__c> getAllQaSpecs(){
     list<QA_Spec__c> listOfQaSpecs = new list<QA_Spec__c> ();
        listOfQaSpecs = [SELECT Id,UOM__c,Name FROM QA_Spec__c];
        return listOfQaSpecs;
    }
    
    /*Description : Purpose of this method is to return list of ProcessInstanceWorkitem of current user User.*/
    public static List<ProcessInstanceWorkitem> getProcessInstanceWorkItems(Id userId){
        List<ProcessInstanceWorkitem> lstProcessInstanceWorkItems = [SELECT 
                                                                     ActorId,
                                                                     Id,
                                                                     OriginalActorId,
                                                                     ProcessInstanceId 
                                                                     FROM ProcessInstanceWorkitem 
                                                                     where ActorId =:userId];
        return lstProcessInstanceWorkItems;
    }
    
    
    /*Description : Purpose of this method is to return map of ProcessInstance.*/
    public static map<Id,ProcessInstance> getProcessInstances(){
        List<ProcessInstance> lstProcessInstances = [SELECT Id,
                                                     LastActorId, 
                                                     CreatedDate , 
                                                     LastModifiedById,
                                                     LastModifiedDate,
                                                     ProcessDefinitionId,
                                                     Status,
                                                     SubmittedById,
                                                     TargetObjectId 
                                                     FROM ProcessInstance];
        map<Id,ProcessInstance> mapProcessInstances = new map<Id,ProcessInstance>(lstProcessInstances);
        return mapProcessInstances;
    }
    
    /*Description : Purpose of this method is to return Bom list for the .*/
    public static List<Where_Used__c> getBomList(String productId){
        List<Where_Used__c> lstBom = [SELECT Id,Percent__c,RNumber__r.Name,RNumber__r.Id,Product__c FROM Where_Used__c where Product__c=:productId];
        return lstBom;
    }
    
    /*Description : Purpose of this method is to return PM_Approved_Mfg_Plant__c list for the .*/
    public static List<PM_Approved_Mfg_Plant__c> getPmApprovedPlants(String productId){
        List<PM_Approved_Mfg_Plant__c> lstPmApprovedPlants = [SELECT Id,Plant__c,Product__c FROM PM_Approved_Mfg_Plant__c where Product__c=:productId];
        return lstPmApprovedPlants;
    }
    /*Description : Purpose of this method is to return PM_Regulatory_Clearance__c list for the .*/
    public static List<PM_Regulatory_Clearance__c> getPmRegulatoryClearance(String productId){
        List<PM_Regulatory_Clearance__c> lstPmRegulatoryClearance = [SELECT Id,Reg_Clearance__c,Project__c,Regulatory_List__c FROM PM_Regulatory_Clearance__c where Project__c=:productId];
        return lstPmRegulatoryClearance;
    }
     /*Description : Purpose of this method is to return PM_Approved_WH__c list for the .*/
    public static List<PM_Approved_WH__c> getWarehouse(String productId){
        List<PM_Approved_WH__c> lstWarehouse = [SELECT Id,Warehouse__c,Product__c FROM PM_Approved_WH__c where Product__c=:productId];
        return lstWarehouse;
    }
    /*Description : Purpose of this method is to return List of users of same department except logged in user.*/
    public static List<User> getUsersOfSameDept(String dept){
    	id userId = UserInfo.getUserId();
    	List<User> lstUsers = [SELECT Id,Name,Department FROM User WHERE Department =: dept AND Id !=:userId];
    	return lstUsers;
    }
    
    /*Description : Purpose of this method is to return List of all accounts.*/
    public static List<Account> accountList(){
		List<Account> lstAccount = [select id, Name from Account];
		return lstAccount;         
    }
    
    /*Description : Purpose of this method is to return List of users of given department.*/
    public Static List<User> UsersByDept(){
        //for this method pass dept Name to get the users of given Dept
        List<User> lsrUser = [select id, name from User];
        return lsrUser;
    } 
    /*Description : Purpose of this method is to return List of product packages of given product.*/
    public static List<Product_Pkg__c> getProductPackages(String productId){
        List<Product_Pkg__c> lstProductPkg =[SELECT Id,Package_Name__c FROM Product_Pkg__c WHERE Product__c =: productId];  
        return lstProductPkg;
    }
    
	/*Description : Purpose of this method is to return product of given productId.*/    
    public static Product__c getProductRecord(String productId){
        Product__c prod =  [SELECT Id,
                            Name,
                            Procurement_RawMaterial__c,
                            Procurement_Erp__c,
                            MSDS__c,
                            All_Regulatory_Functions__c,
                            All_SHE_Function__c,
                            SHE_ERP__c,
                            All_MFG_Function__c,
                            MFG_ERP__c,
                            All_WH_Function__c,
                            WH_ERP__c, 
                            Costing_ERP__c FROM Product__c WHERE Id =: productId limit 1]; 
    	return prod;
    }  
}