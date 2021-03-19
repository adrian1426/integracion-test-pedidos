Feature: /pedidos/folio PUT

      Actualización del pedido o de la orden Elektra com.

      Scenario: Negocio un consumer key y secret key de la app de prueba
            Given I have basic authentication credentials `apigeeUsername` and `apigeePassword`
            And I have valid client TLS configuration
            When I GET `apigeeHost`/v1/organizations/`apigeeOrg`/developers/`apigeeDeveloper`/apps/`apigeeApp`
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.credentials[*].consumerKey as globalConsumerKey in global scope
            And I store the value of body path $.credentials[*].consumerSecret as globalConsumerSecret in global scope


      Scenario: Negocia un access token con el Authorization server
            Given I set form parameters to
                  | parameter  | value              |
                  | grant_type | client_credentials |
            And I have basic authentication credentials `globalConsumerKey` and `globalConsumerSecret`
            And I have valid client TLS configuration
            When I POST to `apigeeDomain`/`apigeeOauthEndpoint`
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.access_token as access token

      Scenario: Genera token y llaves asimétricas
            Given I set bearer token
            And I have valid client TLS configuration
            And I set x-ismock header to true
            When I GET `apigeeDomain`/elektra/seguridad/v1/aplicaciones/llaves
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.resultado.idAcceso as idAccess in global scope
            And I store the value of body path $.resultado.accesoPublico as publicKey in global scope

      Scenario Outline: 200 ok.
            Verificar que se obtenga la información relacionada desde una transacción PUT en /pedidos/folio
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","idEstatusFolio":<idEstatusFolio>,"idTipoOperacion":<idTipoOperacion>}
            When I PUT `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>
            Then response code should be 200
            And response body should be valid json
            And response body path $.codigo should be ^200\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^[A-Za-záéíóúÁÉÍÓÚ0-9@.,\s:]{1,255}$
            And response body path $.folio should be ^[a-zA-Z0-9-\w]{1,}$
            And response body path $.resultado.folioValido should be ^(true|false)$
            And response body path $.resultado.numeroMovimientoOperacion should be ^[0-9]{1,4}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | folio  | idUsuario | idEstatusFolio | idTipoOperacion |
                  | 1        | 1         | 100          | WS_CAJA             | 146625 | T146363   | 0              | 6               |


      Scenario Outline: 400 Entrada Incorrecta
            Verificar que se obtenga una salida incorrecta al enviar una petición malformada desde una transacción PUT en /pedidos/folio
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","idEstatusFolio":<idEstatusFolio>,"idTipoOperacion":<idTipoOperacion>}
            When I PUT `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>
            Then response code should be 400
            And response body should be valid json
            And response body path $.codigo should be ^400\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^[A-Za-záéíóúÁÉÍÓÚ0-9@.,\s:]{1,255}$
            And response body path $.folio should be ^[a-zA-Z0-9-\w]{1,}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#400\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | folio  | idUsuario | idEstatusFolio | idTipoOperacion |
                  | null     | 1         | 100          | WS_CAJA             | 146625 | T146363   | 0              | 6               |
                  | 1        | null      | 100          | WS_CAJA             | 146625 | T146363   | 0              | 6               |
                  | 1        | 1         | null         | WS_CAJA             | 146625 | T146363   | 0              | 6               |
                  | 1        | 1         | 100          | null                | 146625 | T146363   | 0              | 6               |
                  | 1        | 1         | 100          | WS_CAJA             | null   | T146363   | 0              | 6               |
                  | 1        | 1         | 100          | WS_CAJA             | 146625 | null      | 0              | 6               |
                  | 1        | 1         | 100          | WS_CAJA             | 146625 | T146363   | null           | 6               |
                  | 1        | 1         | 100          | WS_CAJA             | 146625 | T146363   | 0              | null            |


      Scenario Outline: 401 No autorizado
            Verificar que se obtenga una salida de acceso no autorizado desde una transacción PUT en /pedidos/folio
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
            And I set x-idAcceso header to Q123545658548
            And I need to encrypt the parameters {idUsuario}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","idEstatusFolio":<idEstatusFolio>,"idTipoOperacion":<idTipoOperacion>}
            When I PUT `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>
            Then response code should be 401
            And response body should be valid json
            And response body path $.codigo should be ^401\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^[A-Za-záéíóúÁÉÍÓÚ0-9@.,\s:]{1,255}$
            And response body path $.folio should be ^[a-zA-Z0-9-\w]{1,}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#401\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | folio     | idUsuario | idEstatusFolio | idTipoOperacion |
                  | 1        | 1         | 100          | WS_CAJA             | 401146625 | T146363   | 0              | 6               |


      Scenario Outline:  500 Operacion Inesperada
            Verificar que se obtenga un error inesperado desde una transacción PUT en /pedidos/folio
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-ismock header to true
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","idEstatusFolio":<idEstatusFolio>,"idTipoOperacion":<idTipoOperacion>}
            When I PUT `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>
            Then response code should be 500
            And response body should be valid json
            And response body path $.codigo should be ^500\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^[A-Za-záéíóúÁÉÍÓÚ0-9@.,\s:]{1,255}$
            And response body path $.folio should be ^[a-zA-Z0-9-\w]{1,}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#500\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | folio     | idUsuario | idEstatusFolio | idTipoOperacion |
                  | sda      | 1         | 100          | WS_CAJA             | 500146625 | T146363   | 0              | 6               |

 