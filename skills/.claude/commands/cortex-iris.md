---
description: Extract structured data from a document using Cortex Iris
---

Extract structured data from an image or PDF using Cortex Iris (document intelligence).

Parse the arguments for:
- A file path (required) — the document to extract from
- `--type TYPE` — extraction type: `invoice`, `receipt`, `business_card`, `general`, `custom` (default: `general`)
- `--schema JSON` — custom JSON schema (required when `--type custom`)

Examples:
- `/cortex-iris invoice.pdf --type invoice` — extract invoice fields
- `/cortex-iris photo.png --type receipt` — extract receipt data from a photo
- `/cortex-iris card.jpg --type business_card` — extract contact info
- `/cortex-iris document.pdf` — general extraction (default)
- `/cortex-iris form.png --type custom --schema '{"name": "string", "amount": "number"}'`

Build and run a curl command like:

```bash
curl -s https://cortexapi.nfinitmonkeys.com/api/iris/extract \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -F "file=@FILE_PATH" \
  -F "extraction_type=TYPE"
```

- For custom schemas, add `-F "custom_schema=JSON_STRING"`.
- The file must be an image (PNG, JPG, WEBP, GIF) or PDF, max 20MB.
- Images are processed by the VLM (vision-language model) for direct visual extraction.
- Text PDFs are processed by PyMuPDF text extraction + LLM structuring.

Show the structured extraction result. Format key fields prominently (e.g. vendor, total, date for invoices).

If there's an error, show it and suggest:
- Check `CORTEX_API_KEY` is set
- Verify the file exists and is a supported type
- For images, the `cortexvlm` pool must be available

Available extraction types:
| Type | Fields extracted |
|------|----------------|
| `invoice` | vendor, invoice_number, date, due_date, line_items, subtotal, tax, total, currency |
| `receipt` | store, date, items, subtotal, tax, total, payment_method, currency |
| `business_card` | name, title, company, email, phone, address, website |
| `general` | title, summary, key-value fields, raw_text |
| `custom` | user-defined JSON schema |
