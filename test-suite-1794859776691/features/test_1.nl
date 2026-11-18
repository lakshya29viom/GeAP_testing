# composer-id: 22d01eaf-68f6-49ec-b585-9d44a2b71445
# test-data: 3c7977d8-28e8-4847-a0e4-d478d2198e40
@regression_
Feature: GeAP Platform Governance, Tenancy, and Document Lifecycle Automation

  @smoke_

Scenario: Platform Admin verifies initial portal state and default registrations view
    And wait for "Platform Admin"
    And click "Registrations"
    And wait for "Registrations"
    And check that screen contains "Approve or reject SUBMITTED auctioneer enrollments. This does not by itself make a bidder bid-ready." with exact phrase
    And check that screen contains "All" with exact phrase
    And check that screen contains "Submitted" with exact phrase
    And check that screen contains "Approved" with exact phrase
    And check that screen contains "Rejected" with exact phrase
    And check that screen contains "Auctioneer enrollments" with exact phrase
    And check that screen contains "No registrations in this view." with exact phrase

Scenario: Platform Admin navigates to auctions catalog
    And wait for "Platform Admin"
    And click "Auctions"
    And wait for "Auctions"
    And check that screen contains "System-generated auctions from approved requests. Configure the rulebook, then validate for auctioneer confirmation." with exact phrase
    And check that screen contains "Configured auctions" with exact phrase
    And check that screen contains "Create from an approved request on the review detail screen." with exact phrase
    And check that screen contains "No auctions yet." with exact phrase

Scenario: Platform Admin reviews auction request draft details
    And wait for "Review inbox"
    And click "Auction_1"
    And wait for "Auction_1"
    And check that screen contains "Auction_1" with exact phrase
    And check that screen contains "Draft" with exact phrase
    And check that screen contains "· version 1" with exact phrase
    And check that screen contains "Not yet submitted for review." with exact phrase
    And read value from field on the below of "TITLE" and save it as "titleValue" with exact phrase
    And check that variable {titleValue} contains "Auction_1" with exact phrase
    And read value from field on the below of "AUCTION TYPE" and save it as "auctionTypeValue" with exact phrase
    And check that variable {auctionTypeValue} contains "FORWARD" with exact phrase
    And read value from field on the below of "CREATED BY" and save it as "createdByValue" with exact phrase
    And check that variable {createdByValue} contains "local-dev" with exact phrase
    And check that screen contains "4 document roles are missing" with exact phrase
    And check that screen contains "1 lot is not ready" with exact phrase

Scenario: Auctioneer selects local tenant and loads tenant context
    And wait for "Auctioneer Portal"
    And click "Home"
    And wait for "Home"
    And check that screen contains "Select a local auctioneer tenant and verify tenancy context." with exact phrase
    And select "local-auctioneer-1" from list "Local auctioneer tenant"
    And click "Load tenant context"
#    check that screen contains "\"deploymentId\": \"local-auctioneer-1\"" with exact phrase
#   check that screen contains "\"auctioneerId\": \"auctioneer-local-1\"" with exact phrase
#   check that screen contains "\"gatewayOrigin\": \"http://localhost:9009\"" with exact phrase

Scenario: Auctioneer verifies organization identity profile
    And wait for "Auctioneer Portal"
    And click "Organization"
    And wait for "Organization"
    And check that screen contains "Organization identity" with exact phrase
    And read value from field on the right of "Legal name" and save it as "legalNameValue" with exact phrase
    And check that variable {legalNameValue} contains "lakshya" with exact phrase
    And read value from field on the right of "Display name" and save it as "displayNameValue" with exact phrase
    And check that variable {displayNameValue} contains "la" with exact phrase
    And read value from field on the right of "Status" and save it as "statusValue" with exact phrase
    And check that variable {statusValue} contains "DRAFT" with exact phrase
    And read value from field on the right of "Authorized user" and save it as "authorizedUserValue" with exact phrase
    And check that variable {authorizedUserValue} contains "local-dev" with exact phrase
    And read value from field on the right of "Auctioneer ID" and save it as "auctioneerIdValue" with exact phrase
    And check that variable {auctioneerIdValue} contains "auctioneer-local-1" with exact phrase
    And check that screen contains "Primary business contact" with exact phrase
    And read value from field on the right of "Email" and save it as "emailValue" with exact phrase
    And check that variable {emailValue} contains "lakshya.ahuja@viom.tech" with exact phrase

Scenario: Auctioneer views governed auction requests list
    And wait for "Auctioneer Portal"
    And click "Auction requests"
    And wait for "Auction requests"
    And check that screen contains "Create and submit governed auction requests for Platform Admin review." with exact phrase
    And check that button "New request" is enabled
    And check that screen contains "All" with exact phrase
    And check that screen contains "Draft" with exact phrase
    And check that screen contains "Submitted" with exact phrase
    And check that screen contains "Clarification required" with exact phrase
    And check that screen contains "Resubmitted" with exact phrase
    And check that screen contains "Approved" with exact phrase
    And check that screen contains "Rejected" with exact phrase
    And check that screen contains "Withdrawn" with exact phrase
    And check that screen contains "Auction_1" with exact phrase
    And check that screen contains "Draft" with exact phrase
    And check that screen contains "FORWARD" with exact phrase

Scenario: Auctioneer opens new auction request modal and inspects mandatory controls
    And wait for "Auction requests"
    And click "+ New request"
    And wait for "New auction request"
    And check that screen contains "Capture the request the Platform Admin will review before configuring the auction." with exact phrase
    And check that screen contains "Title *" with exact phrase
    And check that screen contains "Description *" with exact phrase
    And check that screen contains "Auction type *" with exact phrase
    And check that screen contains "FORWARD" with exact phrase
    And check that screen contains "Notes" with exact phrase
    And check that button "Cancel" is enabled
    And check that button "Save" is enabled

Scenario: Auctioneer navigates to confirmed auctions catalog
    And wait for "Auctioneer Portal"
    And click "Auctions"
    And wait for "Auctions"
    And check that screen contains "Review Platform Admin configuration and confirm the exact rulebook version." with exact phrase
    And check that screen contains "Your auctions" with exact phrase
    And check that screen contains "Auction IDs are system-generated when Admin creates the auction from an approved request." with exact phrase
    And check that screen contains "No auctions yet." with exact phrase

Scenario: Core system accesses Document Service using short-lived purpose-bound reference
    And wait for "{anchor.authenticated_core_system_screen}"
    And compose a post request to "{documentServiceBaseUrl}/access-reference" with headers
      | Authorization | {authToken}      |
      | Content-Type  | application/json |
    And with the below JSON request
      """
      {
        "documentId": "DOC-9821",
        "purpose": "AUCTION_VERIFICATION"
      }
      """
    And get current date time in format "yyyy-MM-dd HH:mm:ss" and save as "requestStartTime"
    And execute and save the response as "accessReferenceResponse"
    And get current date time in format "yyyy-MM-dd HH:mm:ss" and save as "requestEndTime"
    And check that response {accessReferenceResponse} has "200" as status code
    And extract value from API response {accessReferenceResponse} at "$.referenceToken" and save it as "referenceToken"
    And extract value from API response {accessReferenceResponse} at "$.validitySeconds" and save it as "validitySeconds"
    And check that variable {validitySeconds} is equals to "2"
    And check that API response {accessReferenceResponse} contains "AUCTION_VERIFICATION" at "$.purposeBinding"
    And extract value from API response {accessReferenceResponse} at "$.expirationTimestamp" and save it as "expirationTimestamp"
    And check that screen contains "{expirationTimestamp}" with exact phrase
    And calculate difference between "{requestStartTime}" and "{requestEndTime}" in "days" and save as "responseDuration"
    And check that variable {responseDuration} is numerically less than "2"

Scenario: Core system denied access when document reference expires
    And wait for "{anchor.document_service_screen}"
    And enter "DOC-9821" into "{anchor.document_reference_field}"
    And enter "2" into "{anchor.reference_lifetime_field}"
    And click "{anchor.generate_reference_button}"
    And wait for "{anchor.reference_generated_confirmation}"
    And wait 3 sec
    And click "{anchor.request_document_button}"
    And check that screen contains "Document reference has expired" with exact phrase
    And check that screen contains "{anchor.expired_access_log_entry}" with exact phrase

Scenario: Core system denied access with mismatched purpose-binding attributes
    And wait for "DOC-9821"
    And enter "DOC-9821" into "Document Reference"
    And enter "AUCTION_VERIFICATION" into "Purpose"
    And enter "PUBLIC_BIDDER_VIEW" into "Purpose"
    And click "Retrieve"
    And check that screen contains "Access denied: purpose-binding attribute mismatch" with exact phrase

Scenario: Core system prevented from reusing single-use document reference
    And check that screen contains "DOC-9821" with exact phrase
    And check that screen contains "{anchor.redeemed_status}" with exact phrase
    And click "Redeem" with exact phrase
    And check that screen contains "access denied" with exact phrase
    And check that screen contains "invalid access attempt" with exact phrase

Scenario: Schema identifiers generated consistently as valid UUIDs
    And wait for "{anchor.metadata_registry_screen}"
    And check that screen contains "{anchor.schema_registered_confirmation}" with exact phrase
    And read value from field on the right of "{anchor.schema_identifier_label}" and save it as "schemaId"
    And extract substring from "schemaId" using the pattern "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}" and save it as "uuidMatch"
    And check that variable {uuidMatch} contains "{schemaId}" with exact phrase
    And click "{anchor.administrative_interface_query}"
    And wait for "{anchor.admin_query_results_screen}"
    And read value from field on the right of "{anchor.schema_identifier_label}" and save it as "adminSchemaId"
    And check that variable {adminSchemaId} contains "{uuidMatch}" with exact phrase
    And check that screen contains "{anchor.uuid_formatted_display}" with exact phrase
    And check that screen contains "{anchor.screen_reader_uuid_announcement}" with exact phrase

Scenario: Duplicate UUID rejected during schema creation
    And check that screen contains "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d" with exact phrase
    And click "Create Schema"
    And wait for "UUID"
    And enter "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d" into "UUID"
    And click "Submit"
    And check that screen contains "Duplicate identifier: UUID conflict detected" with exact phrase

Scenario: Ensure single logical outcome for rapid concurrent document finalization events
    And wait for "DOC-4401"
    And check that screen contains "Draft" with exact phrase
    And click "Finalize"
    And wait for "Finalized"
    And check that "Finalized" appears 1 time on screen with exact phrase
    And check that screen contains "Finalized" with exact phrase
    And check that "Finalized" foreground color is "green" with exact phrase

Scenario: Reject redundant finalization attempt on already finalized document
    And wait for "DOC-4401"
    And check that screen contains "Finalized" with exact phrase
    And click "Finalize"
    And check that screen contains "Document is already finalized" with exact phrase

Scenario: Prevent file upload using expired signed upload URL
    And compose a post request to "{expiredUploadUrl}" with headers
      | Content-Type | application/octet-stream |
    And with the below JSON request
      """
      {fileBinary}
      """
    And execute and save the response as "uploadResponse"
    And check that response {uploadResponse} has "403" as status code
    And extract value from API response {uploadResponse} at "$.message" and save it as "responseMessage"
    And check that variable {responseMessage} contains "URL Expired" with exact phrase
    And compose a get request to "{auditLogUrl}" with headers
      | Content-Type | application/json |
    And execute and save the response as "auditLogResponse"
    And check that API response {auditLogResponse} contains "URL Expired" at "$.reason"

Scenario: Successful file upload using valid signed upload URL before expiration
    And upload file "doc-valid.pdf" to "{el:signedUploadTarget}"
    And check that response {uploadResponse} has "200" as status code
    And check that screen contains "quarantine" with exact phrase

Scenario: System handles upload interruption by aborting multipart and quarantining parts
    And wait for "Upload"
    And upload file "tender-spec.pdf" to "Upload"
    And wait for "{anchor.multipart_upload_initiated_confirmation}"
    And check that screen contains "tender-spec.pdf" with exact phrase
    And wait for "{anchor.upload_interrupted_or_retry_status}"
    And check that screen contains "{anchor.multipart_abort_triggered_message}" with exact phrase
    And check that screen contains "{anchor.quarantined_bucket_confirmation}" with exact phrase
    And check that screen contains "tender-spec.pdf" with exact phrase
    And check that screen contains "{anchor.abort_reason_in_audit_log}" with exact phrase

