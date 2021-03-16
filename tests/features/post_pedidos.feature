Feature: post_pedidos
 
        Scenario: Genera token y llaves asimétricas
            Given I set bearer token
              And I have valid client TLS configuration
              And I set x-ismock header to true
             When I GET `apigeeDomain`/elektra/comercio/pedidos-productos/seguridad/v1/aplicaciones/llaves
             Then response code should be 200
              And response body should be valid json
              And I store the value of body path $.resultado.idAcceso as idAccess in global scope
              And I store the value of body path $.resultado.accesoPrivado as privateKey in global scope
              And I store the value of body path $.resultado.accesoPublico as publicKey in global scope


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


        Scenario Outline: /pedidos 201 Creado
            Given I set bearer token
              And I have valid client TLS configuration
              And I set x-idPais header to <x-idPais>
              And I set x-idCanal header to <x-idCanal>
              And I set x-idSucursal header to <x-idSucursal>
              And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
              And I set x-idAcceso header to `idAccess`
              And I need to encrypt the parameters {idUsuario, pagos.idTipo, pagos.importe, pagos.referencia}
              And I set Content-Type header to application/json
              And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","folioPresupuesto":"<folioPresupuesto>","folio":"<folio>","referencia":"<referencia>","pagos":[{"idTipo":"<idTipo>","importe":"<importe>","referencia":"<pagos0Referencia>"}],"foliosReferencia":[{"id":"<id>","idTipo":<foliosReferencia0IdTipo>}]}
             When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos
             Then response code should be 201
              And response body should be valid json
              And response body path $.codigo should be ^201\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
              And response body path $.mensaje should be ^.*$
              And response body path $.folio should be ^114-\d{15,22}$
              And response body path $.resultado.folioPedido should be [a-z0-9]*
              And response body path $.resultado.folioPreparametrico should be [a-z0-9]*
              And response body path $.resultado.numeroTransaccion should be \d*
              And response body path $.resultado.detalleOperacion should be ^.*$
              And response body path $.resultado.numeroMovimientoOperacion should be \d*

        Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | idUsuario | folioPresupuesto | folio    | referencia       | idTipo | importe | pagos0Referencia | id              | foliosReferencia0IdTipo |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | null     | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | null   | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | null    | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | null             | v31485575ekt-01 | 1                       |


        Scenario Outline: /pedidos 400 Entrada Incorrecta
            Given I set bearer token
              And I have valid client TLS configuration
              And I set x-idPais header to <x-idPais>
              And I set x-idCanal header to <x-idCanal>
              And I set x-idSucursal header to <x-idSucursal>
              And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
              And I set x-idAcceso header to `idAccess`
              And I need to encrypt the parameters {idUsuario, pagos.idTipo, pagos.importe, pagos.referencia}
              And I set Content-Type header to application/json
              And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","folioPresupuesto":"<folioPresupuesto>","folio":"<folio>","referencia":"<referencia>","pagos":[{"idTipo":"<idTipo>","importe":"<importe>","referencia":"<pagos0Referencia>"}],"foliosReferencia":[{"id":"<id>","idTipo":<foliosReferencia0IdTipo>}]}
             When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos
             Then response code should be 400
              And response body should be valid json
              And response body path $.codigo should be ^400\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
              And response body path $.mensaje should be ^.*$
              And response body path $.folio should be ^114-\d{15,22}$
              And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#400\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

        Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | idUsuario | folioPresupuesto | folio    | referencia       | idTipo | importe | pagos0Referencia | id              | foliosReferencia0IdTipo |
                  | 1        | 1         | 100          | WS_CAJA             | null      | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | null             | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | null             | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | null            | 1                       |
                  | 1        | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | null                    |


        Scenario Outline: /pedidos 401 No autorizado
            Given I set bearer token
              And I have valid client TLS configuration
              And I set x-idPais header to <x-idPais>
              And I set x-idCanal header to <x-idCanal>
              And I set x-idSucursal header to <x-idSucursal>
              And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
              And I set x-idAcceso header to `idAccess`
              And I need to encrypt the parameters {idUsuario, pagos.idTipo, pagos.importe, pagos.referencia}
              And I set Content-Type header to application/json
              And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","folioPresupuesto":"<folioPresupuesto>","folio":"<folio>","referencia":"<referencia>","pagos":[{"idTipo":"<idTipo>","importe":"<importe>","referencia":"<pagos0Referencia>"}],"foliosReferencia":[{"id":"<id>","idTipo":<foliosReferencia0IdTipo>}]}
             When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos
             Then response code should be 401
              And response body should be valid json
              And response body path $.codigo should be ^401\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
              And response body path $.mensaje should be ^.*$
              And response body path $.folio should be ^114-\d{15,22}$
              And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#401\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

        Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | idUsuario | folioPresupuesto | folio    | referencia       | idTipo | importe | pagos0Referencia | id              | foliosReferencia0IdTipo |
                  | null     | 1         | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | null      | 100          | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | null         | WS_CAJA             | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
                  | 1        | 1         | 100          | null                | T146363   | 863167           | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
			
 
        Scenario Outline: /pedidos 500 Operacion Inesperada
            Given I set bearer token
              And I have valid client TLS configuration
              And I set x-ismock header to true
              And I set x-idPais header to <x-idPais>
              And I set x-idCanal header to <x-idCanal>
              And I set x-idSucursal header to <x-idSucursal>
              And I set x-idEstacionTrabajo header to <x-idEstacionTrabajo>
              And I set x-idAcceso header to `idAccess`
              And I need to encrypt the parameters {idUsuario, pagos.idTipo, pagos.importe, pagos.referencia}
              And I set Content-Type header to application/json
              And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","folioPresupuesto":"<folioPresupuesto>","folio":"<folio>","referencia":"<referencia>","pagos":[{"idTipo":"<idTipo>","importe":"<importe>","referencia":"<pagos0Referencia>"}],"foliosReferencia":[{"id":"<id>","idTipo":<foliosReferencia0IdTipo>}]}
             When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos
             Then response code should be 500
              And response body should be valid json
              And response body path $.codigo should be ^500\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
              And response body path $.mensaje should be ^.*$
              And response body path $.folio should be ^114-\d{15,22}$
              And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#500\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

        Examples:
                  | x-idPais | x-idCanal | x-idSucursal | x-idEstacionTrabajo | idUsuario | folioPresupuesto | folio    | referencia       | idTipo | importe | pagos0Referencia | id              | foliosReferencia0IdTipo |
                  | SCDO     | 1         | 100          | WS_CAJA             | T146363   | 500863167        | V2312303 | VentaServicioWeb | 1      | 8771.01 | Cargo tarjeta    | v31485575ekt-01 | 1                       |
