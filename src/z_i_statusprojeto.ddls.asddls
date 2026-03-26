@AbapCatalog.sqlViewName: 'ZSTATPROJ'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de Pesquisa - Status do Projeto'
@ObjectModel.resultSet.sizeCategory: #XS

define view ZI_StatusProjeto
  as select from I_Language -- Usamos a tabela de idiomas apenas como 'âncora'
{
      @ObjectModel.text.element: ['StatusTexto']
  key 'P'            as Status,
      'Planejamento' as StatusTexto
}
where
  Language = 'P' -- Filtramos apenas um registro para o Union não triplicar
  
union all select from I_Language { key 'A' as Status, 'Ativo'     as StatusTexto } where Language = 'P'
union all select from I_Language { key 'S' as Status, 'Suspenso'  as StatusTexto } where Language = 'P'
union all select from I_Language { key 'C' as Status, 'Concluído' as StatusTexto } where Language = 'P'