Scenario: Finalize document upload with object and server-side checksum verification
    And compose a post request to "{baseUrl}/documents/upload-intents/intent-12345/complete" with headers
      | Content-Type | application/json |
    And execute and save the response as "completeUploadResponse"
    And check that response {completeUploadResponse} has "200" as status code
    And check that API response {completeUploadResponse} contains "finalized" at "$.status"
    And extract value from API response {completeUploadResponse} at "$.transactionId" and save it as "transactionId"
    And check that variable {transactionId} is not equals to "" with exact phrase

Scenario: Reject upload finalization when checksum verification fails
    And compose a post request to "{baseUrl}/documents/upload-intents/intent-corrupted/complete" with headers
      | Content-Type | application/json |
      | Authorization | Bearer {authToken} |
    And with the below JSON request
      """
      {
        "uploadIntentId": "intent-corrupted",
        "checksum": "{corruptedChecksum}"
      }
      """
    And execute and save the response as "finalizeResponse"
    And check that response {finalizeResponse} has "400" as status code
    And check that API response {finalizeResponse} contains "Checksum mismatch detected" at "$.message"

Scenario: Download document using short-lived signed download URL after access verification
    And wait for "Document Details"
    And check that screen contains "DOC-7711" with exact phrase
    And click "Download document"
    And wait for "{anchor.signed_download_url_ready}"
    And wait 2 sec
    And check that screen contains "{anchor.download_success_confirmation}" with exact phrase
    And check that screen contains "{anchor.audit_log_confirmation}" with exact phrase

Scenario: Deny document download access from unauthorized IP address
    And compose a get request to "{signedDownloadUrl}" with headers
      | X-Forwarded-For | 10.0.0.99 |
    And execute and save the response as "downloadResponse"
    And check that response {downloadResponse} has "403" as status code
    And check that screen contains "Forbidden" with exact phrase
    And compose a get request to "{auditLogUrl}" with headers
      | Authorization | {auditAuthToken} |
    And execute and save the response as "auditLogResponse"
    And check that API response {auditLogResponse} contains "unauthorized IP access" at "$.events[0].type"
    And check that API response {auditLogResponse} contains "10.0.0.99" at "$.events[0].sourceIp"
    And check that API response {auditLogResponse} contains "DOC-7711" at "$.events[0].documentId"

Scenario: Ensure uniqueness of quarantine_key in database upload_intent table
    And connect to the database "geap_db" using the following credentials and save it as "dbConn"
      | host     | {db_host}     |
      | port     | {db_port}     |
      | username | {db_username} |
      | password | {db_password} |
    And execute the query "INSERT INTO upload_intent (quarantine_key) VALUES ('qk-tenant1-lot10-v1')" using "dbConn" and save the results as "firstInsertResult"
    And execute the query "INSERT INTO upload_intent (quarantine_key) VALUES ('qk-tenant1-lot10-v1')" using "dbConn" and save the results as "duplicateInsertResult"
    And check (rowCount Equals 0) in "duplicateInsertResult"
    And execute the query "SELECT COUNT(*) as cnt FROM upload_intent WHERE quarantine_key = 'qk-tenant1-lot10-v1'" using "dbConn" and save the results as "countResult"
    And read "cnt" from row 1 of "countResult" and save it as "recordCount"
    And check that variable {recordCount} is equals to "1"
    And disconnect the database connection "dbConn"

Scenario: Enforce data integrity constraints on document_version database table
    And connect to the database "geap" using the following credentials and save it as "dbConn"
      | host     | {db_host}     |
      | port     | {db_port}     |
      | username | {db_username} |
      | password | {db_password} |
#    execute the query "INSERT INTO document_version (version_no, sha256) VALUES (-1, '{"a" * 64}')" using "dbConn" and save the results as "insertResult1" and continue
#    check that screen contains "check constraint" with exact phrase
#    execute the query "INSERT INTO document_version (version_no, sha256) VALUES (1, '{"b" * 32}')" using "dbConn" and save the results as "insertResult2" and continue
    And check that screen contains "field length constraint" with exact phrase
    And disconnect the database connection "dbConn"

Scenario: Generate short-lived upload URL restricted to envelope size and single key
    And wait for "{anchor.documentServiceScreen}"
    And compose a post request to "{uploadUrlEndpoint}" with headers
      | Authorization | {authToken}       |
      | Content-Type  | application/json  |
    And with the below JSON request
      """
      {
        "key": "docs/spec.pdf",
        "maxSize": 10485760
      }
      """
    And execute and save the response as "uploadUrlResponse"
    And check that response {uploadUrlResponse} has "200" as status code
    And extract value from API response {uploadUrlResponse} at "$.url" and save it as "generatedUrl"
    And check that variable {generatedUrl} contains "https://" with exact phrase
    And extract value from API response {uploadUrlResponse} at "$.policy.key" and save it as "policyKey"
    And check that variable {policyKey} contains "docs/spec.pdf" with exact phrase
    And extract value from API response {uploadUrlResponse} at "$.policy.maxSize" and save it as "policyMaxSize"
    And check that variable {policyMaxSize} is equals to "10485760"

Scenario: Reject upload URL generation when object key is missing
    And compose a post request to "{uploadUrlEndpoint}" with headers
      | Content-Type | application/json |
      | Authorization | Bearer {authToken} |
    And with the below JSON request
      """
      {}
      """
    And execute and save the response as "uploadUrlResponse"
    And check that response {uploadUrlResponse} has "400" as status code
    And check that API response {uploadUrlResponse} contains "Object key is required" at "$.message"

Scenario: Access opaque object reference with recipient and purpose binding
    And wait for "{anchor.opaque_reference_screen}"
    And check that screen contains "officer-42" with exact phrase
    And check that screen contains "LOT_AUDIT" with exact phrase
    And enter "officer-42" into "Recipient"
    And click "Retrieve"
    And wait for "{anchor.document_access_screen}"
    And check that screen contains "officer-42" with exact phrase
    And check that screen contains "LOT_AUDIT" with exact phrase
    And check that screen contains "{anchor.access_granted_message}" with exact phrase
    And check that screen does not contain "gs://" with exact phrase
    And check that screen does not contain "s3://" with exact phrase
    And check that screen does not contain "storage.googleapis.com" with exact phrase
    And check that screen does not contain "amazonaws.com" with exact phrase

Scenario: Reject opaque object reference access by unauthorized recipient
    And wait for "officer-42"
    And compose a get request to "{opaqueObjectReference}" with headers
      | Authorization | Bearer {bidder99Token} |
    And execute and save the response as "accessResponse"
    And check that response {accessResponse} has "403" as status code
    And check that screen contains "403 Forbidden" with exact phrase
    And check that API response {accessResponse} contains "bidder-99" at "$.audit.recipientId"

Scenario: System computes independent server-side digest ignoring browser sha
    And compose a post request to "{uploadIntentUrl}" with headers
      | Content-Type        | application/json |
    And with the below JSON request
      """
      {
        "fileName": "evidence-report.pdf"
      }
      """
    And execute and save the response as "uploadIntentResponse"
    And check that response {uploadIntentResponse} has "200" as status code
    And compose a post request to "{uploadUrl}" with headers
      | X-File-SHA256 | invalid-hash |
      | Content-Type  | application/octet-stream |
    And execute and save the response as "uploadResponse"
    And check that response {uploadResponse} has "200" as status code
    And extract value from API response {uploadResponse} at "$.digest.algorithm" and save it as "digestAlgorithm"
    And check that variable {digestAlgorithm} contains "SHA-256" with exact phrase
    And extract value from API response {uploadResponse} at "$.digest.value" and save it as "serverDigest"
    And check that variable {serverDigest} is not equals to "invalid-hash" with exact phrase
    And extract value from API response {uploadResponse} at "$.documentVersion.digest" and save it as "storedDigest"
    And check that variable {storedDigest} contains "{serverDigest}" with exact phrase
    And extract value from API response {uploadResponse} at "$.browserHash" and save it as "browserHashStored"
    And check that variable {browserHashStored} is not equals to "invalid-hash" with exact phrase

Scenario: Document processing pipeline extracts metadata and performs OCR
    And wait for "quarantine"
    And check that screen contains "scanned-contract.png" with exact phrase
    And click "Process"
    And wait for "Processing complete"
    And check that screen contains "Apache Tika" with exact phrase
    And check that screen contains "file metadata" with exact phrase
    And check that screen contains "embedded attributes" with exact phrase
    And check that screen contains "Tesseract" with exact phrase
    And check that screen contains "optical character recognition" with exact phrase
    And check that screen contains "extracted text" with exact phrase
    And check that screen contains "scanned-contract.png" with exact phrase

Scenario: Document processing pipeline skips corrupted files gracefully
    And wait for "Upload"
    And upload file "corrupted-file.pdf" to "Upload"
    And wait for "processing"
    And check that screen contains "Document content corrupted" with exact phrase
    And check that screen contains "REJECTED" with exact phrase
    And check that screen does not contain "OCR" with exact phrase

