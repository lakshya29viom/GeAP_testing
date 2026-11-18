# GeAP P0-P2 - ALL portals in ONE file (Auctioneer + Platform Admin + Bidder)
# SETUP in Studio app configuration (once):
#   App ID "default" -> Web, Chrome, http://92.5.41.53:6101/   (already there)
#   App ID "admin"   -> Web, Chrome, http://92.5.41.53:6102/   (add with the + below Default App Configuration)
#   App ID "bidder"  -> Web, Chrome, http://92.5.41.53:6100/   (add with +)
# Every scenario starts with "switch to app" so it runs on the right portal.
# Run the SMOKE scenario first: if it fails, the app IDs are not set up yet.
# Every Auctioneer scenario first re-selects tenant local-auctioneer-1, so one failed tenant-2 test cannot break the rest.
# Tags: @auctioneer @admin @bidder portal | @ready | @check-locator | @needs-data | @changes-data (run last, with mentor OK) | @added
# Data rule: only QA-* records, Auction_1, QA-TIME check and lot 239785. Rishi-Scrap-Test is never opened.

@regression @ui
Feature: GeAP P0-P2 - all portals

@smoke @setup
Scenario: SMOKE - Switch between the three portals
  And switch to app "default"
  And wait 3 sec
  And check that screen contains "Auctioneer Portal"
  And switch to app "admin"
  And wait 3 sec
  And check that screen contains "Platform Admin"
  And switch to app "bidder"
  And wait 3 sec
  And check that screen contains "Bidder Portal"
  And switch to app "default"

  # ####################################################################################
  # AUCTIONEER PORTAL (app "default" = http://92.5.41.53:6101)
  # ####################################################################################


@p0 @ready @auctioneer
Scenario: VIOM-949 - Select local auctioneer tenant for development and testing
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And check that screen contains "Select a local auctioneer tenant and verify tenancy context."
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And check that screen contains "deploymentId"
  And check that screen contains "local-auctioneer-1"
  And check that screen contains "auctioneer-local-1"
  And capture screenshot

@p0 @ready @auctioneer
Scenario: VIOM-947 - Configure multiple local auctioneers and resolve tenant context
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Expected result made checkable: tenant 2 must not show tenant 1 requests. Test switches back to tenant 1 at the end.
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-2" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And check that screen contains "auctioneer-local-2"
  And click "Auction requests"
  And wait 3 sec
  And check that screen does not contain "QA-TIME check"
  And check that screen does not contain "Auction_1"
  And capture screenshot
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And check that screen contains "auctioneer-local-1"

@p1 @ready @auctioneer
Scenario: VIOM-414 - Capture primary business contact details for auctioneer organization
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: No new values typed: the record is shared, so the test re-saves the existing contact and checks nothing changed. "Edit primary business contact" is a pencil icon, not a labelled button.
  And press ESCAPE
  And wait 2 sec
  And click "Organization"
  And wait 3 sec
  And check that screen contains "Primary business contact"
  And read value from field on the right of "Email" and save it as "emailBefore"
  And click on the element to the right of "Primary business contact"
  And wait 2 sec
  And check that screen contains "Edit primary business contact"
  And check that screen contains "Capture the organisation primary contact used for auctioneer communications."
  And click "Save" with exact phrase
  And wait 2 sec
  And check that screen contains "{emailBefore}"
  And check that screen contains "+91 123456789"
  And capture screenshot

@p1 @ready @auctioneer
Scenario: VIOM-439 - Create or update auction drafts and lots as Auction Officer
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Title changed from "QA-TIME check" to a generated QA-DRAFT name: "QA-TIME check" already exists, so a second one would make the list ambiguous.
  And generate "QA-DRAFT-[A-Z]{4}[0-9]{4}" and save it as "draftTitle"
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And check that screen contains "New auction request"
  And type "{draftTitle}"
  And enter "Time zone check" into field on the below of "Description"
  And select "FORWARD" from list "Auction type"
  And enter "Initial draft notes" into field on the below of "Notes"
  And click "Save" with exact phrase
  And wait 2 sec
  And check that screen contains "{draftTitle}"
  And click "{draftTitle}"
  And wait 3 sec
  And check that screen contains "This request has not been submitted for Platform Admin review yet."
  And check that screen contains "version 1"
  And check that screen contains "Initial draft notes"
  And capture screenshot

@p1 @check-locator @auctioneer
Scenario: VIOM-955 - Validate lot completeness and readiness before confirmation
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Added the 7th checklist item seen on screen: "Specification or supporting attachment". "eligible for admin review" is not shown anywhere, so not checked.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And click "239785 — Nuts"
  And wait 3 sec
  And check that screen contains "Identity, quantity, and required attributes."
  And check that screen contains "Readiness"
  And check that screen contains "Ready"
  And check that screen contains "Lot number"
  And check that screen contains "Quantity (greater than zero)"
  And check that screen contains "Unit"
  And check that screen contains "Specifications text"
  And check that screen contains "Specification or supporting attachment"
  And check that screen contains "Inspection details · not required"
  And capture screenshot

@p1 @ready @auctioneer
Scenario: VIOM-2362 - Auctioneer requests and monitoring without direct operational rights
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Review Platform Admin configuration and confirm the exact rulebook version."
  And check that screen contains "QA-TIME check"
  And check that screen contains "Published"
  And check that screen does not contain "Pause"
  And check that screen does not contain "Stop"
  And capture screenshot

