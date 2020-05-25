# HTTP Protocol (version 1) <br> Message Templates Microservice

MessageTemplates microservice implements a HTTP compatible API, that can be accessed on configured port.
All input and output data is serialized in JSON format. Errors are returned in [standard format]().

* [MessageTemplateV1 class](#class1)
* [POST /message_templates/get_templates](#operation1)
* [POST /message_templates/get_template_by_id](#operation2)
* [POST /message_templates/get_template_by_id_or_name](#operation3)
* [POST /message_templates/create_template](#operation4)
* [POST /message_templates/update_template](#operation5)
* [POST /message_templates/delete_template_id](#operation6)

## Data types

### <a name="class1"></a> MessageTemplateV1 class

Represents an message template

**Properties:**
- id: string - unique template id
- name: string - template name
- from: string - sender address
- reply_to: string - sender replyto address
- subject: MultiString - message subject in different languages
- text: MultiString - message text body in different languages
- html: MultiString - message html body in different languages
- status: string - editing status of the msgtemplate: 'new', 'writing', 'translating', 'completed' (default: 'new')

## Operations

### <a name="operation1"></a> Method: 'POST', route '/message\_templates/get_templates'

Retrieves a collection of message templates according to specified criteria

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- filter: Object
  - name: string - (optional) template name
  - status: string - (optional) template editing status
  - search: string - (optional) free text search
- paging: Object
  - skip: int - (optional) start of page (default: 0). Operation returns paged result
  - take: int - (optional) page length (max: 100). Operation returns paged result

**Response body:**
DataPage<MessageTemplateV1> object is paging was requested or error

### <a name="operation2"></a> Method: 'POST', route '/message\_templates/get\_template\_by_id'

Retrieves a single message template specified by its unique id

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- template_id: string - unique message template id

**Response body:**
MessageTemplateV1 object, null if object wasn't found or error 

### <a name="operation3"></a> Method: 'POST', route '/message\_templates/get\_template\_by_id\_or\_name'

Retrieves first found message template specified by its unique id or name

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- id\_or\_name: string - template id or name

**Response body:**
MessageTemplateV1 object, null if object wasn't found or error 

### <a name="operation4"></a> Method: 'POST', route '/message\_templates/create_template'

Creates a new message template

**Request body:**
- correlation_id: string - (optional) unique id that identifies distributed transaction
- template: MessageTemplateV1 - MessageTemplate object to be created. If object id is not defined it is assigned automatically.

**Response body:**
Created MessageTemplateV1 object or error

### <a name="operation5"></a> Method: 'POST', route '/message_templates/update\_template'

Updates message template specified by its unique id

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- template: MessageTemplateV1 - MessageTemplate object with new values.

**Response body:**
Updated MessageTemplateV1 object or error 
 
### <a name="operation6"></a> Method: 'POST', route '/message\_templates/delete\_template\_by_id'

Deletes message template specified by its unique id

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- template_id: string - unique message template id

**Response body:**
Occured error or null for success
 
