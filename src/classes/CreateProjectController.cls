public class CreateProjectController {
    
    //Properties
    public Product__c product;
    public Project__c projectRecord{get;set;}
    public Project__c project; 
    public String userAction{get;set;}
    public static boolean reset{get;set;}
    public String opId{get;set;}
    public String selectedUser{get;set;}
    public Boolean rendereViewOppPanel{get;set;}
    public PM_Application__c PMApplication;
    public List<Product_Pkg__c> lstProductPkg;
    public Opportunity_Projects__c opportunityProject;
    public List<PM_Regulatory_Clearance__c> lstPMRrgulatoryClearance;
    public List<regulatoryWrapper> lstRegulatoryWrapper;
    public List<pkgSizeWrapper> lstPkgSizeWrapper;
    public List<User> lstUser;
    List<SelectOption> lstUserOptions;
    public map<Id,PM_Application__c> mapSelectedPMApplication;
    List<PM_Application__c> lstSelectedPMApplication;
    public String selectedValue;
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    Map<String, regulatoryWrapper> pmRegulationMap ;
    Map<String, pkgSizeWrapper> pkgSizeWrapperMap ;
    
    //getter method for product Object.
    public Product__c getProduct(){
        try{
            if(reset == true){
                resetComponent();               
            }
            reset = false; 
            if(product == null){
                if(projectRecord == null){
                    product = new Product__c();
                    project = new Project__c();
                }
                else{
                    project = projectRecord;
                    product = TurboPLMSelector.getProductDetails(projectRecord.Product__c);
            	}
            }
        }catch(Exception e){
            System.debug('ERROR'+e.getMessage()); 
        }
        return product;
    }
    
    //setter method for product
    public void setProduct(Product__c varProduct){
        this.product = varProduct;
    }
    
    //Purpose of this method is to prepare SelectOption List of Application method.  
    public List<SelectOption> getApplication(){
        List<Applications__c> lstApplications = TurboPLMSelector.getApplication();
        List<SelectOption> lstApplicationOptions = new List<SelectOption>();
        try{
            lstApplicationOptions.add(new SelectOption('Select','--Select--'));
            for(Applications__c app:lstApplications ){
                lstApplicationOptions.add(new SelectOption(app.Id,app.Name));  
            }            
        }catch(Exception e){
            System.debug('ERROR'+e.getMessage());
        }
        return lstApplicationOptions;
    }
    
    //Purpose of this method is to populate Application value in selectList.
    public String getSelectedValue(){
        try{
            if(product!=null){
                mapSelectedPMApplication = new map<Id,PM_Application__c>();
                List<PM_Application__c> lstPMApplication = TurboPLMSelector.getPMApplication(product.Id);
                if(lstPMApplication != null && lstPMApplication.size()>0){
                    selectedValue = lstPMApplication[0].Applications__c;
                    PMApplication = lstPMApplication[0];
                    mapSelectedPMApplication.put(lstPMApplication[0].Applications__c,lstPMApplication[0]);
                }
                else{
                    selectedValue = 'Select';
                }
            }            
        }catch(Exception e){
            System.debug('ERROR'+e.getMessage()); 
        }
        return selectedValue;
    }
    
    //Purpose of this method is to set selected value of Application__c.
    public void setSelectedValue(String selValue){
            this.selectedValue= selValue;            
    }
    
    //Purpose of this method is to populate Regulatory__c with checkbox.    
    public List<regulatoryWrapper> getchemReg(){
        try{
            if(lstRegulatoryWrapper == null){
                pmRegulationMap = new Map<String, regulatoryWrapper>();
                lstRegulatoryWrapper = new List<regulatoryWrapper>();
                List<Chem_Regulation__c> lstChemregulation = TurboPLMSelector.getChemRegulation();
                List<PM_Regulatory_Clearance__c> lstPMRegulatoryClearance = new List<PM_Regulatory_Clearance__c>();
                if(projectRecord!=null){
                    lstPMRegulatoryClearance = TurboPLMSelector.getPMPMRegulatoryClearance(product.Id);                
                }
                for(Chem_Regulation__c chemRegulation : lstChemregulation){
                    RegulatoryWrapper regWrapper;
                    Boolean isSelected = false;
                    for(PM_Regulatory_Clearance__c varPMRegClr : lstPMRegulatoryClearance){
                        if(chemRegulation.Id == varPMRegClr.Regulatory_List__c){
                            regWrapper = new regulatoryWrapper(chemRegulation,varPMRegClr,true);
                            lstRegulatoryWrapper.add(regWrapper);
                            isSelected = true;
                        }
                    }
                    if(!isSelected){
                        regWrapper = new regulatoryWrapper(chemRegulation,null,false);
                        lstRegulatoryWrapper.add(regWrapper);
                    }
                    PMRegulationmap.put(chemRegulation.Name,regWrapper);
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return lstRegulatoryWrapper;
    }
    
    //Purpose of this method is to populate Pkg_Size__c with checkbox.
    public List<pkgSizeWrapper> getpkgSize(){
        try{
            if(lstPkgSizeWrapper==null){
                pkgSizeWrapperMap = new Map<String, pkgSizeWrapper>();
                lstPkgSizeWrapper = new List<pkgSizeWrapper>();
                List<Pkg_Size__c> lstpkgSize = TurboPLMSelector.getPkgSize();
                map<Id,Pkg_Size__c> insertedMapPkgSize = new map<Id,Pkg_Size__c>();
                List<Product_Pkg__c> lstProductPkg = new List<Product_Pkg__c>();
                pkgSizeWrapper varPkgSizeWrapper;
                if(projectRecord!=null){
                    lstProductPkg = TurboPLMSelector.getProductPkg(product.Id);
                }
                for(Pkg_Size__c pkgSize:lstpkgSize){
                    Boolean isSelected = false;
                    for(Product_Pkg__c varProductPkg:lstProductPkg){
                        if(pkgSize.Id==varProductPkg.Pkg_Size__c){
                            varPkgSizeWrapper = new pkgSizeWrapper(pkgSize, varProductPkg, true);                           
                            lstPkgSizeWrapper.add(varPkgSizeWrapper);
                            isSelected = true;
                        }
                    }
                    if(!isSelected){
                        varPkgSizeWrapper = new pkgSizeWrapper(pkgSize,null,false);
                        lstPkgSizeWrapper.add(varPkgSizeWrapper);
                    }
                    pkgSizeWrapperMap.put(pkgSize.Name,varPkgSizeWrapper);
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstPkgSizeWrapper;
    }
    
    //Purpose of this method is to Save project record with junction objects.
    public void saveProductAndProject(){
        try{
            if(product.Id == null){
                notificationType = 'success';
                notificationMessage = Label.SaveMessage;
            }
            else{
                notificationType = 'success';
                notificationMessage = Label.UpdateMessage;
            }
            product.Project_Type__c='NPI';
            ProjectDomain.upsertProduct(product);
            if(product.Id==null){
                notificationMessage = Label.FailureMessage;
                notificationType = 'error';
            }
            if(project.Product__c==null){
                project.Product__c = product.Id;            
            }
            project.Project_Type__c = 'NPI';
            project.Status__c = 'Active';
            project.Approval_Status__c = 'Not Submitted';
            project.Department__c = 'Marketing';
            ProjectDomain.upsertProject(project);
            if(opId != null){
                if(opportunityProject == null){
                    opportunityProject = new Opportunity_Projects__c();
                    opportunityProject.Opportunity__c= opId;
                    opportunityProject.Projects_and_Approval__c = project.Id;   
                    upsert opportunityProject;
                }
            }
            updatePMApplication();
            updateProductPkg();
            updateRegulatoryClearance();
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    //Purpose of this method is to create and update PM_Application__c record.
    public void updatePMApplication(){
        try{
            if(selectedValue!='Select'){
                if(PMApplication == null ){
                    PMApplication = new PM_Application__c();
                    PMApplication.Project__c = product.Id;   
                }
                PMApplication.Applications__c = selectedValue;    
                ProjectDomain.upsertPMApplication(PMApplication);
            }
            else{// 14-2-2017
                if(PMApplication!=null){
                    ProjectDomain.deletePm_ApplicationRecords(PMApplication);
                    PMApplication = null;
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
    }
    
    //Purpose of this method is to update Product_Pkg__c record.
    public void updateProductPkg(){
        try{
            List<Product_Pkg__c > lstProductPkgToInsert = new List<Product_Pkg__c >();
            List<Product_Pkg__c> lstPkgSizeIds = new List<Product_Pkg__c>();
            for(pkgSizeWrapper varPkgWrapper:lstPkgSizeWrapper){
                if(varPkgWrapper.pkgselected){
                    if(varPkgWrapper.prdtPkg == null){
                        Product_Pkg__c productPkg = new Product_Pkg__c();
                        productPkg.Pkg_Size__c = varPkgWrapper.pksize.Id;
                        productPkg.Product__c = product.Id;
                        productPkg.Projects_and_Approval__c = project.Id;   
                        lstProductPkgToInsert.add(productPkg);
                    }else{}
                }
                else if(varPkgWrapper.prdtPkg != null){
                    lstPkgSizeIds.add(varPkgWrapper.prdtPkg);
                    varPkgWrapper.prdtPkg = null;
                }
            }   
            insertProductPkg(lstProductPkgToInsert);
            ProjectDomain.updateProductPkg(lstProductPkgToInsert);
            if(lstPkgSizeIds.size()>0){
                ProjectDomain.deleteProductPkgRecords(lstPkgSizeIds); 
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Purpose of this method is to create and update PM_Regulatory_Clearance__c record.
    public void updateRegulatoryClearance(){
        try{
            List<PM_Regulatory_Clearance__c> lstPMRrgulatoryClearanceToInsert = new List<PM_Regulatory_Clearance__c>();
            List<PM_Regulatory_Clearance__c> lstChemRegulationIds = new List<PM_Regulatory_Clearance__c>();
            for(regulatoryWrapper varRegWrapper : lstRegulatoryWrapper){
                if(varRegWrapper.regselected){
                    if(varRegWrapper.pmReg == null){
                        PM_Regulatory_Clearance__c varPMregClearance = new PM_Regulatory_Clearance__c();
                        varPMregClearance.Project__c = product.Id;
                        varPMregClearance.Reg_Clearance__c = 'No';
                        varPMregClearance.Regulatory_List__c = varRegWrapper.regulation.Id;
                        lstPMRrgulatoryClearanceToInsert.add(varPMregClearance);    
                    }
                }
                else if(varRegWrapper.pmReg != null){
                    lstChemRegulationIds.add(varRegWrapper.pmReg);
                    varRegWrapper.pmReg = null;
                }
            }
            insertPMRegulatoryClearance(lstPMRrgulatoryClearanceToInsert);
            if(lstChemRegulationIds.size()>0){
                ProjectDomain.deletePmRegulatoryClearance(lstChemRegulationIds);
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Purpose of this method is to create Product_Pkg__c record
    public void insertProductPkg(List<Product_Pkg__c> lstProductPkg){
        try{
            if(lstProductPkg.size()>0){
                ProjectDomain.updateProductPkg(lstProductPkg);    
            }
            for(Product_Pkg__c pkg: lstProductPkg){
                for(pkgSizeWrapper varpkgSizeWrapper : lstPkgSizeWrapper){
                    if(varpkgSizeWrapper.pkSize.Id == pkg.Pkg_Size__c){
                        varpkgSizeWrapper.prdtPkg = pkg;
                    }
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Purpose of this method is to create PM_Regulatory_Clearance__c record.
    public void insertPMRegulatoryClearance(List<PM_Regulatory_Clearance__c> lstPMregClearance){
        try{
            if(lstPMregClearance.size()>0){
                ProjectDomain.insertPMRegClearance(lstPMregClearance);    
            }
            for(PM_Regulatory_Clearance__c varPmRegClearance:lstPMregClearance){
                for(regulatoryWrapper varRegWrapper :lstRegulatoryWrapper){
                    if(varRegWrapper.regulation.Id == varPmRegClearance.Regulatory_List__c){
                        varRegWrapper.pmReg = varPmRegClearance;    
                    }
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Purpose of this method is to create/update Project record and submit it for approval.
    public void saveAndSubmit(){
        try{
        saveProductAndProject();
        List<ProcessInstanceWorkItem> workItemList = new List<ProcessInstanceWorkItem>();
        if(project.id!=null)
            workItemList = TurboPLMSelector.getProcessInstanceWorkItemRecord(String.valueOf(project.Id)); 
        if(workItemList.size() == 0){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval');
            req.setObjectId(project.Id); 
            req.setNextApproverIds(new Id[] {selectedUser});
            Approval.ProcessResult result = Approval.process(req);
            if(result.isSuccess()){
                notificationType = 'success';
                notificationMessage = Label.SubmitMessage;
            }
            else{
                notificationType = 'error';
                notificationMessage = Label.FailureMessage;
            }
            project.Approval_Status__c = 'Submitted';
            project.Department__c = 'R&D';
            ProjectDomain.upsertProject(project);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Record is already in process'));            
        }
        }catch(Exception e){
           System.debug('ERROR='+e.getMessage());
        }            
    }
    
    //Purpose of this method is to reset data. 
    public void resetComponent(){
        reset = false;
        product = null;
        project = null;
        PMApplication = null;
        selectedValue = 'Select';
        lstRegulatoryWrapper = null;
        lstPkgSizeWrapper = null;
        opportunityProject = null;
    }
    
    //Wrapper class for Chem_Regulation__c
    public class regulatoryWrapper {
        public Chem_Regulation__c regulation {get; set;}
        public Boolean regselected {get; set;}
        public PM_Regulatory_Clearance__c pmReg {get;set;}
        public regulatoryWrapper(Chem_Regulation__c c, PM_Regulatory_Clearance__c varPMReg, Boolean isChemRegSelected) {
            regulation = c;
            regselected = isChemRegSelected;
            pmReg = varPMReg;
        }
    }
    
    //Wrapper class for Pkg_Size__c
    public class pkgSizeWrapper{
        public Pkg_Size__c pkSize {get; set;}
        public Boolean pkgselected {get; set;}
        public Product_Pkg__c prdtPkg{get;set;}
        public pkgSizeWrapper(Pkg_Size__c c, Product_Pkg__c varprdtPkg, Boolean isPkgSizeSelected) {
            pkSize = c;
            pkgselected = isPkgSizeSelected;
            prdtPkg = varprdtPkg;
        }
    }
    
    //Purpose of this method is to update status of project to Terminated.
    public void updateProjectStatus(){
        try{
            if(projectRecord !=null)
            {
                projectRecord.Status__c='Terminated';
                if(ProjectDomain.upsertProject(projectRecord)){
                    notificationType = 'success';
                    notificationMessage = Label.TerminateMessage;
                    
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
         List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('R&D');
           	lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstUsers;
    } 
}