@p0 @ready @auctioneer
Scenario: VIOM-2133 - Verify data protection privacy and tenant isolation
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Original called an API for tenant 2 (not possible in UI). UI version: tenant 2 sees none of tenant 1 organization, requests or auctions.
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-2" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And click "Organization"
  And wait 3 sec
  And check that screen does not contain "lakshya"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen does not contain "QA-TIME check"
  And capture screenshot
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec

@p2 @check-locator @auctioneer
Scenario: VIOM-1357 - Prevent unauthorized actions for auctioneer roles
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Same check as VIOM-863 on the auctioneer side; "Self-publish/Self-configure/Grant roles" buttons do not exist.
  And press ESCAPE
  And wait 2 sec
  And click "Auctions" with exact phrase
  And wait 3 sec
  And click "Open"
  And wait 3 sec
  And check that screen does not contain "Publish auction"
  And check that screen does not contain "Begin amendment"
  And check that screen does not contain "Withdraw publication"
  And capture screenshot

@p2 @needs-data @auctioneer
Scenario: VIOM-908 - Submit auction for publication approval through Core system
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: "Submit for review" is the real button. Needs your own READY draft.
  # Needs a Draft request of yours with a READY lot (lot + specification attachment). Replace QA-SUB-READY with its title.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-SUB-READY"
  And wait 3 sec
  And click "Submit for review"
  And wait 3 sec
  And check that screen contains "Awaiting Platform Admin review"
  And check that screen contains "Submitted for Platform Admin review"
  And check that screen contains "version 2"
  And capture screenshot

@p2 @check-locator @auctioneer
Scenario: VIOM-863 - Restrict auction publication to Platform Admins only
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: No disabled Publish button with tooltip exists for the auctioneer: the control is simply absent. Changed to "no publish/amend/withdraw controls".
  And press ESCAPE
  And wait 2 sec
  And click "Auctions" with exact phrase
  And wait 3 sec
  And click "Open"
  And wait 3 sec
  And check that screen does not contain "Publish auction"
  And check that screen does not contain "Begin amendment"
  And check that screen does not contain "Withdraw publication"
  And capture screenshot

@p0 @check-locator @auctioneer
Scenario: VIOM-738 - Upload new document version preserving historical versions
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Only opens the Attach dialog and records it: the real upload/version flow has not been seen. Needs a test PDF and the dialog labels to finish.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And click "239785 — Nuts"
  And wait 3 sec
  And check that screen contains "Identity, quantity, and required attributes."
  And check that screen contains "Lot documents"
  And check that screen contains "GeAP_Milestone1_One_Pager 2.pdf"
  And click "Attach"
  And wait 2 sec
  And capture screenshot
  And press ESCAPE

@p0 @check-locator @auctioneer
Scenario: VIOM-737 - Download document version with re-checked authorization
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: There is no "Download v1" button; the file name is the link. Check by hand that a download or preview starts.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And click "239785 — Nuts"
  And wait 3 sec
  And check that screen contains "Identity, quantity, and required attributes."
  And click "GeAP_Milestone1_One_Pager 2.pdf"
  And wait 3 sec
  And capture screenshot

@p0 @ready @auctioneer
Scenario: VIOM-700 - Ensure core business records maintain minimum logical content
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Real behaviour: Save becomes disabled. There is no inline "Legal name is required" message.
  And press ESCAPE
  And wait 2 sec
  And click "Organization"
  And wait 3 sec
  And read value from field on the right of "Legal name" and save it as "legalBefore"
  And click on the element to the right of "Organization identity"
  And wait 2 sec
  And check that screen contains "Edit organization identity"
  And enter "" into field on the below of 2nd "Legal name"
  And check that button "Save" is disabled with exact phrase
  And capture screenshot
  And click "Cancel"
  And wait 1 sec
  And check that screen contains "{legalBefore}"

@p1 @ready @auctioneer
Scenario: VIOM-694 - Validate standard document pack presence for auction publication
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: FINDING: QA-TIME check was approved and published with 4 document roles still missing. Ask whether the document pack should block approval or publication (VIOM-694).
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "4 document roles are missing"
  And check that screen contains "No documents attached yet."
  And capture screenshot

@p0 @ready @auctioneer
Scenario: VIOM-628 - Ensure tenant isolation across database and API queries
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Same check as the tenant-isolation scenario, through the UI.
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-2" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  And click "Organization"
  And wait 3 sec
  And check that screen does not contain "lakshya"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen does not contain "QA-TIME check"
  And capture screenshot
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec

@p1 @ready @auctioneer
Scenario: VIOM-524 - Auctioneer submits request to create an auction with required fields
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Real behaviour: Save stays disabled; there is no "Title is required" message.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And enter "Description only" into field on the below of "Description"
  And check that button "Save" is disabled with exact phrase
  And capture screenshot
  And click "Cancel"

@p1 @ready @auctioneer
Scenario: VIOM-480 - Tracking auction approvals with comprehensive audit details
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Hard-coded date/decision only valid for this record.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "Approved"
  And check that screen contains "64564"
  And check that screen contains "platform-admin"
  And check that screen contains "17/11/2026, 00:37:19"
  And capture screenshot

