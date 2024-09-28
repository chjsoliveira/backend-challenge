## Endpoints da API

### Validação de JWT


- **URL:** `POST /api/jwtvalidation/validate`
- **Descrição:** Este endpoint é responsável por validar um token JWT. Ele recebe um token JWT no corpo da requisição e retorna o resultado da validação, informando se o token é válido ou não.
- **Requisição:** 
  - **Cabeçalhos:** `Content-Type: application/json`
  - **Corpo:** O corpo da requisição deve conter o token JWT que deseja validar no formato JSON. 
      ```json
    "{SEU_TOKEN_AQUI}"
    ```
- **Exemplo de Requisição com `curl`:**

    ```bash
    curl --request POST \
      --url http://localhost:5088/api/jwtvalidation/validate \
      --header 'Content-Type: application/json' \
      --data '"{SEU_TOKEN_AQUI}"'
    ```

- **Resposta:**
  
	A resposta será um objeto JSON contendo informações sobre a validação. Um exemplo de resposta de sucesso é:

    ```json
    {
      "valid": true
    }
    ```

	Em caso de falha na validação, a resposta pode ser:

    ```json
    {
      "valid": false
    }
    ```

- **Códigos de Status:**
	- `200 OK`: O token foi validado com sucesso.
	- `400 Bad Request`: O corpo da requisição está mal formado.