Scenario: Evidence capture process executes asynchronously for unverified documents
    And compose a post request to "{evidenceCaptureUrl}" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {
        "requiresImmediateVerification": false,
        "requestType": "evidence_capture"
      }
      """
    And execute and save the response as "captureResponse"
    And check that response {captureResponse} has "202" as status code
    And extract value from API response {captureResponse} at "$.status" and save it as "captureStatus"
    And check that variable {captureStatus} contains "Accepted" with exact phrase
    And extract value from API response {captureResponse} at "$.processingMode" and save it as "processingMode"
    And check that variable {processingMode} contains "async" with exact phrase
    And extract value from API response {captureResponse} at "$.completionTimestamp" and save it as "completionTimestamp"
    And check that variable {completionTimestamp} is not equals to "" with exact phrase
    And extract value from API response {captureResponse} at "$.executionAudit" and save it as "executionAudit"
    And check that variable {executionAudit} is not equals to "" with exact phrase

Scenario: Evidence capture process waits synchronously when verification is required
    And wait for "Evidence Capture"
    And compose a post request to "{evidenceCaptureUrl}" with headers
    And with the below JSON request
      """
      {
        "verificationRequired": true,
        "synchronous": true
      }
      """
    And execute and save the response as "captureResponse"
    And check that response {captureResponse} has "200" as status code
    And check that API response {captureResponse} contains "verified" at "$.status"

Scenario: Segregate database and object stores for auctioneer environments
    And connect to the database "auctioneer-local-1" using the following credentials and save it as "dbConn1"
      | host     | {db1Host}     |
      | port     | {db1Port}     |
      | username | {db1Username} |
      | password | {db1Password} |
      | database | {db1Name}     |
    And execute the query "SELECT * FROM information_schema.tables WHERE table_schema = 'auctioneer-local-1'" using "dbConn1" and save the results as "tenant1Results" and continue
    And check (rowCount GreaterThan 0) in "tenant1Results"
    And execute the query "SELECT * FROM information_schema.tables WHERE table_schema = 'auctioneer-local-2'" using "dbConn1" and save the results as "crossTenantResults" and continue
    And check (rowCount Equals 0) in "crossTenantResults"
    And disconnect the database connection "dbConn1"
    And wait for "Database Isolation"
    And check that screen contains "auctioneer-local-1" with exact phrase
    And check that screen contains "Isolated" with exact phrase
    And check that screen does not contain "auctioneer-local-2" with exact phrase

Scenario: System prevents silent replacement of existing evidence
    And check that screen contains "EV-501" with exact phrase
    And click on the element to the right of "EV-501"
    And wait for "Replace Evidence"
    And check that screen contains "Replace Evidence: This action will replace existing evidence. Confirm to proceed." with exact phrase
    And click "Cancel"
    And check that screen contains "EV-501" with exact phrase
    And check that screen does not contain "Replacement performed" with exact phrase

Scenario: Confirm replacement of evidence logs full audit trail
    And wait for "EV-501"
    And upload file "{newEvidenceFile}" to "Choose File"
    And click "Confirm Replace"
    And wait for "{anchor.replacementConfirmationMessage}"
    And check that screen contains "EV-501" with exact phrase
    And check that screen contains "{operatorUserId}" with exact phrase
    And check that screen contains "{oldFileHash}" with exact phrase
    And check that screen contains "{newFileHash}" with exact phrase
    And check that screen contains "{replacementTimestamp}" with exact phrase

Scenario: Prevent overwriting of existing evidentiary document versions
    And compose a put request to "{documentServiceBaseUrl}/documents/{documentId}/versions/v1" with headers
      | Content-Type  | application/octet-stream |
      | Authorization | {authToken}              |
    And with the below JSON request
      """
      {
        "checksum": "sha256-xyz999",
        "content": "{newBinaryContent}"
      }
      """
    And execute and save the response as "overwriteResponse"
    And check that response {overwriteResponse} has "409" as status code
    And check that screen contains "409 Conflict" with exact phrase
    And compose a get request to "{documentServiceBaseUrl}/documents/{documentId}/versions/v1" with headers
      | Authorization | {authToken} |
    And execute and save the response as "getVersionResponse"
    And check that API response {getVersionResponse} contains "sha256-abc123" at "$.checksum"

Scenario: Prevent usage of unscanned content across workflows
    And wait for "{anchor.document_scan_status_screen}"
    And check that screen contains "local_unscanned" with exact phrase
    And click "{anchor.auction_lot_publication_action}"
    And check that screen contains "Document has not passed security scan" with exact phrase
    And check that button "{anchor.publication_action_button}" is disabled

Scenario: Malware scan detects infected file and rejects upload
    And upload file "{malwareTestFile}" to "Choose File"
    And wait for "INFECTED"
    And check that screen contains "INFECTED" with exact phrase
    And check that screen contains "File failed security scan: malicious pattern detected" with exact phrase

Scenario: Inspect file MIME and content types to detect extension spoofing
    And upload file "statement.pdf" to "Choose File"
    And wait for "quarantine"
    And check that screen contains "application/x-executable" with exact phrase
    And check that screen contains "File content does not match declared MIME type" with exact phrase

Scenario: Manage document lifecycle state transitions through defined state machine
    And check that screen contains "UPLOAD_REQUESTED" with exact phrase
    And click "Upload"
    And wait for "AVAILABLE"
    And check that screen contains "AVAILABLE" with exact phrase
    And click "Delete"
    And wait for "DELETED"
    And check that screen contains "DELETED" with exact phrase

Scenario: Reject invalid state transitions in document lifecycle
    And check that screen contains "REJECTED" with exact phrase
    And click "AVAILABLE"
    And check that screen contains "Invalid state transition from REJECTED to AVAILABLE" with exact phrase
    And check that screen contains "REJECTED" with exact phrase

Scenario: Quarantine and validate uploaded files before granting access
    And wait for "quarantine/"
    And check that screen contains "quarantine/" with exact phrase
    And check that screen does not contain "documents/" with exact phrase
    And check that screen contains "Validating file security..." with exact phrase
    And click "Validating file security..."
    And wait for "documents/"

Scenario: PostgreSQL database enforces query execution within performance SLA
    And connect to the database "PostgreSQL" using the following credentials and save it as "dbConn" and continue
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | database | {dbName}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
    And get current date time in format "yyyy-MM-dd HH:mm:ss" and save as "queryStart"
    And execute the query "SELECT al.lot_id, al.lot_number, al.description, al.reserve_price, r.request_id, r.request_type, r.status, r.created_date, r.requester_id FROM auction_lots al INNER JOIN requests r ON al.lot_id = r.lot_id INNER JOIN tenants t ON r.tenant_id = t.tenant_id INNER JOIN documents d ON r.request_id = d.request_id WHERE al.status = 'ACTIVE' GROUP BY al.lot_id, al.lot_number, al.description, al.reserve_price, r.request_id, r.request_type, r.status, r.created_date, r.requester_id ORDER BY al.lot_number" using "dbConn" and save the results as "queryResults" and continue
    And get current date time in format "yyyy-MM-dd HH:mm:ss" and save as "queryEnd"
    And check (rowCount GreaterThan 0) in "queryResults"
    And execute the query "SELECT 1" using "dbConn" and save the results as "healthCheckResult" and continue
    And check (rowCount GreaterThan 0) in "healthCheckResult"
    And disconnect the database connection "dbConn"

Scenario: Document metadata updates create incremented version history
    And wait for "DOC-102"
    And check that screen contains "v1" with exact phrase
    And click "Description"
    And clear text from "Description"
    And enter "Updated auction lot terms" into "Description"
    And click "Save"
    And wait for "v2"
    And check that screen contains "v2" with exact phrase
    And check that screen contains "v1" with exact phrase
    And check that screen contains "DOC-102" with exact phrase

Scenario: Issue document upload session with unique identifier and operational validation
    And compose a post request to "{uploadSessionEndpoint}" with headers
      | Authorization | {authToken}        |
      | Content-Type  | application/json   |
      | X-Tenant-Id   | {tenantId}         |
    And with the below JSON request
      """
      {
        "documentType": "auction_pack",
        "clientId": "{clientId}"
      }
      """
    And execute and save the response as "uploadSessionResponse"
    And check that response {uploadSessionResponse} has "201" as status code
    And extract value from API response {uploadSessionResponse} at "$.sessionId" and save it as "sessionUUID"
    And check that variable {sessionUUID} contains "-" with exact phrase
    And extract value from API response {uploadSessionResponse} at "$.expiresAt" and save it as "sessionExpiry"
    And check that variable {sessionExpiry} is not equals to ""
    And extract value from API response {uploadSessionResponse} at "$.uploadEndpoint" and save it as "uploadEndpoint"
    And check that variable {uploadEndpoint} is not equals to ""

Scenario: Reject upload session request with invalid parameters
    And compose a post request to "/documents/upload-sessions" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {}
      """
    And execute and save the response as "uploadSessionResponse"
    And check that response {uploadSessionResponse} has "400" as status code
    And check that API response {uploadSessionResponse} contains "missing" at "$.error"

Scenario: Document ingestion validates authenticity and rejects unsupported encryption
    And upload file "{unsupportedEncryptedDocument}" to "Document Service"
    And click "Ingest"
    And wait for "Unsupported encryption algorithm"
    And check that screen does not contain "{unsupportedEncryptedDocument}" with exact phrase

Scenario: Comprehensive validation revalidates permissions and state on form submission
    And wait for "{anchor.auctionRequestEditForm}"
    And click "Submit"
    And wait for "{anchor.serverSideValidationResult}"
    And check that screen contains "error details" with exact phrase

Scenario: Database schema enforces UUIDs as primary keys on all tables
    And connect to the database "auctioneer" using the following credentials and save it as "dbConn"
      | key      | value        |
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
    And execute the query "INSERT INTO auction_request (title) VALUES ('test-record')" using "dbConn"
    And execute the query "SELECT id FROM auction_request WHERE title = 'test-record' ORDER BY created_at DESC LIMIT 1" using "dbConn" and save the results as "insertResult"
    And read "id" from row 1 of "insertResult" and save it as "generatedId"
    And check that variable {generatedId} contains "-" with exact phrase
    And execute the query "SELECT id FROM auction_request WHERE id = '{generatedId}' AND id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'" using "dbConn" and save the results as "uuidValidationResult"
    And check (rowCount GreaterThan 0) in "uuidValidationResult"
    And extract substring from "{generatedId}" starting at position 1 and ending at position 36 and save it as "uuidFormatCheck"
    And check that variable {uuidFormatCheck} contains "-" with exact phrase
    And disconnect the database connection "dbConn"

Scenario: Dual control maker-checker prevents maker from approving own request
    And wait for "Submitted"
    And check that screen contains "user-local-dev" with exact phrase
    And click "Approve"
    And check that screen contains "Policy violation: Maker cannot approve their own request" with exact phrase
    And read value from field on the right of "Status" and save it as "requestStatus" with exact phrase
    And check that variable {requestStatus} contains "Submitted" with exact phrase

Scenario: Dual control maker-checker allows different checker to approve request
    And wait for "Submitted"
    And check that screen contains "user-local-dev" with exact phrase
    And click "Approve"
    And wait for "Approved"
    And read value from field on the right of "Approved By" and save it as "approvedBy" with exact phrase
    And check that variable {approvedBy} contains "officer-compliance" with exact phrase
    And check that screen contains "Approved" with exact phrase

Scenario: Deploy Engine Spring Boot skeleton independently without external dependencies
    And wait for "UP"
    And check that screen contains "UP" with exact phrase
    And compose a get request to "{baseUrl}/actuator/health" with headers
    And execute and save the response as "healthResponse"
    And check that response {healthResponse} has "200" as status code
    And check that API response {healthResponse} contains "UP" at "$.status"
    And wait for "{anchor.isolated_host_environment_configured}"

Scenario: Enforce tenant privacy and data isolation under feature verification
    And compose a get request to "{tenantQueryUrl}" with headers
      | Authorization | {invalidTenantAccessClaim} |
      | X-Tenant-ID   | auctioneer-local-1         |
    And execute and save the response as "tenantQueryResponse"
    And check that response {tenantQueryResponse} has "403" as status code
    And check that screen contains "403 Forbidden" with exact phrase
    And extract value from API response {tenantQueryResponse} at "$.audit.actorInfo" and save it as "actorInfo"
    And check that variable {actorInfo} is not equals to ""

Scenario: Control local session continuity during simulated global outage
    And wait for "{anchor.activeSessionScreen}"
    And check that screen contains "{anchor.sessionValidityIndicator}" with exact phrase
    And check that screen contains "{anchor.identityProviderOutageIndicator}" with exact phrase
    And check that screen contains "{anchor.sessionActiveConfirmation}" with exact phrase
    And check that button "{anchor.allowedActionButton}" is enabled
    And wait 900 sec
    And check that screen contains "{anchor.sessionTerminatedMessage}" with exact phrase
    And check that screen does not contain "{anchor.sessionActiveConfirmation}" with exact phrase

Scenario: Outbox persists committed messages during NATS JetStream downtime
    And connect to the database "PostgreSQL" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
      | database | {dbName}     |
    And execute the query "SELECT COUNT(*) as cnt FROM outbox WHERE status = 'PENDING'" using "dbConn" and save the results as "outboxBefore"
    And read "cnt" from row 1 of "outboxBefore" and save it as "outboxCountBefore"
    And compose a post request to "{auctionServiceUrl}/auction-requests/{auctionRequestId}" with headers
      | Content-Type  | application/json      |
      | Authorization | Bearer {authToken}    |
    And with the below JSON request
      """
      {
        "status": "UPDATED",
        "requestedBy": "{requestedBy}",
        "timestamp": "{transactionTimestamp}"
      }
      """
    And execute and save the response as "auctionUpdateResponse"
    And check that response {auctionUpdateResponse} has "200" as status code
    And execute the query "SELECT COUNT(*) as cnt FROM outbox WHERE status = 'PENDING'" using "dbConn" and save the results as "outboxAfter"
    And read "cnt" from row 1 of "outboxAfter" and save it as "outboxCountAfter"
    And check that variable {outboxCountAfter} is numerically greater than "0"
    And execute the query "SELECT payload, status FROM outbox ORDER BY created_at DESC LIMIT 1" using "dbConn" and save the results as "outboxLatestRow"
    And read "status" from row 1 of "outboxLatestRow" and save it as "latestOutboxStatus"
    And check that variable {latestOutboxStatus} contains "PENDING" with exact phrase
    And read "payload" from row 1 of "outboxLatestRow" and save it as "latestOutboxPayload"
    And check that variable {latestOutboxPayload} contains "{auctionRequestId}" with exact phrase
    And disconnect the database connection "dbConn"

