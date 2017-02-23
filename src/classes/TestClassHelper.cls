/*
Description : This class is used as a helper class for test classes.
opportunity data
Created By : Mustafa 
Created Date : November 2016
*/
public class TestClassHelper {
    
    //Description:- Create number of opportunity records provided in count.
    public static List<Opportunity> CreateOpportunity(Integer count){
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(Integer i=0;i<count;i++){
            Opportunity opp = new Opportunity();
    		opp.Name = 'Sample Opportunity '+i;
    		opp.Customer_Name__c = 'James Bond';
    		opp.Amount = 50000;
    		Opp.CloseDate = Date.today().addDays(30);
    		opp.Description = 'Sample Description';
            opp.StageName = 'Prospecting';
    		lstOpportunity.add(opp);
        }
        insert lstOpportunity;
        return lstOpportunity;
    }
    
    //Description:- Create number of Account records provided in count.
    public static List<Account> CreateAccount(Integer count){
        List<Account> lstAccounts = new List<Account>();
        for(Integer i=0;i<count;i++){
            Account acc= new Account();
            acc.Name = 'Sample Account '+i;
            lstAccounts.add(acc);    
        }
        insert lstAccounts;
        return lstAccounts;
    }
    
    //Description:- Create number of product records specified in count parameter.
    public static List<Product__c> createProduct(Integer count){
        List<Product__c> lstProduct = new List<Product__c>();
        for(Integer i=0;i<count;i++){
			Product__c product = new Product__c();
            product.Name = 'Sample Product';
            product.Tradename__c = 'Some Trade';
            product.Project_Type__c = 'NPI';            
            lstProduct.add(product);
        }
        Insert lstProduct;  
        return lstProduct;
    }
    
    //Description:- Create number of project records specified in count parameter
    public static List<Project__c> createProject(List<Product__c> lstProduct){
        List<Project__c> lstProject = new List<Project__c>();
        for(Product__c varProduct : lstProduct){
            Project__c project = new Project__c();
            project.Status__c = 'Active';
            project.Approval_Status__c = 'Not Submitted';
            project.Department__c = 'Marketing';	
            project.Product__c = varProduct.Id;
            lstProject.add(project);
        }
        Insert lstProject; 
        return lstProject;
    }
    
    //Description:- Create user records
    public static void createUsers(Integer count, String dept){
        List<User> lsrusr = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        //for(Integer i=0;i<count;i++){
        	User u = new User(Alias = 'tstUser', Email='mustafa.jhabuawala1@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'RND', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa1@zen4orce.com');    
        
        	User u1 = new User(Alias = 'tstUser', Email='mustafa.jhabuawala2@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'RND', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa2@zen4orce.com');    
        
            lsrusr.add(u);
        //}
        Insert lsrusr;
    }
    
    //Description: Create RawMaterial Records
    public static void createRawMaterial(){
        List<RawMaterial__c> rawMaterialList = new List<RawMaterial__c>();
        RawMaterial__c rawMaterailOne = new RawMaterial__c();
        rawMaterailOne.Name = '10-3333';
        rawMaterailOne.R_Description__c = 'n-Propyl alcohol';
        rawMaterailOne.Active__c = 'A';
        rawMaterialList.add(rawMaterailOne);
        
        RawMaterial__c rawMaterailTwo = new RawMaterial__c();
        rawMaterailTwo.Name = '10-4444';
        rawMaterailTwo.R_Description__c = 'tert-Butyl Alcohol';
        rawMaterailTwo.Active__c = 'A';
        rawMaterialList.add(rawMaterailTwo);
        
        RawMaterial__c rawMaterailThree = new RawMaterial__c();
        rawMaterailThree.Name = '10-6666';
        rawMaterailThree.R_Description__c = 'Isoamyl Nitrate';
        rawMaterailThree.Active__c = 'A';
        rawMaterialList.add(rawMaterailThree);
        
        Insert rawMaterialList;
    }
    