@p1 @needs-data @auctioneer
Scenario: VIOM-461 - Auctioneer submits auction request with necessary documents
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: QA-TIME check was submitted with "4 document roles are missing", so documents are NOT required to submit; READY lots are. Changed to test the block when there are no lots.
  And generate "QA-SUB-[A-Z]{4}[0-9]{4}" and save it as "subTitle"
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And type "{subTitle}"
  And enter "Submit flow test" into field on the below of "Description"
  And click "Save" with exact phrase
  And wait 2 sec
  And click "{subTitle}"
  And wait 3 sec
  And click "Submit for review"
  And wait 3 sec
  And capture screenshot
  And check that screen contains "Draft"
  # A request with NO lots must not submit. To test the success path add a READY lot with an attachment first.

@p1 @check-locator @auctioneer
Scenario: VIOM-460 - Preserve and validate auction draft edits with version history
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Expected "v2" after a draft edit is an assumption: on this app the version went up on submit/approve, not visibly on edit. Test captures it for you to compare.
  And generate "QA-EDIT2-[A-Z]{4}[0-9]{4}" and save it as "editNote"
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "Auction_1"
  And wait 3 sec
  And click on the element to the left of "Submit for review"
  And wait 2 sec
  And enter "" into field on the below of "Notes"
  And enter "{editNote}" into field on the below of "Notes"
  And click "Save" with exact phrase
  And wait 3 sec
  And check that screen contains "{editNote}"
  And check that screen contains "Status history"
  And capture screenshot
  # Compare the version shown (version 1 or 2) with the expected behaviour: ask whether a draft edit bumps the version.

@p1 @ready @auctioneer
Scenario: VIOM-443 - Support primary auction types forward and reverse
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Both options selected once. Also open the list by hand once to confirm there are no other options.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And select "REVERSE" from list "Auction type"
  And select "FORWARD" from list "Auction type"
  And capture screenshot
  And click "Cancel"

@p1 @check-locator @auctioneer
Scenario: VIOM-441 - Auctioneer confirms material prepublication configurations
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Already confirmed and published, so the Confirm button cannot be clicked again. Test records the page; the confirm click needs a new auction.
  And press ESCAPE
  And wait 2 sec
  And click "Auctions" with exact phrase
  And wait 3 sec
  And click "Open"
  And wait 3 sec
  And capture screenshot
  # QA-TIME check is already confirmed and published, so "Confirm configuration" will not be offered.
  # Record the confirmed rulebook version shown on this page.

@p1 @ready @auctioneer
Scenario: VIOM-440 - Manage auction request state transitions with preserved reasons
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Checks the approval already made on QA-TIME check (read only).
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "Approved"
  And check that screen contains "64564"
  And check that screen contains "platform-admin"
  And check that screen contains "version 3"
  And check that screen does not contain "Submit for review"
  And capture screenshot

@p1 @ready @auctioneer
Scenario: VIOM-438 - Manage governed auction request versions and corrections tracking
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: History reads "Created → Draft v1", "Draft → Submitted v2", "Submitted → Approved v3" with arrows; the test checks the words on each step.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "Status history"
  And check that screen contains "Auction request created"
  And check that screen contains "Submitted for Platform Admin review"
  And check that screen contains "64564"
  And check that screen contains "v3"
  And capture screenshot

@p1 @check-locator @auctioneer
Scenario: VIOM-433 - Auctioneer initiates and revises auction requests and requirements
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Editing the title to "QA-TIME check" would duplicate an existing title. Changed to editing Notes on Auction_1 (a Draft); edit opens from the pencil icon.
  And generate "QA-EDIT-[A-Z]{4}[0-9]{4}" and save it as "editTitle"
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "Auction_1"
  And wait 3 sec
  And click on the element to the left of "Submit for review"
  And wait 2 sec
  And enter "" into field on the below of "Notes"
  And enter "{editTitle}" into field on the below of "Notes"
  And click "Save" with exact phrase
  And wait 3 sec
  And check that screen contains "{editTitle}"
  And capture screenshot

@p1 @check-locator @auctioneer
Scenario: VIOM-421 - Support configured pricing and currency per lot
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: The lot page shows Currency INR and quantity 100 MT. Starting price 5000 is on the Admin rulebook, not the lot, so it is checked in the Admin file.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And click "239785 — Nuts"
  And wait 3 sec
  And check that screen contains "Identity, quantity, and required attributes."
  And check that screen contains "INR"
  And check that screen contains "100 MT"
  And check that screen contains "239785"
  And capture screenshot

@p1 @ready @auctioneer
Scenario: VIOM-414 - Capture primary contact details with comprehensive validations
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Original only re-entered valid data. Changed to the validation it promises: Save is disabled when the required Email is empty.
  And press ESCAPE
  And wait 2 sec
  And click "Organization"
  And wait 3 sec
  And click on the element to the right of "Primary business contact"
  And wait 2 sec
  And enter "" into field on the below of 2nd "Email"
  And check that button "Save" is disabled with exact phrase
  And capture screenshot
  And click "Cancel"

