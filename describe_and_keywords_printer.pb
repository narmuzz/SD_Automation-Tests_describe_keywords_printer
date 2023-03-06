; CÓMO AGREGAR PATHS
; Aumentar en un AMOUNT_OF_PATHS
; Agregar el elemento con su posición correspondiente. Listo

Global AMOUNT_OF_PATHS.i = 12
Global Dim imports_paths_array.s(AMOUNT_OF_PATHS)
imports_paths_array(0) = "/incidentPage"
imports_paths_array(1) = "/catalogPage"
imports_paths_array(2) = "/usersPage"
imports_paths_array(3) = "/helpDeskPage"
imports_paths_array(4) = "/workflowsPage"
imports_paths_array(5) = "/reportsPage"
imports_paths_array(6) = "/requestReplyAndSolutionPage"
imports_paths_array(7) = "/requestAssignPage"
imports_paths_array(8) = "/requestActionPage"
imports_paths_array(9) = "/knowledgePage"
imports_paths_array(10) = "/assetManagementPage"
imports_paths_array(11) = "/customizationPage"

; CÓMO AGREGAR MÉTODOS
; Agregar methods_map con la key que se quiera (puede ser cualquier cosa) y value igual al nombre del método en el código.
; Ir a "- PARSER DE MÉTODOS POR TEST -", si el path es nuevo sumar un Elseif, si el path existe no hace falta.
; Agregar el this_file_methods_map que se desee al if correspondiente.
; Ir a "- ACUMULADORES -" y crear un counter_ que arranque en 0.
; Agregar un case con la key que se uso anteriormente.
; Ir a resultados por test y agregar el counter nuevo.

Global NewMap methods_map.s()
methods_map("incidentPage_create") = "create("
methods_map("incidentPage_createEndUser") = "createEndUser("

methods_map("catalogPage_createCategory") = "createCategory("
methods_map("catalogPage_deleteCategory") = "deleteCategory("

methods_map("usersPage_create") = "create("
methods_map("usersPage_delete") = "delete("

methods_map("helpDeskPage_createHelpDesk") = "createHelpDesk("
methods_map("helpDeskPage_deleteHelpDesk") = "deleteHelpDesk("

methods_map("workflowsPage_import") = "importFile("
methods_map("workflowsPage_clickEditBotton") = "clickEditBotton("

methods_map("reportsPage_goToUrl") = "customRequest.goToUrl("
methods_map("reportsPage_setCategoryAsFilter") = "customRequest.setCategoryAsFilter("

methods_map("requestReplyAndSolutionPage_replyRequest") = "replyRequest("
methods_map("requestReplyAndSolutionPage_solve") = "solve("

methods_map("requestAssignPage_reassign") = "reassign("
methods_map("requestAssignPage_addWatcherToRequest") = "addWatcherToRequest("

methods_map("requestActionPage_duplicateIncident") = "duplicateIncident("
methods_map("requestActionPage_setWaitingFor") = "setWaitingFor("
methods_map("requestActionPage_setWaitingForDate") = "setWaitingForDate("

methods_map("knowledgePage_create") = "create("

methods_map("assetManagementPage_integrationExist") = "integrationExist("

methods_map("customizationPage_createField") = "createField("


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fin de pages y métodos a buscar

Global tests_path.s = ".\tests"
Global NewList files_list.s()
Global name_output_file.s = "Tests_method_usage-" + FormatDate("%yyyy-%mm-%dd_%hh_%ii_%ss", Date()) + ".csv"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PROCEDURES PROCEDURES PROCEDURES PROCEDURES PROCEDURES PROCEDURES PROCEDURES PROCEDURES

Procedure addFileNamesToList()
  
If ExamineDirectory(0, tests_path, "*")
  While NextDirectoryEntry(0)
    If (DirectoryEntryName(0) <> "." And DirectoryEntryName(0) <> "..")
      AddElement(files_list())
      files_list() = tests_path + "\" + DirectoryEntryName(0)
    EndIf
  Wend
  FinishDirectory(0)
EndIf

EndProcedure

Procedure exitProgramConfirmation()
  
  PrintN("")
  PrintN("Enter 'exit' to close the program")
  
  Repeat
    this_input.s = Input()
    
    If (UCase(this_input) = "EXIT")
      Break
    EndIf
  ForEver

EndProcedure

