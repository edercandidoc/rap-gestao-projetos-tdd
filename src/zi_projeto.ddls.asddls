@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Gestão de Projetos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_Projeto
  as select from ztprojeto
  association [1..1] to ZI_StatusProjeto as _StatusText on $projection.Status = _StatusText.Status
{
   key projeto_id      as ProjetoId,
      nome_projeto    as NomeProjeto,
      cliente         as Cliente,
      data_inicio     as DataInicio,
      data_fim        as DataFim,
      status          as Status,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      
      case status
        when 'P' then 2 // Amarelo (Atenção/Planejamento)
        when 'A' then 3 // Verde (Ativo/Em Execução)
        when 'S' then 1 // Vermelho (Suspenso/Erro)
        when 'C' then 3 // Verde (Concluído)
        else 0          // Cinza (Neutro)
      end as StatusCriticality,
      
      case status
        when 'P' then 'sap-icon://customer-and-contacts' // Planejamento/Pessoas
        when 'A' then 'sap-icon://play'                  // Em execução
        when 'S' then 'sap-icon://stop'                  // Suspenso
        when 'C' then 'sap-icon://accept'                // Concluído/Check
        else '' 
      end as StatusIcon,
      
      // Adicione esta linha:
      dats_days_between(data_inicio, data_fim) as DuracaoDias,
      
      _StatusText
}