@p1 @check-locator @auctioneer
Scenario: VIOM-411 - Integrate lot pricing and allocation features into catalogue
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Changed: Starting price is not on the lot page (see Admin file).
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Auctioneer Portal"
  And click "Auction requests"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And click "239785 — Nuts"
  And wait 3 sec
  And check that screen contains "Identity, quantity, and required attributes."
  And check that screen contains "239785"
  And check that screen contains "Nuts"
  And check that screen contains "100 MT"
  And check that screen contains "Location"
  And capture screenshot

@p1 @needs-data @added @auctioneer
Scenario: VIOM-497 - Rejected request keeps its record and reason
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: VIOM-497 had no scenario.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "Rejected" with exact phrase
  And wait 2 sec
  And capture screenshot
  # When one of your QA- requests is rejected: open it, check the reason is shown and Submit for review is gone.

@p1 @needs-data @added @auctioneer
Scenario: VIOM-499 - Double-click on Submit for review changes status only once
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: VIOM-499 had no scenario.
  # Needs your own Draft with a READY lot. Replace QA-SUB-READY.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "QA-SUB-READY"
  And wait 3 sec
  And double click "Submit for review"
  And wait 3 sec
  And check that screen contains "Awaiting Platform Admin review"
  And capture screenshot
  # Status history must show ONE "Draft -> Submitted" entry.

@p1 @needs-screen @added @auctioneer
Scenario: VIOM-428 - Bidder eligibility criteria are captured in the request
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: VIOM-428 had no scenario; the field is not in the UI yet.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "Auction_1"
  And wait 3 sec
  And capture screenshot
  # No eligibility-criteria field exists on the request today. Ask where auctioneers define bidder criteria.

@p0 @ready @added @auctioneer
Scenario: VIOM-662 - Script in a new request title is stored as text
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: No security input test in the list.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And type "QA-XSS-IMG <img src=x onerror=alert(1)>"
  And enter "XSS check" into field on the below of "Description"
  And click "Save" with exact phrase
  And wait 2 sec
  And check that screen contains "onerror"
  And capture screenshot
  # By hand: a browser popup = stored XSS bug. Also open it in Platform Admin > Review inbox > All statuses.

@p0 @ready @added @auctioneer
Scenario: VIOM-662 - Spaces-only title keeps Save disabled
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: Boundary case missing.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And type "     "
  And enter "Spaces only" into field on the below of "Description"
  And check that button "Save" is disabled with exact phrase
  And click "Cancel"

@p1 @ready @added @auctioneer
Scenario: VIOM-433 - Cancel on New auction request saves nothing
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: Cancel path missing.
  And generate "QA-CANCEL-[A-Z]{4}[0-9]{4}" and save it as "cTitle"
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And type "{cTitle}"
  And enter "Never saved" into field on the below of "Description"
  And click "Cancel"
  And wait 2 sec
  And check that screen does not contain "{cTitle}"

@p1 @ready @added @auctioneer
Scenario: VIOM-438 - Search and status tabs on Auction requests
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: List search/filter not covered.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And enter "QA-TIME" into field on the below of "Draft"
  And wait 2 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Auction_1"
  And enter "" into field on the below of "Draft"
  And click "Approved" with exact phrase
  And wait 2 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Auction_1"
  And click "Draft" with exact phrase
  And wait 2 sec
  And check that screen contains "Auction_1"
  And check that screen does not contain "QA-TIME check"
  And click "All" with exact phrase

@p1 @check-locator @added @auctioneer
Scenario: VIOM-439 - New lot Save stays disabled until Lot number and Title are filled
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: Lot form validation missing.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "Auction_1"
  And wait 3 sec
  And click on the element to the right of "Add lots here, then open a lot to edit details and attach specification documents."
  And wait 2 sec
  And check that screen contains "New lot"
  And check that button "Save" is disabled with exact phrase
  And enter "QA-LOT-ONLY" into field on the below of "Lot number"
  And check that button "Save" is disabled with exact phrase
  And click "Cancel"

@p1 @check-locator @added @auctioneer
Scenario: VIOM-572 - Lot quantity 0 is not accepted
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: Boundary for the readiness rule.
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "Auction_1"
  And wait 3 sec
  And click on the element to the right of "Add lots here, then open a lot to edit details and attach specification documents."
  And wait 2 sec
  And enter "QA-LOT-Q0" into field on the below of "Lot number"
  And enter "Quantity zero" into field on the below of 2nd "Title"
  And enter "0" into field on the below of "Quantity"
  And click "Save" with exact phrase
  And wait 3 sec
  And capture screenshot
  # Checklist says "Quantity (greater than zero)": a lot with 0 must be refused or shown not ready.

@p1 @check-locator @added @auctioneer
Scenario: VIOM-440 - Auctioneer withdraws a draft
  And switch to app "default"
  And wait 2 sec
  And press ESCAPE
  And click "Home"
  And wait 2 sec
  And select "local-auctioneer-1" from list "Local auctioneer tenant"
  And click "Load tenant context"
  And wait 2 sec
  # Added: Withdraw path missing.
  And generate "QA-WD-[A-Z]{4}[0-9]{4}" and save it as "wdTitle"
  And press ESCAPE
  And wait 2 sec
  And click "Auction requests"
  And wait 2 sec
  And click "New request"
  And wait 2 sec
  And type "{wdTitle}"
  And enter "Withdraw test" into field on the below of "Description"
  And click "Save" with exact phrase
  And wait 2 sec
  And click "{wdTitle}"
  And wait 3 sec
  And click "Withdraw"
  And wait 2 sec
  And capture screenshot
  # If a reason box opens, fill it and confirm, then check the status is Withdrawn.