Procedure fileReaderAndParser()
    
  line_counter = 0
  
  ForEach files_list()
    NewMap this_file_methods_map.s()
    
    If ReadFile(0, files_list())
      NewMap this_import_X_page_map.s()
      
      before_describe = #True
      While Eof(0) = 0
        current_line.s = ReadString(0)
        line_counter = line_counter + 1
        
        For i = 0 To (AMOUNT_OF_PATHS - 1)
          If FindString(current_line, "describe(") And (before_describe = #True)
            describe$ = StringField(current_line, 2, "'")
            before_describe = #False
          EndIf
          
          If FindString(current_line, imports_paths_array(i)) <> 0 And before_describe = #True
            method_name$ = StringField(current_line, 2, " ") + "."
            this_import_X_page_map(imports_paths_array(i)) = method_name$
          EndIf
        Next
      Wend
      CloseFile(0)
    Else
      PrintN("ERROR")
    EndIf
  
    ForEach this_import_X_page_map() ; ------------------------ PARSER DE MÉTODOS POR TEST ------------------
      key.s = MapKey(this_import_X_page_map())
      If key = "/incidentPage"
        this_file_methods_map("incidentPage_create") = this_import_X_page_map() + methods_map("incidentPage_create")
        this_file_methods_map("incidentPage_createEndUser") = this_import_X_page_map() + methods_map("incidentPage_createEndUser")
        
      ElseIf key = "/catalogPage"
        this_file_methods_map("catalogPage_createCategory") = this_import_X_page_map() + methods_map("catalogPage_createCategory")
        this_file_methods_map("catalogPage_deleteCategory") = this_import_X_page_map() + methods_map("catalogPage_deleteCategory")
        
      ElseIf key = "/usersPage"
        this_file_methods_map("usersPage_create") = this_import_X_page_map() + methods_map("usersPage_create")
        this_file_methods_map("usersPage_delete") = this_import_X_page_map() + methods_map("usersPage_delete")
        
      ElseIf key = "/helpDeskPage"
        this_file_methods_map("helpDeskPage_createHelpDesk") = this_import_X_page_map() + methods_map("helpDeskPage_createHelpDesk")
        this_file_methods_map("helpDeskPage_deleteHelpDesk") = this_import_X_page_map() + methods_map("helpDeskPage_deleteHelpDesk")
        
      ElseIf key = "/workflowsPage"
        this_file_methods_map("workflowsPage_import") = this_import_X_page_map() + methods_map("workflowsPage_import")
        this_file_methods_map("workflowsPage_clickEditBotton") = this_import_X_page_map() + methods_map("workflowsPage_clickEditBotton")
        
      ElseIf key = "/reportsPage"
        this_file_methods_map("reportsPage_goToUrl") = this_import_X_page_map() + methods_map("reportsPage_goToUrl")
        this_file_methods_map("reportsPage_setCategoryAsFilter") = this_import_X_page_map() + methods_map("reportsPage_setCategoryAsFilter")
        
      ElseIf key = "/requestReplyAndSolutionPage"
        this_file_methods_map("requestReplyAndSolutionPage_replyRequest") = this_import_X_page_map() + methods_map("requestReplyAndSolutionPage_replyRequest")
        this_file_methods_map("requestReplyAndSolutionPage_solve") = this_import_X_page_map() + methods_map("requestReplyAndSolutionPage_solve")
        
      ElseIf key = "/requestAssignPage"
        this_file_methods_map("requestAssignPage_reassign") = this_import_X_page_map() + methods_map("requestAssignPage_reassign")
        this_file_methods_map("requestAssignPage_addWatcherToRequest") = this_import_X_page_map() + methods_map("requestAssignPage_addWatcherToRequest")
        
      ElseIf key = "/requestActionPage"
        this_file_methods_map("requestActionPage_duplicateIncident") = this_import_X_page_map() + methods_map("requestActionPage_duplicateIncident")
        this_file_methods_map("requestActionPage_setWaitingFor") = this_import_X_page_map() + methods_map("requestActionPage_setWaitingFor")
        this_file_methods_map("requestActionPage_setWaitingForDate") = this_import_X_page_map() + methods_map("requestActionPage_setWaitingForDate")
        
      ElseIf key = "/knowledgePage"
        this_file_methods_map("knowledgePage_create") = this_import_X_page_map() + methods_map("knowledgePage_create")
        
      ElseIf key = "/assetManagementPage"
        this_file_methods_map("assetManagementPage_integrationExist") = this_import_X_page_map() + methods_map("assetManagementPage_integrationExist")
        
      ElseIf key = "/customizationPage"
        this_file_methods_map("customizationPage_createField") = this_import_X_page_map() + methods_map("customizationPage_createField")
      EndIf
    Next
    
    If ReadFile(0, files_list())
      
    ; ---------- ACUMULADORES ---------------------------------------------------------
      NewMap counters_map.i()
      counters_map("incidentPage_create") = 0
      
      counters_map("incidentPage_create") = 0
      counters_map("incidentPage_createEndUser") = 0
      
      counters_map("catalogPage_createCategory") = 0
      counters_map("catalogPage_deleteCategory") = 0
      
      counters_map("usersPage_create") = 0
      counters_map("usersPage_delete") = 0
      
      counters_map("helpDeskPage_createHelpDesk") = 0
      counters_map("helpDeskPage_deleteHelpDesk") = 0
      
      counters_map("workflowsPage_import") = 0
      counters_map("workflowsPage_clickEditBotton") = 0
      
      counters_map("reportsPage_goToUrl") = 0
      counters_map("reportsPage_setCategoryAsFilter") = 0
      
      counters_map("requestReplyAndSolutionPage_replyRequest") = 0
      counters_map("requestReplyAndSolutionPage_solve") = 0
      
      counters_map("requestAssignPage_reassign") = 0
      counters_map("requestAssignPage_addWatcherToRequest") = 0
      
      counters_map("requestActionPage_duplicateIncident") = 0
      counters_map("requestActionPage_setWaitingFor") = 0
      counters_map("requestActionPage_setWaitingForDate") = 0
      
      counters_map("knowledgePage_create") = 0
      
      counters_map("assetManagementPage_integrationExist") = 0
      
      counters_map("customizationPage_createField") = 0
      
      While Eof(0) = 0
        current_line.s = ReadString(0)     
        ForEach this_file_methods_map()
          If FindString(current_line, this_file_methods_map())
            key.s = MapKey(this_file_methods_map())
            counters_map(key) = counters_map(key) + 1
          EndIf
        Next        
      Wend
      CloseFile(0)
      
      ; --------------------------- RESULTADO POR TEST -----------------------------------------------
      If OpenFile(0, name_output_file)
        FileSeek(0, Lof(0))
        WriteStringN(0, "")
        
        WriteString(0, StringField(files_list(), 3, "\") + ";")
        
        WriteString(0, "Describe: " + describe$ + ";")
        
        WriteString(0, "Tickets creados: " + counters_map("incidentPage_create") + ";")
        WriteString(0, "Tickets creados por end users: " + counters_map("incidentPage_createEndUser") + ";")
        
        WriteString(0, "Categorias creadas: " + counters_map("catalogPage_createCategory") + ";")
        WriteString(0, "Categorias borradas: " + counters_map("catalogPage_deleteCategory") + ";")
        
        WriteString(0, "Usuarios creados: " + counters_map("usersPage_create") + ";")
        WriteString(0, "Usuarios borrados: " + counters_map("usersPage_delete") + ";")
        
        WriteString(0, "Help desks creados: " + counters_map("helpDeskPage_createHelpDesk") + ";")
        WriteString(0, "Help desks borrados: " + counters_map("helpDeskPage_deleteHelpDesk") + ";")
        
        WriteString(0, "Workflows importados: " + counters_map("workflowsPage_import") + ";")
        WriteString(0, "Clicks en editar workflow: " + counters_map("workflowsPage_clickEditBotton") + ";")
        
        WriteString(0, "Veces que fue a reportes: " + counters_map("reportsPage_goToUrl") + ";")
        WriteString(0, "Veces que setteo categoria como flitro en reportes: " + counters_map("reportsPage_setCategoryAsFilter") + ";")
        
        WriteString(0, "Replies en tickets: " + counters_map("requestReplyAndSolutionPage_replyRequest") + ";")
        WriteString(0, "Tickets solucionados: " + counters_map("requestReplyAndSolutionPage_solve") + ";")
        
        WriteString(0, "Reasignaciones de tickets: " + counters_map("requestAssignPage_reassign") + ";")
        WriteString(0, "Watchers agregados a tickets: " + counters_map("requestAssignPage_addWatcherToRequest") + ";")
        
        WriteString(0, "Veces que se duplicaron tickets: " + counters_map("requestActionPage_duplicateIncident") + ";")
        WriteString(0, "Veces que se cambio el waiting status de tickets: " + counters_map("requestActionPage_setWaitingFor") + ";")
        WriteString(0, "Veces que se dejo un ticket esperando por fecha: " + counters_map("requestActionPage_setWaitingForDate") + ";")
        
        WriteString(0, "Articulos de Knowledge Base creados: " + counters_map("knowledgePage_create") + ";")
        
        WriteString(0, "Veces que se valido integracion con Insight: " + counters_map("assetManagementPage_integrationExist") + ";")
        
        WriteString(0, "Custom fields creados: " + counters_map("customizationPage_createField") + ";")
        
        CloseFile(0)
      EndIf
      
    Else
      PrintN("ERROR")
    EndIf
  Next
  
  PrintN("")
  PrintN("Lines of code in all specs: " + Str(line_counter))
  
EndProcedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA PROGRAMA 

OpenConsole()

If CreateFile(0, name_output_file)
  WriteStringN(0, "Github link; https://github.com/narmuzz/SD_Automation-Tests_describe_keywords_printer ;")
  PrintN("Output created: " + name_output_file)
Else
  PrintN("Error creating output")
EndIf

addFileNamesToList()
fileReaderAndParser()

PrintN("All done, check output file")
exitProgramConfirmation()
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 197
; FirstLine = 234
; Folding = -
; EnableXP
; DPIAware