Scenario: Outbox publisher replays stored messages when NATS JetStream recovers
    And connect to the database "geap" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
    And execute the query "SELECT COUNT(*) as pending_count FROM outbox WHERE published = false" using "dbConn" and save the results as "pendingOutbox"
    And read "pending_count" from row 1 of "pendingOutbox" and save it as "pendingCount"
    And check that variable {pendingCount} is numerically greater than "0"
    And execute the query "UPDATE nats_broker_status SET status = 'online' WHERE broker_name = 'jetstream'" using "dbConn"
    And wait for "NATS JetStream"
    And check that screen contains "online" with exact phrase
    And execute the query "SELECT COUNT(*) as published_count FROM outbox WHERE published = true" using "dbConn" and save the results as "publishedOutbox"
    And read "published_count" from row 1 of "publishedOutbox" and save it as "publishedCount"
    And check that variable {publishedCount} is numerically greater than "0"
    And execute the query "SELECT COUNT(*) as duplicate_count FROM outbox WHERE published = true GROUP BY correlation_key HAVING COUNT(*) > 1" using "dbConn" and save the results as "duplicateCheck"
    And check (rowCount Equals 0) in "duplicateCheck"
    And execute the query "SELECT COUNT(*) as unpublished_count FROM outbox WHERE published = false" using "dbConn" and save the results as "unpublishedOutbox"
    And read "unpublished_count" from row 1 of "unpublishedOutbox" and save it as "unpublishedCount"
    And check that variable {unpublishedCount} is equals to "0"
    And disconnect the database connection "dbConn"

Scenario: Maker-checker accountability enforces distinct human reviewer and approver for AI proposal
    And wait for "Auction_1"
    And check that screen contains "AI-generated" with exact phrase
    And check that screen contains "Auction_1" with exact phrase
    And enter "reviewer-jane" into "Reviewer"
    And click "Sign Off"
    And wait for "Pending Final Approval"
    And check that screen contains "Pending Final Approval" with exact phrase
    And enter "approver-bob" into "Approver"
    And click "Approve"
    And wait for "Audit Trail"
    And check that screen contains "reviewer-jane" with exact phrase
    And check that screen contains "approver-bob" with exact phrase

Scenario: Enforce deny-by-default on unlisted resource server endpoints
    And compose a get request to "/api/v1/internal/diagnostics" with headers
      | Authorization |  |
    And execute and save the response as "diagResponse"
    And check that response {diagResponse} has "401" as status code
    And check that screen contains "401" with exact phrase

Scenario: Bind local action execution to authenticated caller deployment identifier
    And wait for "{anchor.authenticated_session_screen}"
    And compose a post request to "/api/v1/local/actions/execute" with headers
      | Authorization | {authToken} |
      | Content-Type  | application/json |
    And with the below JSON request
      """
      {
        "deploymentId": "local-auctioneer-2"
      }
      """
    And execute and save the response as "actionResponse"
    And check that response {actionResponse} has "403" as status code
    And check that API response {actionResponse} contains "cross-deployment" at "$.error"

Scenario: Mint short-lived local Bearer token for local development hygiene
    And wait for "{anchor.developer_utility_screen}"
    And check that screen contains "GEAP_JWT_HMAC_SECRET" with exact phrase
    And click "{anchor.mint_token_button}"
    And wait for "{anchor.token_result_screen}"
    And check that screen contains "{anchor.expiration_claim}" with exact phrase
    And check that screen contains "{anchor.token_accepted_confirmation}" with exact phrase

Scenario: Simulate role and tenant claims during local functional testing
    And wait for "local development"
    And compose a get request to "{localEndpointUrl}" with headers
      | Authorization | Bearer {simulatedToken} |
      | X-Tenant-Id   | auctioneer-local-1      |
      | X-Role        | AUCTIONEER_OFFICER      |
    And execute and save the response as "authResponse"
    And check that response {authResponse} has "200" as status code
    And check that screen contains "auctioneer-local-1" with exact phrase

Scenario: Reject simulated role and tenant claims in non-local environments
    And check that screen contains "production" with exact phrase
    And compose a get request to "{protectedTenantResourceUrl}" with headers
      | X-Simulated-Tenant | auctioneer-local-1 |
    And execute and save the response as "simulatedHeaderResponse"
    And check that response {simulatedHeaderResponse} has "403" as status code
    And check that screen does not contain "auctioneer-local-1" with exact phrase

Scenario: Provide predefined development personas for local role separation
    And wait for "{anchor.dev_environment_ready}"
    And wait for "{anchor.bidder_persona_home}"
    And check that screen contains "{anchor.bidder_capability_indicator}" with exact phrase
    And compose a get request to "/api/v1/platform/registrations" with headers
      | Authorization | {bidderAuthToken} |
    And execute and save the response as "adminEndpointResponse"
    And check that response {adminEndpointResponse} has "403" as status code

Scenario: Enforce local session expiry and immediate access revocation
    And wait for "{anchor.session_active_indicator}"
    And check that screen contains "local-dev" with exact phrase
    And compose a post request to "{revokeSessionUrl}" with headers
      | Authorization | Bearer {adminToken} |
      | Content-Type  | application/json    |
    And with the below JSON request
      """
      {
        "username": "local-dev"
      }
      """
    And execute and save the response as "revokeResponse"
    And check that response {revokeResponse} has "200" as status code
    And compose a get request to "{protectedResourceUrl}" with headers
      | Authorization | Bearer {localDevToken} |
    And execute and save the response as "postRevokeResponse"
    And check that response {postRevokeResponse} has "401" as status code
    And check that API response {postRevokeResponse} contains "Unauthorized" at "$.error"
    And check that screen contains "re-authenticate" with exact phrase

Scenario: Switch bidder to auctioneer context cleanly without route leakage
    And wait for "{anchor.bidder_portal_heading}"
    And check that screen contains "{anchor.bidder_portal_heading}" with exact phrase
    And click "{anchor.context_switcher_control}"
    And click "{anchor.auctioneer_officer_context_option}"
    And wait for "{anchor.auctioneer_portal_heading}"
    And check that screen contains "{anchor.auctioneer_edge_capabilities_route}" with exact phrase
    And check that screen does not contain "{anchor.bidder_session_data_indicator}" with exact phrase

Scenario: Select local auctioneer tenant and resolve downstream context
    And wait for "Auctioneer Portal"
    And check that screen contains "Home" with exact phrase
    And select "local-auctioneer-1" from list "Local auctioneer tenant"
    And click "Load tenant context"
    And wait for "deploymentId"
    And read value from field on the right of "deploymentId" and save it as "deploymentIdValue" with exact phrase
    And check that variable {deploymentIdValue} contains "local-auctioneer-1" with exact phrase
    And read value from field on the right of "auctioneerId" and save it as "auctioneerIdValue" with exact phrase
    And check that variable {auctioneerIdValue} contains "auctioneer-local-1" with exact phrase
    And click "Auction requests"
    And wait for "Auction requests"
    And check that screen contains "local-auctioneer-1" with exact phrase

Scenario: Prevent selection of unconfigured auctioneer tenant
    And enter "non-existent-auctioneer" into "Tenant"
    And click "Load"
    And check that screen contains "Tenant not found in local registry" with exact phrase
    And check that screen does not contain "non-existent-auctioneer" with exact phrase

Scenario: Apply shared codebase tenant policy defaults without code branching
    And wait for "auctioneer-local-1"
    And check that screen contains "auctioneer-local-1" with exact phrase
    And check that screen contains "rulebook" with exact phrase
    And check that screen contains "auctioneer-local-1" with exact phrase

Scenario: Retrieve document metadata and version history via API
    And compose a get request to "https://api.example.com/documents/DOC-3320" with headers
      | Authorization | Bearer {authToken} |
    And execute and save the response as "docResponse"
    And check that response {docResponse} has "200" as status code
    And check that API response {docResponse} contains "documentName" at "$.documentName"
    And check that API response {docResponse} contains "author" at "$.author"
    And check that API response {docResponse} contains "dateCreated" at "$.dateCreated"
    And extract value from API response {docResponse} at "$.versions" and save it as "versionsList"
    And check that variable {versionsList} contains "" with exact phrase

Scenario: Deny document metadata access for unauthorized caller
    And compose a get request to "/documents/DOC-3320" with headers
      | Authorization | {unauthorizedUserToken} |
    And execute and save the response as "docMetadataResponse"
    And check that response {docMetadataResponse} has "403" as status code
    And check that API response {docMetadataResponse} contains "" at "$.data"

Scenario: Out-of-order receipt processing records contradiction and preserves monotonic state
    And wait for "105"
    And check that screen contains "102" with exact phrase
    And check that screen contains "contradiction" with exact phrase
    And check that screen contains "105" with exact phrase

Scenario: System applies bounded backoff when external provider returns HTTP 429
    And check that screen contains "outbound integration request" with exact phrase
    And check that screen contains "429" with exact phrase
    And check that screen contains "Retry-After" with exact phrase
    And wait 5 sec
    And check that screen contains "retry" with exact phrase
    And check that screen contains "30" with exact phrase

Scenario: Implement retry logic for transient network errors with exponential backoff
    And check that screen contains "503 Service Unavailable" with exact phrase
    And wait for "Retry attempt 1"
    And check that screen contains "Retry attempt 1" with exact phrase
    And check that screen contains "Retry attempt 2" with exact phrase
    And check that screen contains "Retry attempt 3" with exact phrase
    And check that screen contains "timestamp" with exact phrase
    And check that screen contains "503" with exact phrase
    And check that screen contains "1 second" with exact phrase
    And check that screen contains "exponential backoff" with exact phrase
    And check that screen contains "maximum" with exact phrase
    And check that screen contains "3" with exact phrase

Scenario: Standardize database timestamps to UTC timestamptz
    And connect to the database "PostgreSQL" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
      | database | {dbName}     |
    And execute the query "INSERT INTO auction_events (event_time) VALUES ('2026-11-16 09:30:00+04')" using "dbConn"
    And execute the query "SELECT event_time FROM auction_events ORDER BY id DESC LIMIT 1" using "dbConn" and save the results as "insertResult"
    And read "event_time" from row 1 of "insertResult" and save it as "storedTimestamp"
    And check that variable {storedTimestamp} contains "2026-11-16 05:30:00" with exact phrase
    And disconnect the database connection "dbConn"
    And wait for "{anchor.admin_ui_heading}"
    And check that screen contains "{anchor.timestamp_display}" with exact phrase