# ####################################################################################
# PLATFORM ADMIN (app "admin" = http://92.5.41.53:6102)
# ####################################################################################


@p1 @check-locator @admin
Scenario: VIOM-448 - Platform Admin activates and configures auctioneer organizations
  And switch to app "admin"
  And wait 2 sec
  # Changed: Deployment registry page not seen yet: the test records it. Check ACTIVE in the screenshot.
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And check that screen contains "Select a local auctioneer deployment for the review inbox."
  And select "local-auctioneer-1" from list "Local auctioneer deployment"
  And click "Deployment registry"
  And wait 3 sec
  And check that screen contains "local-auctioneer-1"
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-842 - Publish auction by Platform Admin with frozen snapshot
  And switch to app "admin"
  And wait 2 sec
  # Changed: Original clicked "Save rulebook" to publish. That button saves the rulebook; it does not publish, and it is disabled once published. Changed to verifying the published state.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Publication readiness"
  And check that screen contains "Published snapshot v1"
  And check that screen contains "PUBLISHED v1"
  And check that screen contains "platform-admin"
  And check that screen contains "Published"
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-1555 - Manage auctions lifecycle state transitions by Platform Admin
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Rulebook"
  And check that screen contains "Publication readiness"
  And check that screen contains "Qualification"
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-944 - Evaluate bidder eligibility at event and lot level
  And switch to app "admin"
  And wait 2 sec
  # Changed: No bidder has applied yet, so only the empty Qualification panel can be checked.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Qualification"
  And check that screen contains "Review bidder checks and issue or revoke bid-access grants."
  And check that screen contains "No qualification submissions yet."
  And capture screenshot

@p2 @changes-data @admin
Scenario: VIOM-940 - Support review and amendment for auction event publications
  And switch to app "admin"
  And wait 2 sec
  # Changed: CHANGES DATA: starts an amendment on QA-TIME check. Run only after the read-only checks, with your mentor's OK.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And enter "QA amendment test" into "Why amend the published auction?"
  And click "Begin amendment"
  And wait 3 sec
  And check that screen contains "Published snapshot v1"
  And capture screenshot

@p2 @needs-data @admin
Scenario: VIOM-900 - Auctioneer registration and eligibility projection
  And switch to app "admin"
  And wait 2 sec
  # Changed: Auctioneer enrollment approval; "eligibility projection" is not visible in UI.
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And click "Submitted" with exact phrase
  And wait 2 sec
  # Only act on a registration YOU created (QA-...).
  And click "QA-"
  And wait 2 sec
  And click "Approve"
  And wait 3 sec
  And click "Approved" with exact phrase
  And wait 2 sec
  And capture screenshot

@p2 @needs-data @admin
Scenario: VIOM-891 - Manage bidder eligibility granting and revocation at lot level
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Qualification"
  And check that screen contains "Review bidder checks and issue or revoke bid-access grants."
  And check that screen contains "No qualification submissions yet."
  And capture screenshot
  # When a bidder submission exists: approve it, then revoke and check the status.

@p2 @ready @admin
Scenario: VIOM-878 - Publish auction-specific currency fees and reserve rules
  And switch to app "admin"
  And wait 2 sec
  # Changed: Snapshot shows "300", not "300.0000"; the rulebook form shows "300.0000".
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Indian Rupee (INR)"
  And check that screen contains "MIN PRICE STEP"
  And check that screen contains "300"
  And capture screenshot

@p2 @needs-data @admin
Scenario: VIOM-872 - Platform Admin approves or denies bidder participation
  And switch to app "admin"
  And wait 2 sec
  # Changed: "bidder-local-1" is not a known name; acts only on your own QA- registration.
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And click "Submitted" with exact phrase
  And wait 2 sec
  # Only act on a registration YOU created (QA-...).
  And click "QA-"
  And wait 2 sec
  And click "Approve"
  And wait 3 sec
  And click "Approved" with exact phrase
  And wait 2 sec
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-856 - Review and approve bidder eligibility with audit timestamp
  And switch to app "admin"
  And wait 2 sec
  # Changed: No registrations exist yet. Approval with audit timestamp needs a submitted enrollment.
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And check that screen contains "Approve or reject SUBMITTED auctioneer enrollments. This does not by itself make a bidder bid-ready."
  And click "Submitted" with exact phrase
  And wait 2 sec
  And capture screenshot

@p2 @changes-data @admin
Scenario: VIOM-847 - Auction unpublishing removes public listing via tombstone replay
  And switch to app "admin"
  And wait 2 sec
  # Changed: CHANGES DATA: removes QA-TIME check from the catalogue and breaks the Bidder tests. Run LAST, only if agreed.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And enter "QA withdraw test" into "Why withdraw this listing?"
  And click "Withdraw publication"
  And wait 3 sec
  And check that screen contains "Withdrawn"
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-842 - Publish confirmed auction retaining approved configuration version
  And switch to app "admin"
  And wait 2 sec
  # Changed: Publish already happened; this verifies the published version equals confirmed version 1.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "confirmed_rulebook"
  And check that screen contains "Confirmed rulebook version 1 is recorded"
  And check that screen contains "rulebook_digest_match"
  And check that screen contains "Published snapshot v1"
  And capture screenshot

