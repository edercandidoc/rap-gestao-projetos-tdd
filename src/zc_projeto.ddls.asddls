@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection - Gestão de Projetos'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define root view entity ZC_Projeto
  provider contract transactional_query
  as projection on ZI_Projeto
{
  
      @EndUserText.label: 'ID do Projeto'
      @Search.defaultSearchElement: true     
  key ProjetoId,
      @EndUserText.label: 'Nome do Projeto'
      @Search.defaultSearchElement: true
      NomeProjeto,
      @EndUserText.label: 'Cliente'
      @Search.defaultSearchElement: true
      Cliente,
      @EndUserText.label: 'Início'
      @Search.defaultSearchElement: true
      DataInicio,
      @EndUserText.label: 'Fim'
      @Search.defaultSearchElement: true
      DataFim,
      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_StatusProjeto', element: 'Status' } }]
      @ObjectModel.text.element: ['StatusTexto'] // Faz o Fiori buscar o texto na associação
      Status,
      /* Campo de texto que vem da associação */
      @EndUserText.label: 'Descrição Status'
      _StatusText.StatusTexto as StatusTexto,
      @EndUserText.label: 'Última Alteração'
      LastChangedAt,
      StatusCriticality,
      StatusIcon,
      
      @EndUserText.label: 'Duração (Dias)'
      DuracaoDias,
  
      /* Expor a associação */
  _StatusText
}