Scenario: Comprehensive error response provides stable code and correlation identifier
    And compose a post request to "/api/v1/auctions" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {
        "auctionData": "{invalidPayload}"
      }
      """
    And execute and save the response as "errorResponse"
    And check that response {errorResponse} has "400" as status code
    And check that API response {errorResponse} contains "errorCode" at "$.errorCode"
    And check that API response {errorResponse} contains "correlationId" at "$.correlationId"
    And check that API response {errorResponse} contains "message" at "$.message"
    And extract value from API response {errorResponse} at "$.message" and save it as "errorMessage"
#   check that variable {errorMessage} does not contain "SQL" with exact phrase
#    check that variable {errorMessage} does not contain "stack trace" with exact phrase
#    check that variable {errorMessage} does not contain "Exception" with exact phrase

Scenario: Record comprehensive decision details including snapshot hash and policy version
    And wait for "Auction Request"
    And check that screen contains "Platform Admin" with exact phrase
    And click "Approve"
    And wait for "Commit"
    And click "Commit"
    And wait for "Decision Record"
    And check that screen contains "Requirements Snapshot Hash" with exact phrase
    And read value from field on the right of "Requirements Snapshot Hash" and save it as "snapshotHash"
    And check that variable {snapshotHash} contains "{expectedSnapshotHash}" with exact phrase
    And check that screen contains "Policy Version" with exact phrase
    And read value from field on the right of "Policy Version" and save it as "policyVersion"
    And check that variable {policyVersion} contains "{expectedPolicyVersion}" with exact phrase
    And check that screen contains "Maker" with exact phrase
    And read value from field on the right of "Maker" and save it as "makerIdentity"
    And check that variable {makerIdentity} contains "Platform Admin" with exact phrase
    And check that screen contains "Checker" with exact phrase
    And read value from field on the right of "Checker" and save it as "checkerIdentity"
    And check that variable {checkerIdentity} contains "{expectedCheckerIdentity}" with exact phrase
    And click "Audit"
    And wait for "Audit Entry"
    And check that screen contains "{expectedSnapshotHash}" with exact phrase
    And check that screen contains "{expectedPolicyVersion}" with exact phrase
    And check that screen contains "Platform Admin" with exact phrase

Scenario: Local dedicated stack initializes with isolated data stores
    And wait for "{anchor.localStackDashboard}"
    And check that screen contains "postgres" with exact phrase
    And check that screen contains "nats" with exact phrase
    And check that screen contains "envoy" with exact phrase
    And check that screen contains "{anchor.globalPlatformSchema}" with exact phrase
    And check that screen contains "{anchor.auctioneeerSchema}" with exact phrase

Scenario: Enforce uniqueness of authenticated operation identifiers for idempotency
    And compose a post request to "{mutationEndpoint}" with headers
      | Content-Type  | application/json |
      | Authorization | Bearer {authToken} |
    And with the below JSON request
      """
      {
        "authenticated_principal": "user-1",
        "operation_scope": "AUCTION_SUBMIT",
        "idempotency_key": "key-abc-123"
      }
      """
    And execute and save the response as "firstResponse"
    And check that response {firstResponse} has "200" as status code
    And check that API response {firstResponse} contains "key-abc-123" at "$.idempotency_key"
    And compose a post request to "{mutationEndpoint}" with headers
      | Content-Type  | application/json |
      | Authorization | Bearer {authToken} |
    And with the below JSON request
      """
      {
        "authenticated_principal": "user-1",
        "operation_scope": "AUCTION_SUBMIT",
        "idempotency_key": "key-abc-123"
      }
      """
    And execute and save the response as "duplicateResponse"
    And check that response {duplicateResponse} has "200" as status code
    And extract value from API response {firstResponse} at "$.result" and save it as "firstResult"
    And extract value from API response {duplicateResponse} at "$.result" and save it as "duplicateResult"
    And check that variable {duplicateResult} contains "{firstResult}" with exact phrase

Scenario: Maintain monotonic document versioning during concurrent edits
    And wait for "version"
    And check that screen contains "3" with exact phrase
    And click "Save"
    And wait 2 sec
    And check that screen contains "4" with exact phrase
    And check that screen contains "5" with exact phrase
    And check that screen does not contain "version overwritten" with exact phrase
    And check that "4" appears 1 time on screen with exact phrase
    And check that "5" appears 1 time on screen with exact phrase

Scenario: HTTP 202 Accepted response denotes asynchronous processing without implying final bid acceptance
    And wait for "{anchor.bidSubmissionEndpoint}"
    And compose a post request to "{bidSubmissionEndpoint}" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {bidPayload}
      """
    And execute and save the response as "bidResponse"
    And check that response {bidResponse} has "202" as status code
    And extract value from API response {bidResponse} at "$.message" and save it as "responseMessage"
    And check that variable {responseMessage} contains "queued for matching" with exact phrase
#   check that variable {responseMessage} does not contain "authoritative win" with exact phrase
    And wait for "Processing"
    And check that screen contains "Processing" with exact phrase
    And check that screen does not contain "Accepted" with exact phrase

Scenario: Shared Java libraries exclude mutable domain entities
    And check that screen contains "libraries/java" with exact phrase
    And click "Run Static Analysis"
    And wait for "Analysis Complete"
    And check that screen contains "contract types" with exact phrase
    And check that screen contains "DTOs" with exact phrase
    And check that screen contains "utility primitives" with exact phrase
    And check that screen does not contain "mutable domain entities" with exact phrase
    And check that screen does not contain "JPA entity" with exact phrase
    And check that screen contains "Build Failed" with exact phrase

Scenario: Handle document revocation by blocking future access and creating audit records
    And wait for "DOC-900"
    And check that screen contains "DOC-900" with exact phrase
    And click "Revoke"
    And wait for "Reason"
    And enter "Regulatory update" into "Reason"
    And click "Confirm"
    And wait for "Revoked"
    And check that screen contains "Revoked" with exact phrase
    And check that screen contains "DOC-900" with exact phrase
    And check that screen contains "Access Denied" with exact phrase
    And check that screen contains "Revocation" with exact phrase
    And check that screen contains "Regulatory update" with exact phrase

Scenario: Enforce database access rules preventing cross-service direct SQL queries
    And connect to the database "core_service_db" using the following credentials and save it as "coreDbConn" and continue
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUser}     |
      | password | {dbPassword} |
    And execute the query "SELECT * FROM core_service_db.clients c JOIN document_service_db.documents d ON c.id = d.client_id LIMIT 1" using "coreDbConn" and save the results as "crossDbQueryResult" and continue
    And check (rowCount Equals 0) in "crossDbQueryResult" and continue
    And disconnect the database connection "coreDbConn"
    And compose a get request to "{baseUrl}/api/documents/{testClientId}" with headers
      | Authorization | Bearer {serviceToken} |
      | Accept        | application/json      |
    And execute and save the response as "interServiceApiResponse"
    And check that response {interServiceApiResponse} has "200" as status code
    And check that API response {interServiceApiResponse} contains "{testClientId}" at "$.clientId"

Scenario: Single monorepo triggers isolated builds and deployments for affected modules
    And wait for "apps/platform-admin"
    And check that screen contains "services/auctioneer-core" with exact phrase
    And click "services/auctioneer-core"
    And wait for "auctioneer-core"
    And check that screen contains "auctioneer-core" with exact phrase
    And check that screen does not contain "apps/platform-admin" with exact phrase

Scenario: Platform ensures complete data isolation across separate deployments
    And wait for "{anchor.deployment_alpha_screen}"
    And check that screen contains "Deployment-Alpha" with exact phrase
    And enter "{adminUsername}" into "Username"
    And enter "{adminPassword}" into "Password"
    And click "Login"
    And wait for "{anchor.auction_records_screen}"
    And click "Deployment-Alpha"
    And wait for "{anchor.auction_records_results}"
    And check that screen contains "Deployment-Alpha" with exact phrase
    And check that screen does not contain "Deployment-Beta" with exact phrase

Scenario: Upload new version of existing document preserving prior versions
    And wait for "DOC-550"
    And check that screen contains "v1" with exact phrase
    And compose a post request to "/documents/DOC-550/versions" with headers
      | Content-Type | multipart/form-data |
    And upload file "{newPdfFile}" to "Choose File"
    And click "Upload"
    And wait for "v2"
    And check that screen contains "v2" with exact phrase
    And check that screen contains "v1" with exact phrase

Scenario: Download specific historical document version with policy recheck
    And wait for "DOC-550"
    And check that screen contains "v1" with exact phrase
    And check that screen contains "v2" with exact phrase
    And click "v1"
    And wait for "{anchor.download_permissions_check}"
    And check that screen contains "{anchor.download_permissions_check}" with exact phrase
    And download file by clicking "v1" and save as "{anchor.downloaded_v1_path}"
    And check that screen contains "DOC-550" with exact phrase
    And check that screen contains "v1" with exact phrase

Scenario: Enforce API authentication and idempotency on api v1 endpoints independently of UI
    And compose a get request to "/api/v1/auctions" with headers
      | Authorization |  |
    And execute and save the response as "unauthResponse"
    And check that response {unauthResponse} has "401" as status code
    And check that screen contains "401 Unauthorized" with exact phrase
    And compose a post request to "/api/v1/auctions" with headers
      | Authorization | Bearer {bearerToken} |
    And execute and save the response as "noIdempotencyResponse"
    And check that response {noIdempotencyResponse} has "400" as status code
    And check that API response {noIdempotencyResponse} contains "Idempotency-Key header is required" at "$.message"

Scenario: Ensure document record table enforces UUID primary key uniqueness
    And connect to the database "document_record" using the following credentials and save it as "dbConn"
      | key      | value              |
      | host     | {db_host}          |
      | port     | {db_port}          |
      | username | {db_username}      |
      | password | {db_password}      |
      | database | {db_name}          |
    And execute the query "INSERT INTO document_record (id, content) VALUES (gen_random_uuid(), 'doc_1')" using "dbConn"
    And execute the query "INSERT INTO document_record (id, content) VALUES (gen_random_uuid(), 'doc_2')" using "dbConn"
    And execute the query "INSERT INTO document_record (id, content) VALUES (gen_random_uuid(), 'doc_3')" using "dbConn"
    And execute the query "SELECT id FROM document_record ORDER BY created_at DESC LIMIT 3" using "dbConn" and save the results as "uuidResults"
    And read "id" from row 1 of "uuidResults" and save it as "uuid1"
    And read "id" from row 2 of "uuidResults" and save it as "uuid2"
    And read "id" from row 3 of "uuidResults" and save it as "uuid3"
    And execute the query "SELECT COUNT(DISTINCT id) AS unique_count FROM document_record ORDER BY created_at DESC LIMIT 3" using "dbConn" and save the results as "uniqueCountResult"
    And read "unique_count" from "uniqueCountResult" and save it as "uniqueCount"
    And check that variable {uniqueCount} is equals to "3"
    And extract substring from "{uuid1}" using the pattern "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$" and save it as "uuidV4Validated"
    And check that variable {uuidV4Validated} contains "{uuid1}" with exact phrase
    And execute the query "SELECT id, content FROM document_record WHERE id = '{uuid1}'" using "dbConn" and save the results as "docByUuid1"
    And read "content" from "docByUuid1" and save it as "docContent1"
    And check that variable {docContent1} contains "doc_1" with exact phrase
    And disconnect the database connection "dbConn"

Scenario: System performs content hash verification upon ingestion and periodic sample audit
    And wait for "{anchor.objectRepositoryScreen}"
    And check that screen contains "{anchor.ingestedFileRecord}" with exact phrase
    And click "{anchor.triggerIngestionWorker}"
    And wait for "{anchor.ingestionCompleteConfirmation}"
    And check that screen contains "{anchor.sha256HashLabel}" with exact phrase
    And check that screen contains "{anchor.uploadIntentValidationStatus}" with exact phrase
    And click "{anchor.runBackgroundVerificationJob}"
    And wait for "{anchor.verificationJobCompleteConfirmation}"
    And check that screen contains "{anchor.sampleHashVerificationResult}" with exact phrase

Scenario: Generate opaque random identifiers for storage keys without sensitive leaks
    And wait for "{anchor.keyGenerationScreen}"
    And click "{anchor.generateKeyControl}"
    And wait for "{anchor.generatedKeyResult}"
    And read value from field on the right of "{anchor.generatedKeyLabel}" and save it as "generatedKey" with exact phrase
    And check that variable {generatedKey} contains "{expectedOpaqueKey}" with exact phrase
    And check that screen does not contain "{bidderName}" with exact phrase
    And check that screen does not contain "{auctionTitle}" with exact phrase
    And check that screen does not contain "{sequentialDocNumber}" with exact phrase

Scenario: Local developer environment setup validates prerequisite dependencies
    And wait for "setup-local-dev.sh"
    And check that screen contains "Docker" with exact phrase
    And check that screen contains "Java 21" with exact phrase
    And check that screen contains "Node.js" with exact phrase
    And check that screen contains "missing" with exact phrase

Scenario: Repository conventions enforce standard directory structure and linters
    And check that screen contains "apps" with exact phrase
    And check that screen contains "services" with exact phrase
    And check that screen contains "packages" with exact phrase
    And check that screen contains "infrastructure" with exact phrase
    And check that screen contains "tests" with exact phrase
    And check that screen contains "docs" with exact phrase
    And check that screen contains "pre-commit" with exact phrase

Scenario: Local access credentials are short-lived and enforce bounded renewal
    And wait for "{anchor.local_portal_authenticated_screen}"
    And wait 1 sec
    And wait for "{anchor.token_renewal_prompt}"
    And check that screen contains "{anchor.renewal_request_indicator}" with exact phrase
    And wait for "{anchor.token_expiry_state}"
    And check that screen contains "{anchor.access_blocked_message}" with exact phrase
    And check that screen contains "{anchor.access_screen_heading}" with exact phrase