@p2 @needs-data @admin
Scenario: VIOM-841 - Platform Admin reviews and approves bidder eligibility
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And click "Submitted" with exact phrase
  And wait 2 sec
  # Only act on a registration YOU created (QA-...).
  And click "QA-"
  And wait 2 sec
  And click "Approve"
  And wait 3 sec
  And click "Approved" with exact phrase
  And wait 2 sec
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-839 - Enforce publication readiness checklist with mandatory sign-off
  And switch to app "admin"
  And wait 2 sec
  # Changed: Missing-check case (Publish stays disabled) needs a new, unconfirmed auction.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Auctioneer confirmation is the mandatory sign-off."
  And check that screen contains "auctioneer_confirmation"
  And check that screen contains "confirmed_rulebook"
  And check that screen contains "rulebook_digest_match"
  And check that screen contains "schedule_present"
  And check that screen contains "lots_ready"
  And capture screenshot

@p2 @ready @admin
Scenario: VIOM-838 - Platform Admin grants publication access permission
  And switch to app "admin"
  And wait 2 sec
  # Changed: "Notifies the auctioneer" is not visible in the UI.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Published snapshot v1"
  And check that screen contains "published by platform-admin"
  And capture screenshot

@p0 @ready @admin
Scenario: VIOM-772 - Record comprehensive decision details in audit records
  And switch to app "admin"
  And wait 2 sec
  # Changed: The UI shows reason, actor and time. Requirements hash and policy version are not shown: check them in the API/DB.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 2 sec
  And click "All statuses"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "64564"
  And check that screen contains "platform-admin"
  And check that screen contains "Status history"
  And capture screenshot

@p0 @ready @admin
Scenario: VIOM-705 - Maintain tamper-evident and immutable audit records
  And switch to app "admin"
  And wait 2 sec
  # Changed: UI part only: history entries are listed and cannot be edited. Deleting rows needs DB access.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 2 sec
  And click "All statuses"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "64564"
  And check that screen contains "platform-admin"
  And check that screen contains "Status history"
  And capture screenshot

@p0 @ready @admin
Scenario: VIOM-637 - Implement synchronized timestamps on immutable audit records
  And switch to app "admin"
  And wait 2 sec
  # Changed: Synchronised NTP time cannot be seen in the UI.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 2 sec
  And click "All statuses"
  And wait 2 sec
  And click "QA-TIME check"
  And wait 3 sec
  And check that screen contains "64564"
  And check that screen contains "platform-admin"
  And check that screen contains "Status history"
  And capture screenshot
  # FINDING (VIOM-798): times are shown without a time zone.

@p1 @ready @admin
Scenario: VIOM-489 - Validate auction design readiness checks before approval
  And switch to app "admin"
  And wait 2 sec
  # Changed: Waiver flow does not exist; on a published auction validation is disabled.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that button "Validate for confirmation" is disabled
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-477 - Create and configure auctions enforcing configured rulebook
  And switch to app "admin"
  And wait 2 sec
  # Changed: Auction is published, so the rulebook is read-only (Save rulebook disabled). Saving new dates needs an auction still in Configuring.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Scheduled open"
  And check that screen contains "18/11/2026, 00:40:00"
  And check that screen contains "03/12/2026, 00:40:00"
  And check that button "Save rulebook" is disabled
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-463 - Administrator can manage auction events and lots hierarchy
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "1 associated lot"
  And check that screen contains "239785 — Nuts"
  And check that screen contains "100 MT"
  And check that screen contains "Ready"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-457 - Manage auction configuration with immutable snapshots
  And switch to app "admin"
  And wait 2 sec
  # Changed: Checks only the first 8 characters of the digest, so it survives layout changes.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "INTEGRITY DIGEST"
  And check that screen contains "3371d054"
  And check that screen contains "Operative configuration matches the confirmed rulebook digest"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-455 - Auction configuration confirmation and publication workflow
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Auctioneer confirmation is the mandatory sign-off."
  And check that screen contains "auctioneer_confirmation"
  And check that screen contains "confirmed_rulebook"
  And check that screen contains "rulebook_digest_match"
  And check that screen contains "schedule_present"
  And check that screen contains "lots_ready"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-454 - Manage bid visibility with disclosure policy enforcing sealed bids
  And switch to app "admin"
  And wait 2 sec
  # Changed: What bidders actually see under "Partial" needs live bidding (P3).
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Bid visibility"
  And check that screen contains "Partial"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-449 - Freeze normalized rule snapshot and hash upon approval
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "INTEGRITY DIGEST"
  And check that screen contains "Frozen at"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-442 - Review auction requests submitted by Auctioneers in Review inbox
  And switch to app "admin"
  And wait 2 sec
  # Changed: Removed "Rishi-Scrap-Test" (someone else's request). Uses QA-TIME check under "All statuses" instead.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 3 sec
  And check that screen contains "Submitted and resubmitted auction requests awaiting Platform Admin clarify, approve, or reject"
  And check that screen contains "Pending review"
  And click "All statuses"
  And wait 2 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "64564"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-437 - Ensure completeness of auction rulebook fields
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that checkbox "Bidder eligibility required" is checked
  And check that screen contains "Provisional result enabled (always required; not configurable)."
  And check that screen contains "Award requires auctioneer approval (always required; not configurable)."
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-435 - Capture essential auction details for auction rulebook
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "UTC"
  And check that screen contains "Indian Rupee (INR)"
  And check that screen contains "5000"
  And check that screen contains "Forward"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-434 - System management of timezone notices documents and reservations
  And switch to app "admin"
  And wait 2 sec
  # Changed: Countdowns/notices sync cannot be seen yet.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Timezone"
  And check that screen contains "UTC"
  And check that screen contains "18/11/2026, 00:40:00"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-417 - Platform Admin configures auction rules for bidding and awards
  And switch to app "admin"
  And wait 2 sec
  # Changed: Values already saved and the auction is published, so this verifies them instead of changing them.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Partial"
  And check that screen contains "HIGHEST_PRICE"
  And check that checkbox "Bidder eligibility required" is checked
  And check that button "Save rulebook" is disabled
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-423 - GeAP Platform Admin auction management and live interventions
  And switch to app "admin"
  And wait 2 sec
  # Changed: "Pause auction" and a live control console do not exist yet (P3). Kept as a check that the Configure screen opens.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Rulebook"
  And check that screen does not contain "Pause auction"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-420 - Configure currencies and locked rate policy for validated draft
  And switch to app "admin"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Indian Rupee (INR)"
  And check that screen contains "300.0000"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-419 - Reserve price management and confidentiality before auction start
  And switch to app "admin"
  And wait 2 sec
  # Changed: Confidential numeric reserve needs a configuring auction; catalogue side is checked in the Bidder file.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "RESERVE / TARGET"
  And check that screen contains "Disabled"
  And capture screenshot