    //Description : Create Reg_Inventory__c Records
    public static void CrearteRegInventoryRecords(){
        List<Reg_Inventory__c> regInventoryList = new List<Reg_Inventory__c>();
        Reg_Inventory__c regInventoryOne = new Reg_Inventory__c();
        regInventoryOne.CAS__c = '71-23-8';
        regInventoryOne.CAS_Description__c = '1-propanol';
        regInventoryList.add(regInventoryOne);
        
        Reg_Inventory__c regInventoryTwo = new Reg_Inventory__c();
        regInventoryTwo.CAS__c = '7647-01-0	';
        regInventoryTwo.CAS_Description__c = 'Hydrochloric acid';
        regInventoryList.add(regInventoryTwo);
        
        Reg_Inventory__c regInventoryThree = new Reg_Inventory__c();
        regInventoryThree.CAS__c = '75-65-0';
        regInventoryThree.CAS_Description__c = '2-Propanol, 2-methyl-';
        regInventoryList.add(regInventoryThree);
        
        Reg_Inventory__c regInventoryFour = new Reg_Inventory__c();
        regInventoryFour.CAS__c = '497-19-8';
        regInventoryFour.CAS_Description__c = 'Carbonic acid sodium salt (1:2)';
        regInventoryList.add(regInventoryFour);
        
        Reg_Inventory__c regInventoryFive = new Reg_Inventory__c();
        regInventoryFive.CAS__c = '7778-77-0';
        regInventoryFive.CAS_Description__c = 'Phosphoric acid, potassium salt (1:1)';
        regInventoryList.add(regInventoryFive);
        
        Reg_Inventory__c regInventorySix = new Reg_Inventory__c();
        regInventorySix.CAS__c = '109-64-8';
        regInventorySix.CAS_Description__c = 'Propane, 1,3-dibromo-';
        regInventoryList.add(regInventorySix);
        
        Reg_Inventory__c regInventorySeven = new Reg_Inventory__c();
        regInventorySeven.CAS__c = '51-45-6';
        regInventorySeven.CAS_Description__c = '1H-Imidazole-5-ethanamine';
        regInventoryList.add(regInventorySeven);
        
        Insert regInventoryList;
    }
    
    //Description : Create Chem Regulations Records
    public static void CreateChemRegulationRecords(){
        List<Chem_Regulation__c> chemRegulationList = new List<Chem_Regulation__c>();
        
        Chem_Regulation__c chemRegulationOne = new Chem_Regulation__c();
        chemRegulationOne.Name = 'FDA 176.170';
        chemRegulationList.add(chemRegulationOne);
        
        Chem_Regulation__c chemRegulationTwo = new Chem_Regulation__c();
        chemRegulationTwo.Name = 'FDA 176.180';
        chemRegulationList.add(chemRegulationTwo);
        
        Chem_Regulation__c chemRegulationThree = new Chem_Regulation__c();
        chemRegulationThree.Name = 'FIFRA';
        chemRegulationList.add(chemRegulationThree);
        
        Chem_Regulation__c chemRegulationFour = new Chem_Regulation__c();
        chemRegulationFour.Name = 'Halal';
        chemRegulationList.add(chemRegulationFour);
        
        Chem_Regulation__c chemRegulationFive = new Chem_Regulation__c();
        chemRegulationFive.Name = 'Kosher';
        chemRegulationList.add(chemRegulationFive);
        
        Chem_Regulation__c chemRegulationSix = new Chem_Regulation__c();
        chemRegulationSix.Name = 'NSF 60';
        chemRegulationList.add(chemRegulationSix);
        
        Chem_Regulation__c chemRegulationSeven = new Chem_Regulation__c();
        chemRegulationSeven.Name = 'REACH';
        chemRegulationList.add(chemRegulationSeven);
        
        Insert chemRegulationList;
    }
    
    //Description : Create PhysicalProperties Records
    public static void CreatePhysicalPropertiesRecords(){
        List<Physical_Properties__c> physicalPropertiesList = new List<Physical_Properties__c>();
        
        Physical_Properties__c physicalPropertiesOne = new Physical_Properties__c();
        physicalPropertiesOne.Name = 'Boiling Point';
        physicalPropertiesOne.UOM__c = 'oC';
        physicalPropertiesList.add(physicalPropertiesOne);
        
        Physical_Properties__c physicalPropertiesTwo = new Physical_Properties__c();
        physicalPropertiesTwo.Name = 'Density';
        physicalPropertiesTwo.UOM__c = 'g/mL';
        physicalPropertiesList.add(physicalPropertiesTwo);
        
        Physical_Properties__c physicalPropertiesThree = new Physical_Properties__c();
        physicalPropertiesThree.Name = 'Flash Point';
        physicalPropertiesThree.UOM__c = 'oC';
        physicalPropertiesList.add(physicalPropertiesThree);
        
        Physical_Properties__c physicalPropertiesFour = new Physical_Properties__c();
        physicalPropertiesFour.Name = 'Odor';
        physicalPropertiesFour.UOM__c = 'N/A';
        physicalPropertiesList.add(physicalPropertiesFour);
        
        Physical_Properties__c physicalPropertiesFive = new Physical_Properties__c();
        physicalPropertiesFive.Name = 'Parameter1';
        physicalPropertiesFive.UOM__c = 'KG/gram';
        physicalPropertiesList.add(physicalPropertiesFive);
        
        Physical_Properties__c physicalPropertiesSix = new Physical_Properties__c();
        physicalPropertiesSix.Name = 'Parameter2';
        physicalPropertiesSix.UOM__c = 'Liters';
        physicalPropertiesList.add(physicalPropertiesSix);
        
        Insert physicalPropertiesList;
    }
    
}