Scenario: Configurable product supports auctioneer-specific rulebooks via policy settings
    And wait for "{anchor.geap_home_screen}"
    And enter "auctioneer-local-1" into "{anchor.tenant_selector}"
    And wait for "{anchor.rulebook_loaded_confirmation}"
    And check that screen contains "{anchor.forward_auction_rules_enabled}" with exact phrase
    And check that screen contains "{anchor.increment_steps_configured}" with exact phrase
    And enter "auctioneer-local-2" into "{anchor.tenant_selector}"
    And wait for "{anchor.tenant2_rulebook_loaded_confirmation}"
    And check that screen contains "{anchor.tenant2_distinct_rulebook_active}" with exact phrase

Scenario: Durable messaging with NATS JetStream handles consumer restarts gracefully
    And wait for "auction event"
    And check that screen contains "consumer" with exact phrase
    And click "Restart Consumer"
    And wait for "consumer resumed"
    And check that screen contains "last acknowledged sequence number" with exact phrase
    And check that screen contains "no duplicate" with exact phrase

Scenario: PostgreSQL database transactions maintain strict ACID consistency on rollback
    And connect to the database "PostgreSQL" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
      | database | {dbName}     |
    And execute the query "BEGIN; INSERT INTO auctions (id, title) VALUES ({auctionId}, '{auctionTitle}'); INSERT INTO lots (id, auction_id, name) VALUES ({lot1Id}, {auctionId}, '{lot1Name}'); INSERT INTO lots (id, auction_id, name) VALUES ({lot2Id}, {auctionId}, '{lot2Name}'); INSERT INTO lots (id, auction_id, name) VALUES ({lot3Id}, {auctionId}, NULL) ON CONFLICT DO NOTHING; COMMIT;" using "dbConn" and save the results as "txResult" and continue
    And execute the query "SELECT COUNT(*) AS cnt FROM auctions WHERE id = {auctionId}" using "dbConn" and save the results as "auctionCount"
    And read "cnt" from row 1 of "auctionCount" and save it as "auctionRows"
    And check that variable {auctionRows} is equals to "0"
    And execute the query "SELECT COUNT(*) AS cnt FROM lots WHERE auction_id = {auctionId}" using "dbConn" and save the results as "lotCount"
    And read "cnt" from row 1 of "lotCount" and save it as "lotRows"
    And check that variable {lotRows} is equals to "0"
    And disconnect the database connection "dbConn"

Scenario: React and TypeScript frontend enforces strict prop types and responsiveness
    And wait for "Auction requests"
    And check that screen contains "Auctioneer Portal" with exact phrase
    And check that screen contains "Auction requests" with exact phrase
    And check that screen contains "Create and submit governed auction requests for Platform Admin review." with exact phrase
    And check that screen contains "Title" with exact phrase
    And check that screen contains "Status" with exact phrase
    And check that screen contains "Version" with exact phrase
    And check that screen contains "Latest decision" with exact phrase
    And check that screen contains "Type" with exact phrase
    And check that screen contains "Auction_1" with exact phrase
    And check that screen contains "Draft" with exact phrase
    And check that screen contains "v1" with exact phrase
    And check that screen contains "FORWARD" with exact phrase
    And check that button "New request" is enabled
    And check that button "All" is enabled
    And check that button "Draft" is enabled
    And check that button "Submitted" is enabled
    And check that button "Clarification required" is enabled
    And check that button "Resubmitted" is enabled
    And check that button "Approved" is enabled
    And check that button "Rejected" is enabled
    And check that button "Withdrawn" is enabled
    And check that screen contains "Home" with exact phrase
    And check that screen contains "Organization" with exact phrase
    And check that screen contains "Auctions" with exact phrase

Scenario: Platform maintains single uniform product release baseline without client forks
    And wait for "Deployment Pipeline"
    And check that screen contains "v1.2.0" with exact phrase
    And check that screen contains "artifact" with exact phrase
    And check that screen contains "configuration" with exact phrase

Scenario: Modular architecture guarantees runtime isolation between service components
    And wait for "{anchor.auctioneer_core_running}"
    And check that screen contains "{anchor.document_service_running}" with exact phrase
    And check that screen contains "{anchor.document_service_fault_indicator}" with exact phrase
    And check that screen contains "{anchor.bid_processing_active}" with exact phrase
    And check that screen contains "{anchor.auction_requests_active}" with exact phrase