@p1 @ready @admin
Scenario: VIOM-417 - Define rules for forward ascending-price auction
  And switch to app "admin"
  And wait 2 sec
  # Changed: "Enforced during live bidding" needs P3; this checks the saved rules.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Platform Admin"
  And click "Auctions" with exact phrase
  And wait 3 sec
  And check that screen contains "Configured auctions"
  And click "Configure" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "300.0000"
  And check that screen contains "HIGHEST_PRICE"
  And check that screen contains "FORWARD_OPEN_ASCENDING"
  And check that screen contains "Disabled"
  And capture screenshot

@p2 @needs-screen @added @admin
Scenario: VIOM-946 - Terms acceptance and participation status appear in reports
  And switch to app "admin"
  And wait 2 sec
  # Added: VIOM-946 had no scenario.
  And press ESCAPE
  And wait 2 sec
  And capture screenshot
  # No reports page exists in Platform Admin yet.

@p1 @ready @added @admin
Scenario: VIOM-442 - Pending review hides decided requests
  And switch to app "admin"
  And wait 2 sec
  # Added: Review inbox filter not covered.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 3 sec
  And click "Pending review"
  And wait 2 sec
  And check that screen does not contain "QA-TIME check"
  And check that screen does not contain "Auction_1"
  And click "All statuses"
  And wait 2 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "Auction_1"

@p1 @ready @added @admin
Scenario: VIOM-442 - Review inbox search
  And switch to app "admin"
  And wait 2 sec
  # Added: Search not covered.
  And press ESCAPE
  And wait 2 sec
  And click "Review inbox"
  And wait 3 sec
  And click "All statuses"
  And wait 2 sec
  And enter "QA-TIME" into field on the below of "All statuses"
  And wait 2 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Auction_1"

@p2 @ready @added @admin
Scenario: VIOM-856 - Registrations tabs open
  And switch to app "admin"
  And wait 2 sec
  # Added: Admin Registrations not covered.
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And click "Submitted" with exact phrase
  And wait 1 sec
  And click "Approved" with exact phrase
  And wait 1 sec
  And click "Rejected" with exact phrase
  And wait 1 sec
  And click "All" with exact phrase
  And check that screen contains "Auctioneer enrollments"

# ####################################################################################
# BIDDER PORTAL (app "bidder" = http://92.5.41.53:6100)
# ####################################################################################


@p0 @check-locator @bidder
Scenario: VIOM-950 - Switch bidder to auctioneer context and resolve local routes
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Result panel not seen yet; read the screenshot to set exact checks.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Gateway route"
  And wait 2 sec
  And check that screen contains "Select an auctioneer deployment and resolve its trusted dedicated gateway."
  And check that screen contains "No switch run yet."
  And select "local-auctioneer-1" from list "Auctioneer deployment"
  And click "Switch context & resolve route"
  And wait 3 sec
  And check that screen does not contain "No switch run yet."
  And check that screen contains "local-auctioneer-1"
  And capture screenshot

