CLASS lhc_ZI_Projeto DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Projeto RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Projeto RESULT result.

    METHODS validarDatas FOR VALIDATE ON SAVE
      IMPORTING keys FOR Projeto~validarDatas.
    METHODS setStatusInicial FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Projeto~setStatusInicial.

ENDCLASS.

CLASS lhc_ZI_Projeto IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validarDatas.

  " 1. Ler os dados do projeto usando EML (Entity Manipulation Language)
    READ ENTITIES OF ZI_Projeto IN LOCAL MODE
      ENTITY Projeto
        FIELDS ( DataInicio DataFim ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_projetos).

    LOOP AT lt_projetos INTO DATA(ls_projeto).
      " Lógica de Validação: Data Fim não pode ser menor que Data Início
      IF ls_projeto-DataFim < ls_projeto-DataInicio.

        " 2. Adicionar mensagem de erro ao parâmetro REPORTED
        APPEND VALUE #( %tky = ls_projeto-%tky ) TO failed-projeto.
        APPEND VALUE #( %tky = ls_projeto-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'A data de fim não pode ser anterior à data de início.' )
                        %element-datafim = if_abap_behv=>mk-on ) TO reported-projeto.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD setStatusInicial.

  " 1. Ler os dados dos projetos que estão sendo criados
  READ ENTITIES OF ZI_Projeto IN LOCAL MODE
    ENTITY Projeto
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_projetos).

  " 2. Filtrar apenas os que ainda não tem status (garantia)
  DELETE lt_projetos WHERE Status IS NOT INITIAL.

  IF lt_projetos IS NOT INITIAL.
    " 3. Atualizar o Status para 'P' (Planejamento)
    MODIFY ENTITIES OF ZI_Projeto IN LOCAL MODE
      ENTITY Projeto
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR projeto IN lt_projetos (
                         %tky   = projeto-%tky
                         Status = 'P' " Exemplo: P = Planejamento, A = Ativo, C = Concluído
                      ) )
      REPORTED DATA(lt_reported).

    " Passar eventuais mensagens de erro para o framework
    reported = CORRESPONDING #( DEEP lt_reported ).
  ENDIF.

  ENDMETHOD.

ENDCLASS.