Scenario: Auctioneer Core APIs establish standardized error codes and WCAG compliance
    And compose a post request to "/api/v1/local/auctions" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {malformedPayload}
      """
    And execute and save the response as "auctionResponse"
    And check that response {auctionResponse} has "400" as status code
    And check that API response {auctionResponse} contains "ERR_INVALID_PAYLOAD" at "$.errorCode"
    And wait for "ERR_INVALID_PAYLOAD"
    And check that screen contains "ERR_INVALID_PAYLOAD" with exact phrase
    And check that screen contains "{anchor.high_contrast_error_banner}" with exact phrase

Scenario: System maintains tamper-evident audit logs with synchronized timestamps
    And wait for "audit log"
    And check that screen contains "auction approval" with exact phrase
    And click "Store" 
    And wait for "{anchor.audit_repository_confirmation}"
    And check that screen contains "{anchor.cryptographic_hash_chain}" with exact phrase
    And check that screen contains "{anchor.prior_log_entry_reference}" with exact phrase
    And check that screen contains "{anchor.utc_timestamp}" with exact phrase

Scenario: Scalable architecture supports seamless horizontal module integration
    And wait for "{anchor.api_gateway_screen}"
    And check that screen contains "{anchor.core_microservices_routing}" with exact phrase
    And click "{anchor.add_service_button}"
    And enter "{reportingModuleServiceName}" into "{anchor.service_name_field}"
    And enter "{reportingModuleEndpoint}" into "{anchor.routing_endpoint_field}"
    And click "{anchor.save_routing_entry_button}"
    And wait for "{anchor.routing_table_updated_confirmation}"
    And check that screen contains "{anchor.reporting_endpoint_route}" with exact phrase
    And check that screen contains "{anchor.core_services_unchanged_indicator}" with exact phrase

Scenario: Storage buckets maintain strict namespace segregation between quarantine and evidence
    And wait for "{anchor.objectStorageServiceConfig}"
    And upload file "{unverifiedFile}" to "{anchor.fileUploadControl}"
    And check that screen contains "quarantine" with exact phrase
    And check that screen does not contain "evidence" with exact phrase
    And check that screen does not contain "documents" with exact phrase

Scenario: Define integration event families with tenant scope and idempotency keys
    And wait for "AuctionPublishedEvent"
    And check that screen contains "AuctionPublishedEvent" with exact phrase
    And wait for "{anchor.nats_jetstream_serialization_confirmation}"
    And check that screen contains "tenantId" with exact phrase
    And check that screen contains "correlationId" with exact phrase
    And check that screen contains "idempotencyKey" with exact phrase
    And check that screen contains "occurredAt" with exact phrase
    And check that screen contains "{anchor.tenant_scope_filter_confirmation}" with exact phrase

Scenario: Restrict PDF uploads containing active JavaScript or embedded executables
    And upload file "spec.pdf" to "Upload"
    And wait for "Active content and embedded scripts are prohibited in PDF uploads"

Scenario: Core business records maintain mandatory logical content
    And wait for "Organization Profile"
    And clear text from "Legal name"
    And clear text from "Primary business contact"
    And click "Submit"
    And check that screen contains "Legal name" with exact phrase
    And check that screen contains "Primary business contact" with exact phrase
    And check that screen contains "required" with exact phrase

Scenario: Verify actor permissions and validate document parameters prior to upload
    And wait for "{anchor.upload_intent_screen}"
    And enter "50" into field on the right of "{anchor.document_size_label}"
    And click "{anchor.submit_upload_intent}"
    And check that screen contains "400 Bad Request" with exact phrase
    And check that screen contains "File size exceeds maximum permitted limit of 25MB" with exact phrase

Scenario: Create new extraction revision when document is reprocessed
    And wait for "rev-1"
    And check that screen contains "rev-1" with exact phrase
    And click "{anchor.reprocess_document}"
    And wait for "{anchor.reprocess_dialog_or_confirmation}"
    And click "{anchor.confirm_reprocess}"
    And wait for "rev-2"
    And check that screen contains "rev-2" with exact phrase
    And check that screen contains "rev-1" with exact phrase

Scenario: Persist ownership and tenant scope across all document references
    And connect to the database "geap" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUsername} |
      | password | {dbPassword} |
    And execute the query "SELECT tenantId, ownerId, purpose FROM document_references WHERE tenantId = 'auctioneer-local-1' ORDER BY createdAt DESC LIMIT 1" using "dbConn" and save the results as "docRefResults"
    And check (rowCount GreaterThan 0) in "docRefResults"
    And read "tenantId" from row 1 of "docRefResults" and save it as "savedTenantId"
    And check that variable {savedTenantId} contains "auctioneer-local-1" with exact phrase
    And read "ownerId" from row 1 of "docRefResults" and save it as "savedOwnerId"
    And check that variable {savedOwnerId} contains "{ownerId}" with exact phrase
    And read "purpose" from row 1 of "docRefResults" and save it as "savedPurpose"
    And check that variable {savedPurpose} contains "{purpose}" with exact phrase
    And execute the query "SELECT COUNT(*) as accessCount FROM document_references WHERE tenantId != 'auctioneer-local-1' AND id = (SELECT id FROM document_references WHERE tenantId = 'auctioneer-local-1' ORDER BY createdAt DESC LIMIT 1)" using "dbConn" and save the results as "crossTenantResults"
    And read "accessCount" from row 1 of "crossTenantResults" and save it as "crossTenantCount"
    And check that variable {crossTenantCount} is equals to "0"
    And disconnect the database connection "dbConn"

Scenario: System fails closed when evaluating unverified documents
    And wait for "Auction_1"
    And check that screen contains "pending verification" with exact phrase
    And click "Auction_1"
    And wait for "Approve"
    And check that screen contains "missing verified documents" with exact phrase
    And check that button "Approve" is disabled

Scenario: Legal holds override document deletion processes
    And wait for "DOC-990"
    And check that screen contains "LEGAL_HOLD" with exact phrase
    And click "Delete"
    And check that screen contains "Deletion blocked by active legal hold" with exact phrase
    And check that screen contains "DOC-990" with exact phrase

Scenario: Standardize contract artifacts including OpenAPI specifications in repository
    And wait for "packages/contracts"
    And check that screen contains "openapi: 3.1" with exact phrase
    And check that screen contains "packages/contracts" with exact phrase

Scenario: Shared libraries preserve service boundary independence without common ORM entities
    And check that screen contains "libraries/java" with exact phrase
    And check that screen does not contain "entity" with exact phrase
    And check that screen does not contain "JPA" with exact phrase
    And check that screen contains "migration" with exact phrase

Scenario: Trace correlation preserves privacy without logging PII or secrets
    And compose a get request to "{traceCollectorUrl}" with headers
    And execute and save the response as "traceResponse"
    And check that response {traceResponse} has "200" as status code
    And extract value from API response {traceResponse} at "$.logs" and save it as "traceLogs"
#  check that variable {traceLogs} does not contain "password" with exact phrase
#    check that variable {traceLogs} does not contain "bearer" with exact phrase
#    check that variable {traceLogs} does not contain "{nationalIdNumber}" with exact phrase
    And extract value from API response {traceResponse} at "$.spans[0].traceId" and save it as "traceId"
    And check that variable {traceId} contains "{correlationId}" with exact phrase
    And check that screen does not contain following
    And check that screen contains "{correlationId}" with exact phrase
    And wait for "{anchor.cross_service_trace_correlation_trac}"

Scenario: Monorepo allows independent service builds from artifact registry
    And check that screen contains "auctioneer-core" with exact phrase
    And click "mvn clean package -pl services/auctioneer-core"
    And wait for "BUILD SUCCESS"
    And check that screen contains "BUILD SUCCESS" with exact phrase
    And check that screen contains "auctioneer-core" with exact phrase
    And check that screen does not contain "frontends"

Scenario: Monorepo structure enforces consistent root folder hierarchy
    And wait for "{anchor.projectWorkspaceRoot}"
    And check that screen contains "apps" with exact phrase
    And check that screen contains "services" with exact phrase
    And check that screen contains "packages" with exact phrase
    And check that screen contains "infrastructure" with exact phrase
    And check that screen contains "tests" with exact phrase
    And check that screen contains "docs" with exact phrase
    And check that screen contains "{anchor.namingGuidelinesConformance}" with exact phrase

Scenario: Sensitive data including credentials and bearer tokens masked in application logs
    And check that screen contains "Authorization" with exact phrase
    And wait for "[REDACTED]"
    And check that screen contains "[REDACTED]" with exact phrase
    And check that screen does not contain "Bearer secret-token-123" with exact phrase
    And check that screen does not contain "secret-token-123" with exact phrase

Scenario: Assemble service data model fragments into idempotent Flyway migrations
    And wait for "Migration Scripts"
    And check that screen contains "V2__add_auction_lots.sql" with exact phrase
    And check that screen contains "IF NOT EXISTS" with exact phrase
    And click "Run Migration"
    And wait for "Migration successful"
    And click "Run Migration"
    And wait for "Migration successful"
    And check that screen contains "No changes applied" with exact phrase

Scenario: Database migration tooling blocks unsafe rollbacks on irreversible changes
    And check that screen contains "applied migration" with exact phrase
    And click "Rollback"
    And wait for "Irreversible migration detected"
    And check that screen contains "Irreversible migration detected" with exact phrase
    And check that screen contains "restoring from backup" with exact phrase

Scenario: Reject invalid form input preserving authoritative entity state
    And wait for "Title *"
    And enter "{fiveHundredCharTitle}" into "Title *"
    And click "Save"
    And check that screen contains "Title must not exceed 100 characters" with exact phrase

Scenario: Database schema changes enforce backward compatibility with expand-contract pattern
    And connect to the database "serviceDB" using the following credentials and save it as "dbConn"
      | host     | {dbHost}     |
      | port     | {dbPort}     |
      | username | {dbUser}     |
      | password | {dbPassword} |
      | database | {dbName}     |
    And execute the query "SELECT column_name FROM information_schema.columns WHERE table_name='service_table' AND column_name='old_desc'" using "dbConn" and save the results as "preCheckResult"
    And check (rowCount GreaterThan 0) in "preCheckResult"
    And execute the query "ALTER TABLE service_table ADD COLUMN new_desc VARCHAR(255)" using "dbConn"
    And execute the query "UPDATE service_table SET new_desc = old_desc" using "dbConn"
    And execute the query "SELECT column_name FROM information_schema.columns WHERE table_name='service_table' AND column_name='new_desc'" using "dbConn" and save the results as "expandCheckResult"
    And check (rowCount GreaterThan 0) in "expandCheckResult"
    And execute the query "SELECT column_name FROM information_schema.columns WHERE table_name='service_table' AND column_name='old_desc'" using "dbConn" and save the results as "retainCheckResult"
    And check (rowCount GreaterThan 0) in "retainCheckResult"
    And execute the query "SELECT old_desc, new_desc FROM service_table LIMIT 1" using "dbConn" and save the results as "dualWriteResult"
    And read "old_desc" from row 1 of "dualWriteResult" and save it as "oldDescValue"
    And read "new_desc" from row 1 of "dualWriteResult" and save it as "newDescValue"
    And check that variable {oldDescValue} contains "{oldDescValue}" with exact phrase
    And check that variable {newDescValue} contains "{oldDescValue}" with exact phrase
    And execute the query "SELECT old_desc FROM service_table LIMIT 5" using "dbConn" and save the results as "consumerReadResult"
    And check (rowCount GreaterThan 0) in "consumerReadResult"
    And disconnect the database connection "dbConn"

Scenario: Capture service interactions including enquiries and complaints
    And wait for "customer service ticket"
    And check that screen contains "bidder" with exact phrase
    And click "Assign"
    And enter "agent-mark" into "Assign To"
    And select "In-Progress" from list "Status"
    And click "Save"
    And wait for "Case Ownership"
    And check that screen contains "Case Ownership" with exact phrase
    And check that screen contains "Correspondence" with exact phrase
    And check that screen contains "Outcome" with exact phrase

Scenario: Codebase organized into structured monorepo directories
    And wait for "apps"
    And check that screen contains "platform-admin" with exact phrase
    And check that screen contains "auctioneer-portal" with exact phrase
    And check that screen contains "bidder-portal" with exact phrase
    And wait for "services"
    And check that screen contains "auctioneer-core" with exact phrase
    And check that screen contains "document-service" with exact phrase

Scenario: Browser establishes connections to global edge and dedicated auctioneer edge
    And wait for "{anchor.geap_home_screen}"
    And compose a get request to "{baseUrl_globalEdge_8089}/identity" with headers
      | Authorization | {authToken} |
    And execute and save the response as "identityResponse"
    And check that response {identityResponse} has "200" as status code
    And compose a get request to "{baseUrl_globalEdge_8089}/catalog" with headers
      | Authorization | {authToken} |
    And execute and save the response as "catalogResponse"
    And check that response {catalogResponse} has "200" as status code
    And compose a get request to "{baseUrl_auctioneerEdge_9009}/events/bid" with headers
      | Authorization | {authToken} |
    And execute and save the response as "bidEventsResponse"
    And check that response {bidEventsResponse} has "200" as status code
    And compose a get request to "{baseUrl_auctioneerEdge_9009}/events/state" with headers
      | Authorization | {authToken} |
    And execute and save the response as "auctionStateResponse"
    And check that response {auctionStateResponse} has "200" as status code

Scenario: Grant access through deny-by-default role and attribute based access control
    And wait for "BIDDER"
    And click "Approve Registration"
    And check that screen contains "403" with exact phrase
    And check that screen contains "Forbidden" with exact phrase

Scenario: System enforces least privilege and local policy evaluation during failures
    And check that screen contains "network partition" with exact phrase
    And check that screen contains "local auctioneer edge" with exact phrase
    And check that screen contains "action execution request" with exact phrase
    And check that screen contains "cached local least-privilege policy" with exact phrase
    And check that screen contains "access denied" with exact phrase

Scenario: Local service executes only permitted actions after deployment re-evaluation
    And wait for "{anchor.lot_action_screen}"
    And check that screen contains "lot-10" with exact phrase
    And click "{anchor.evaluate_deployment}"
    And wait for "{anchor.evaluation_result}"
    And check that screen contains "{anchor.lot_transition_authorized}" with exact phrase
    And check that screen contains "{anchor.non_permitted_action_rejected}" with exact phrase
    And check that screen contains "{anchor.action_logged}" with exact phrase

Scenario: Standardize API endpoints with api v1 prefix and typed error bodies
    And compose a get request to "/api/v1/invalid-path" with headers
      | Content-Type | application/json |
    And execute and save the response as "errorResponse"
    And check that response {errorResponse} has "404" as status code
    And check that API response {errorResponse} contains "type" at "$.type"
    And check that API response {errorResponse} contains "title" at "$.title"
    And check that API response {errorResponse} contains "404" at "$.status"
    And check that API response {errorResponse} contains "detail" at "$.detail"

Scenario: Contract envelope defines required correlation and aggregate metadata
    And check that screen contains "eventId" with exact phrase
    And check that screen contains "eventType" with exact phrase
    And check that screen contains "schemaVersion" with exact phrase
    And check that screen contains "sourceService" with exact phrase
    And check that screen contains "deploymentId" with exact phrase
    And check that screen contains "aggregateType" with exact phrase
    And check that screen contains "aggregateId" with exact phrase
    And check that screen contains "aggregateVersion" with exact phrase
    And check that screen contains "payload" with exact phrase

Scenario: Materialize canonical contract for inter-service communication
    And wait for "contract registry"
    And check that screen contains "contract registry" with exact phrase
    And click "Register Contract"
    And wait for "contract definitions"
    And click "Submit"
    And wait for "canonical contract schema"
    And check that screen contains "Auctioneer Core" with exact phrase
    And check that screen contains "DTO" with exact phrase

Scenario: Comprehensive contract tests execute reliably across Core and Document services
    And wait for "{anchor.contractTestSuiteDashboard}"
    And compose a get request to "{contractTestSuiteUrl}" with headers
    And execute and save the response as "contractTestResponse"
    And check that response {contractTestResponse} has "200" as status code
    And extract value from API response {contractTestResponse} at "$.status" and save it as "suiteStatus"
    And check that variable {suiteStatus} contains "passed" with exact phrase
    And extract value from API response {contractTestResponse} at "$.schemaDeviations" and save it as "schemaDeviations"
    And check that variable {schemaDeviations} is equals to "0"
    And extract value from API response {contractTestResponse} at "$.requestResponseSchemaValidation" and save it as "schemaValidation"
    And check that variable {schemaValidation} contains "valid" with exact phrase
    And extract value from API response {contractTestResponse} at "$.headersValidation" and save it as "headersValidation"
    And check that variable {headersValidation} contains "valid" with exact phrase
    And extract value from API response {contractTestResponse} at "$.statusCodesValidation" and save it as "statusCodesValidation"
    And check that variable {statusCodesValidation} contains "valid" with exact phrase
    And check that screen contains "{anchor.contractTestsPassedMessage}" with exact phrase
    And wait for "{anchor.automated_contract_test_suite}"

Scenario: Session management documentation details expiry and refresh behaviors
    And wait for "{anchor.technical_documentation_site_heading}"
    And click "docs/architecture/session-management.md"
    And wait for "{anchor.session_management_page_heading}"
    And check that screen contains "token" with exact phrase
    And check that screen contains "sliding session" with exact phrase
    And check that screen contains "refresh" with exact phrase
    And check that screen contains "session termination" with exact phrase
    And check that screen contains "global outage" with exact phrase

Scenario: Gateway blocks untrusted routes not present in deployment registry allowlist
    And compose a get request to "http://malicious-route.local" with headers
      | Header       | Value            |
      | Content-Type | application/json |
    And execute and save the response as "gatewayResponse"
    And check that response {gatewayResponse} has "403" as status code
    And check that API response {gatewayResponse} contains "Forbidden" at "$.message"
    And compose a get request to "{gatewaySecurityLogUrl}" with headers
      | Header       | Value            |
      | Content-Type | application/json |
    And execute and save the response as "securityLogResponse"
    And check that API response {securityLogResponse} contains "http://malicious-route.local" at "$.entries[0].route"

Scenario: Suppress prohibited document fields for unprivileged recipients
    And wait for "{documentServiceAnchor}"
    And check that screen contains "{publicCatalogInfo}" with exact phrase
    And click "{bidderRequestDocumentDetails}"
    And wait for "{documentResponseAnchor}"
    And check that screen does not contain "{confidentialReservePrice}" with exact phrase
    And check that screen contains "{permittedPublicCatalogFields}" with exact phrase

Scenario: Audit records maintain cryptographic hashes and sequential timestamps
    And wait for "{anchor.audit_records_screen}"
    And check that screen contains "{anchor.sequential_timestamp_label}" with exact phrase
    And check that screen contains "{anchor.cryptographic_signature_label}" with exact phrase

Scenario: Modular API-first architecture supports horizontal extension without disruption
    And wait for "bulk-lot-import"
    And check that screen contains "bulk-lot-import" with exact phrase
    And compose a get request to "{biddingEndpointUrl}" with headers
      | Content-Type | application/json |
    And execute and save the response as "biddingResponse"
    And check that response {biddingResponse} has "200" as status code
    And compose a get request to "{registrationEndpointUrl}" with headers
      | Content-Type | application/json |
    And execute and save the response as "registrationResponse"
    And check that response {registrationResponse} has "200" as status code
    And compose a post request to "{bulkLotImportEndpointUrl}" with headers
      | Content-Type | application/json |
    And execute and save the response as "bulkLotImportResponse"
    And check that response {bulkLotImportResponse} has "200" as status code
    And extract value from API response {bulkLotImportResponse} at "$.responseTimeMs" and save it as "responseTimeMs"
    And check that variable {responseTimeMs} is numerically less than "200"

Scenario: Prevent data leakage across tenant boundaries in multi-tenant queries
    And connect to the database "geap_platform" using the following credentials and save it as "dbConn"
      | key      | value        |
      | host     | {db_host}    |
      | port     | {db_port}    |
      | username | {db_username}|
      | password | {db_password}|
      | database | {db_name}    |
    And execute the query "SELECT COUNT(*) as cnt FROM records WHERE tenant_id = 'auctioneer-local-1'" using "dbConn" and save the results as "tenant1Records" and continue
    And execute the query "SELECT COUNT(*) as cnt FROM records WHERE tenant_id = 'auctioneer-local-2'" using "dbConn" and save the results as "tenant2Records" and continue
    And check (rowCount GreaterThan 0) in "tenant1Records"
    And check (rowCount GreaterThan 0) in "tenant2Records"
    And execute the query "SELECT query_text FROM query_log WHERE tenant_id = 'auctioneer-local-1' ORDER BY executed_at DESC LIMIT 1" using "dbConn" and save the results as "queryLogResult" and continue
    And read "query_text" from row 1 of "queryLogResult" and save it as "lastQueryText"
    And check that variable {lastQueryText} contains "WHERE tenant_id = 'auctioneer-local-1'" with exact phrase
    And execute the query "SELECT COUNT(*) as leakCount FROM search_results WHERE session_tenant_id = 'auctioneer-local-1' AND record_tenant_id = 'auctioneer-local-2'" using "dbConn" and save the results as "leakageResult" and continue
    And read "leakCount" from row 1 of "leakageResult" and save it as "leakCount"
    And check that variable {leakCount} is equals to "0"
    And disconnect the database connection "dbConn"

Scenario: Ensure API paths enforce idempotency keys on mutations and return ETags
    And compose a post request to "/api/v1/auctions/requests" with headers
      | Idempotency-Key | idemp-901 |
      | Content-Type    | application/json |
    And with the below JSON request
      """
      {
        "type": "auction_request"
      }
      """
    And execute and save the response as "firstResponse"
    And check that response {firstResponse} has "201" as status code
    And extract value from API response {firstResponse} at "$.headers.ETag" and save it as "firstETag"
    And check that variable {firstETag} is not equals to "" with exact phrase
    And compose a post request to "/api/v1/auctions/requests" with headers
      | Idempotency-Key | idemp-901 |
      | Content-Type    | application/json |
    And with the below JSON request
      """
      {
        "type": "auction_request"
      }
      """
    And execute and save the response as "secondResponse"
    And extract value from API response {secondResponse} at "$.headers.ETag" and save it as "secondETag"
    And check that variable {secondETag} contains "{firstETag}" with exact phrase

Scenario: Service boundaries established with clear domain responsibilities
    And check that screen contains "Auctioneer Core" with exact phrase
    And check that screen contains "auctions" with exact phrase
    And check that screen contains "rulebooks" with exact phrase
    And check that screen contains "lot lifecycle" with exact phrase
    And check that screen contains "Document Service" with exact phrase
    And check that screen contains "ingestion" with exact phrase
    And check that screen contains "quarantine" with exact phrase
    And check that screen contains "scanning" with exact phrase
    And check that screen contains "downloads" with exact phrase

Scenario: Maker checker validation strictly denies single-actor approvals
    And compose a post request to "{approvalApiUrl}" with headers
      | Authorization | {localDevAuthToken} |
      | Content-Type  | application/json    |
    And with the below JSON request
      """
      {
        "auctionRequestId": "Auction_1",
        "createdBy": "local-dev",
        "approvedBy": "local-dev"
      }
      """
    And execute and save the response as "approvalResponse"
    And check that response {approvalResponse} has "403" as status code
    And check that API response {approvalResponse} contains "Maker and checker cannot be the same user" at "$.message"

Scenario: API error handling distinguishes retryable transient errors from definitive rejections
    And compose a post request to "{transientErrorEndpoint}" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {
        "simulateError": "LOCK_TIMEOUT"
      }
      """
    And execute and save the response as "transientErrorResponse"
    And check that response {transientErrorResponse} has "503" as status code
    And check that API response {transientErrorResponse} contains "TRANSIENT_LOCK_TIMEOUT" at "$.errorCode"
    And check that API response {transientErrorResponse} contains "true" at "$.retryable"
    And compose a post request to "{businessRuleErrorEndpoint}" with headers
      | Content-Type | application/json |
    And with the below JSON request
      """
      {
        "simulateError": "BUSINESS_RULE_VIOLATION"
      }
      """
    And execute and save the response as "businessRuleErrorResponse"
    And check that response {businessRuleErrorResponse} has "422" as status code
    And check that API response {businessRuleErrorResponse} contains "BUSINESS_RULE_VIOLATION" at "$.errorCode"
    And check that API response {businessRuleErrorResponse} contains "false" at "$.retryable"