@p2 @ready @bidder
Scenario: VIOM-853 - Unified Bidder Portal auction discovery through global catalog
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Search box has no "Search" label; its placeholder is "Title, type, deployment, or auction id".
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And enter "QA-TIME check" into "Title, type, deployment, or auction id"
  And select "Any" from list "Type"
  And select "All deployments" from list "Deployment"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen contains "ACTIVE · not bid-ready"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-945 - Restrict reserve access in auction catalogue
  And switch to app "bidder"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And check that screen does not contain "Reserve"
  And check that screen does not contain "RESERVE"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-926 - Separate public discovery from authenticated participation
  And switch to app "bidder"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Place bid"
  And capture screenshot

@p2 @ready @bidder
Scenario: VIOM-917 - Prevent implication of live auctions on public listings
  And switch to app "bidder"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And check that screen contains "QA-TIME check"
  And check that screen contains "ACTIVE · not bid-ready"
  And check that screen contains "Listings are a global projection and are not bid-ready."
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-884 - Protect sensitive data in public auction listings
  And switch to app "bidder"
  And wait 2 sec
  # Changed: "Excluded from the payload" also needs a check in DevTools/Network.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And check that screen does not contain "Reserve"
  And check that screen does not contain "RESERVE"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-879 - Maintain read-only auction catalog projection
  And switch to app "bidder"
  And wait 2 sec
  # Changed: A PUT request cannot be sent from the UI; this checks there are no edit controls.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Place bid"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-853 - Discover separate sections for forward reverse and special auctions
  And switch to app "bidder"
  And wait 2 sec
  # Changed: No separate sections exist today.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And capture screenshot
  # Expected Forward / Reverse / Special sections do not exist: the catalogue is one list with a Type filter. Likely FAIL - ask the BA.

@p2 @check-locator @bidder
Scenario: VIOM-845 - Complete auction registration through explicit application
  And switch to app "bidder"
  And wait 2 sec
  # Changed: "Register" is on the auction detail page (the Registrations page says so). Creates an enrollment for this bidder.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And click "Register"
  And wait 3 sec
  And capture screenshot
  And click "Registrations"
  And wait 3 sec
  And check that screen does not contain "No enrollments yet"
  And capture screenshot

@p2 @ready @bidder
Scenario: VIOM-837 - Indicate data freshness in catalog records
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Exact sync time changes every refresh, so only "Synced" is checked.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And check that screen contains "Synced"
  And check that screen contains "rev 1"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-835 - Unified Bidder Portal auction search and filtering
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Added the negative half: a Reverse filter must hide the Forward auction. Type option labels not seen; check if it fails.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And select "Forward" from list "Type"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And select "Reverse" from list "Type"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen does not contain "QA-TIME check"
  And capture screenshot

@p2 @ready @bidder
Scenario: VIOM-834 - Search and browse events with keyword queries
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Searching "Nuts" assumes lot titles are searchable; placeholder says title, type, deployment or auction id. Changed to a title search plus a no-match search.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And enter "zzz-no-match-999" into "Title, type, deployment, or auction id"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen does not contain "QA-TIME check"
  And enter "QA-TIME" into "Title, type, deployment, or auction id"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And capture screenshot

@p2 @ready @bidder
Scenario: VIOM-831 - Display auction categories on public home page
  And switch to app "bidder"
  And wait 2 sec
  # Changed: No category tiles exist on Bidder Home.
  And press ESCAPE
  And wait 2 sec
  And click "Home"
  And wait 2 sec
  And check that screen contains "Resolve a trusted dedicated gateway for an auctioneer deployment"
  And capture screenshot
  # Category tiles (Live / Upcoming / Completed) are not on the Bidder Home page. Likely FAIL - ask the BA.

@p2 @ready @bidder
Scenario: VIOM-827 - Explore auction information and registration details as guest
  And switch to app "bidder"
  And wait 2 sec
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And check that screen contains "Opens 18 Nov 2026, 00:40"
  And check that screen contains "Closes 3 Dec 2026, 00:40"
  And capture screenshot

@p2 @check-locator @bidder
Scenario: VIOM-824 - Public read-only access to global auction catalog
  And switch to app "bidder"
  And wait 2 sec
  # Changed: Auction detail page not seen yet.
  And press ESCAPE
  And wait 2 sec
  And check that screen contains "Bidder Portal"
  And click "Catalogue"
  And wait 3 sec
  And check that screen contains "Public auctions across auctioneer deployments."
  And click "Open"
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And check that screen does not contain "Place bid"
  And capture screenshot

@p2 @check-locator @added @bidder
Scenario: VIOM-823 - Bidder participation process from catalogue to registration
  And switch to app "bidder"
  And wait 2 sec
  # Added: VIOM-823 had no scenario.
  And press ESCAPE
  And wait 2 sec
  And click "Registrations"
  And wait 3 sec
  And check that screen contains "enrollment never authorizes bidding"
  And check that screen contains "No enrollments yet"
  And click "Find an auction"
  And wait 3 sec
  And check that screen contains "Catalogue"
  And capture screenshot

@p2 @check-locator @added @bidder
Scenario: VIOM-834 - Deployment filter keeps the auction under local-auctioneer-1
  And switch to app "bidder"
  And wait 2 sec
  # Added: Deployment filter not covered.
  And press ESCAPE
  And wait 2 sec
  And click "Catalogue"
  And wait 3 sec
  And select "local-auctioneer-1" from list "Deployment"
  And click "Search" inside button with exact phrase
  And wait 3 sec
  And check that screen contains "QA-TIME check"
  And capture screenshot
