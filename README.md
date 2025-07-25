# ConferenceChain

A decentralized academic conference and presentation management system for scholarly events on Stacks blockchain.

## Features

- Conference presentation submission with comprehensive abstract documentation
- Presenter duration management and validation
- Conference type classification system
- Presentation format specification and tracking
- Submission status management and acceptance workflow

## Smart Contract Functions

### Public Functions
- `submit-presentation` - Submit conference presentation with abstract
- `accept-presentation` - Accept presentation for conference (presenter only)

### Read-Only Functions
- `get-presentation` - Get conference presentation details
- `get-presenter` - Get presentation presenter information
- `get-total-presentations` - Get total submitted presentations
- `get-submission-status` - Get presentation submission status

## Conference Types
- International, National, Regional, Workshop, Symposium, Virtual

## Presentation Formats
- Oral, Poster, Keynote, Panel, Demo

## Usage

Deploy the contract to create an academic conference system where presenters can submit abstracts and track their progress through the conference acceptance process.

## License

MIT