Scenario: Developer accesses OpenAPI documentation portal
    And wait for "Swagger UI"
    And check that screen contains "/api/v1" with exact phrase
    And check that screen contains "Swagger UI" with exact phrase
    And check that screen contains "OpenAPI 3.1" with exact phrase
    And check that screen contains "GET" with exact phrase
    And check that screen contains "POST" with exact phrase

Scenario: Tenant operations evaluated against membership and assigned role
    And check that screen contains "auctioneer-local-1" with exact phrase
    And check that screen contains "AUCTIONEER_OFFICER" with exact phrase

Scenario: Dual control checker tasks enforce independent verification
    And wait for "Compliance Tasks"
    And click "{anchor.compliance_task_requiring_dual_authorization}"
    And wait for "Dual Authorization"
    And click "{anchor.mark_task_verified_button}"
    And check that screen contains "Verification requires a second authorized checker" with exact phrase
    And click "{anchor.logout_or_switch_user}"
    And wait for "{anchor.login_screen_anchor}"
    And enter "{secondOfficerUsername}" into "{anchor.username_field}"
    And enter "{secondOfficerPassword}" into "{anchor.password_field}"
    And click "{anchor.login_button}"
    And wait for "Compliance Tasks"
    And click "{anchor.pending_compliance_task}"
    And wait for "Dual Authorization"
    And click "{anchor.approve_button}"
    And check that screen contains "{anchor.task_completed_confirmation}" with exact phrase

Scenario: Distributed trace correlation tracks requests across Core, Prism, and Document services
    And wait for "API Gateway"
    And compose a get request to "{gatewayRequestUrl}" with headers
      | traceparent     | {traceparent}      |
      | X-Correlation-Id | {correlationId}   |
    And execute and save the response as "gatewayResponse"
    And check that response {gatewayResponse} has "200" as status code
    And compose a get request to "{auctioneerCoreUrl}" with headers
      | traceparent     | {traceparent}      |
      | X-Correlation-Id | {correlationId}   |
    And execute and save the response as "coreResponse"
    And check that response {coreResponse} has "200" as status code
    And compose a get request to "{documentServiceUrl}" with headers
      | traceparent     | {traceparent}      |
      | X-Correlation-Id | {correlationId}   |
    And execute and save the response as "documentResponse"
    And check that response {documentResponse} has "200" as status code
    And extract value from API response {documentResponse} at "$.headers.traceparent" and save it as "docTraceparent"
    And check that variable {docTraceparent} contains "{traceparent}" with exact phrase
    And extract value from API response {documentResponse} at "$.headers.x-correlation-id" and save it as "docCorrelationId"
    And check that variable {docCorrelationId} contains "{correlationId}" with exact phrase
    And extract value from API response {coreResponse} at "$.headers.traceparent" and save it as "coreTraceparent"
    And check that variable {coreTraceparent} contains "{traceparent}" with exact phrase
    And extract value from API response {coreResponse} at "$.headers.x-correlation-id" and save it as "coreCorrelationId"
    And check that variable {coreCorrelationId} contains "{correlationId}" with exact phrase
    And check that screen contains "traceparent" with exact phrase
    And check that screen contains "X-Correlation-Id" with exact phrase
    And check that screen contains "{correlationId}" with exact phrase

Scenario: Access to reserve price data strictly controlled and segregated
    And wait for "Reserve price"
    And read value from field on the right of "Reserve price" and save it as "reservePriceValue" with exact phrase
    And check that variable {reservePriceValue} contains "10000.00" with exact phrase
    And wait for "{anchor.bidder_lot_details_screen}"
    And check that screen does not contain "Reserve price" with exact phrase

Scenario: Contract pack v0.1 and forward auction vertical slice execute successfully
    And wait for "Auction Requests"
    And click "Create Auction Request"
    And wait for "New Auction Request"
    And enter "Auction_1" into "Title"
    And select "FORWARD" from list "Type"
    And click "Submit"
    And wait for "Auction Requests"
    And check that screen contains "Auction_1" with exact phrase
    And check that screen contains "Pending Approval" with exact phrase
    And click "Auction_1"
    And wait for "Auction Request Details"
    And click "Approve"
    And wait for "Auctions"
    And check that screen contains "Auction_1" with exact phrase
    And check that screen contains "FORWARD" with exact phrase
    And check that screen contains "Contract Pack v0.1" with exact phrase

Scenario: Atomic policy check immediately precedes destructive deletion actions
    And wait for "DOC-880"
    And click "DOC-880"
    And wait for "{anchor.delete_action}"
    And click "{anchor.delete_action}"
    And wait for "{anchor.deletion_confirmation_prompt}"
    And click "{anchor.confirm_delete}"
    And check that screen contains "protected by a hold" with exact phrase

Scenario: Local auctioneer governs document access and restricts global platform admin
    And wait for "{anchor.confidentialDocumentScreen}"
    And check that screen contains "{anchor.confidentialDocumentLabel}" with exact phrase
    And enter "{globalPlatformAdminUsername}" into "Username"
    And enter "{globalPlatformAdminPassword}" into "Password"
    And click "Login"
    And wait for "{anchor.platformAdminDashboard}"
    And click "{anchor.confidentialDocumentLink}"
    And check that screen contains "403 Forbidden" with exact phrase
    And check that screen does not contain "{anchor.confidentialDocumentContent}" with exact phrase
    And enter "{localAuctioneerOfficerUsername}" into "Username"
    And enter "{localAuctioneerOfficerPassword}" into "Password"
    And click "Login"
    And wait for "{anchor.localAuctioneerDashboard}"
    And click "{anchor.confidentialDocumentLink}"
    And check that screen contains "{anchor.confidentialDocumentContent}" with exact phrase

Scenario: Auctioneer organization operates with logically independent data and rulebooks
    And wait for "Auctioneer-North"
    And check that screen contains "Auctioneer-South" with exact phrase
    And click "Auctioneer-North"
    And wait for "{anchor.rulebook_settings}"
    And click "{anchor.rulebook_increments}"
    And wait for "{anchor.increments_section}"
    And click "{anchor.user_roles}"
    And wait for "{anchor.user_roles_section}"
    And click "{anchor.save_rulebook}"
    And wait for "{anchor.save_confirmation}"
    And click "Auctioneer-South"
    And wait for "{anchor.auctioneer_south_dashboard}"
    And check that screen contains "Auctioneer-South" with exact phrase
    And check that screen does not contain "{anchor.north_rulebook_change}" with exact phrase
    And check that screen does not contain "{anchor.north_user_role_change}" with exact phrase
    And click "{anchor.active_auctions}"
    And wait for "{anchor.active_auctions_section}"
    And check that screen contains "Auctioneer-South" with exact phrase
    And click "{anchor.user_list}"
    And wait for "{anchor.user_list_section}"
    And check that screen contains "Auctioneer-South" with exact phrase
    And click "{anchor.financial_audit_north}"
    And wait for "{anchor.audit_report_north}"
    And check that screen contains "Auctioneer-North" with exact phrase
    And check that screen does not contain "Auctioneer-South" with exact phrase
    And click "{anchor.financial_audit_south}"
    And wait for "{anchor.audit_report_south}"
    And check that screen contains "Auctioneer-South" with exact phrase
    And check that screen does not contain "Auctioneer-North" with exact phrase