CLASS ltcl_projeto_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      setup,
      teardown,
      test_validar_datas_erro FOR TESTING.

ENDCLASS.



CLASS ltcl_projeto_test IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create(
        i_for_entity = 'ZI_PROJETO' ).
  ENDMETHOD.



  METHOD setup.
    cl_abap_unit_assert=>assert_bound(
      act = environment
      msg = 'Ambiente de teste não foi inicializado.' ).

    environment->clear_doubles( ).
  ENDMETHOD.


  METHOD test_validar_datas_erro.

    " -----------------------------------------------------------------
    " GIVEN - Dados válidos previamente existentes (mock da tabela base)
    " -----------------------------------------------------------------
    DATA lt_projeto_mock TYPE STANDARD TABLE OF ztprojeto.

    lt_projeto_mock = VALUE #(
      ( projeto_id = '02D1577E4D621EDB89E39977E1E74E01'
        data_inicio = '20250101'
        data_fim    = '20261231' ) ).

    environment->insert_test_data( i_data = lt_projeto_mock ).


    " -----------------------------------------------------------------
    " WHEN - Tenta atualizar com data inválida (fim < início)
    " -----------------------------------------------------------------
    DATA lt_update TYPE TABLE FOR UPDATE zi_projeto.

    lt_update = VALUE #(
      ( projetoid = '02D1577E4D621EDB89E39977E1E74E01'
        datainicio = '20250101'
        datafim    = '20261231'
        %control-datainicio = if_abap_behv=>mk-on
        %control-datafim    = if_abap_behv=>mk-on
        ) ).  " <-- ERRO proposital

    MODIFY ENTITIES OF zi_projeto
      ENTITY Projeto
      UPDATE FROM lt_update
      FAILED DATA(lt_failed_mod)
      REPORTED DATA(lt_reported_mod).

    IF lt_failed_mod IS INITIAL.
      COMMIT ENTITIES
        RESPONSE OF zi_projeto
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).
    ENDIF.

    " -----------------------------------------------------------------
    " THEN - Deve haver falha
    " -----------------------------------------------------------------
    cl_abap_unit_assert=>assert_not_initial(
      act = lt_failed-projeto
      msg = 'A validação deveria ter rejeitado data_fim < data_inicio.' ).

  ENDMETHOD.


  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.


  METHOD class_teardown.
    IF environment IS BOUND.
      environment->destroy( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
