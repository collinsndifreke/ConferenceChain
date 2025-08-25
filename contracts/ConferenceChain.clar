;; ConferenceChain: Academic Conference and Presentation Management System
;; Version: 1.0.0

(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-PRESENTATION-NOT-FOUND (err u2))
(define-constant ERR-ALREADY-SUBMITTED (err u3))
(define-constant ERR-INVALID-STATUS (err u4))
(define-constant ERR-INVALID-DURATION (err u5))
(define-constant ERR-INVALID-CONFERENCE-TYPE (err u6))
(define-constant ERR-INVALID-PRESENTATION-FORMAT (err u7))
(define-constant ERR-INVALID-PRESENTATION-TITLE (err u8))
(define-constant ERR-INVALID-ABSTRACT (err u9))

(define-constant MIN-DURATION u15)

(define-data-var next-presentation-id uint u1)

(define-map conference-registry
    uint
    {
        presenter: principal,
        presentation-title: (string-utf8 50),
        abstract: (string-utf8 200),
        conference-type: (string-utf8 15),
        presentation-format: (string-utf8 10),
        submission-status: (string-utf8 15),
        duration: uint
    })

(define-private (validate-conference-type (conference-type (string-utf8 15)))
    (or 
        (is-eq conference-type u"International")
        (is-eq conference-type u"National")
        (is-eq conference-type u"Regional")
        (is-eq conference-type u"Workshop")
        (is-eq conference-type u"Symposium")
        (is-eq conference-type u"Virtual")
    ))

(define-private (validate-presentation-format (presentation-format (string-utf8 10)))
    (or 
        (is-eq presentation-format u"Oral")
        (is-eq presentation-format u"Poster")
        (is-eq presentation-format u"Keynote")
        (is-eq presentation-format u"Panel")
        (is-eq presentation-format u"Demo")
    ))

(define-private (validate-text-input (text (string-utf8 200)) (min-length uint) (max-length uint))
    (let 
        (
            (text-length (len text))
        )
        (and 
            (>= text-length min-length)
            (<= text-length max-length)
        )
    ))

(define-public (submit-presentation 
    (presentation-title (string-utf8 50))
    (abstract (string-utf8 200))
    (conference-type (string-utf8 15))
    (presentation-format (string-utf8 10))
    (duration uint))
    (let
        (
            (presentation-id (var-get next-presentation-id))
        )
        (asserts! (validate-text-input presentation-title u3 u50) ERR-INVALID-PRESENTATION-TITLE)
        (asserts! (validate-text-input abstract u10 u200) ERR-INVALID-ABSTRACT)
        (asserts! (>= duration MIN-DURATION) ERR-INVALID-DURATION)
        (asserts! (validate-conference-type conference-type) ERR-INVALID-CONFERENCE-TYPE)
        (asserts! (validate-presentation-format presentation-format) ERR-INVALID-PRESENTATION-FORMAT)
        
        (map-set conference-registry presentation-id {
            presenter: tx-sender,
            presentation-title: presentation-title,
            abstract: abstract,
            conference-type: conference-type,
            presentation-format: presentation-format,
            submission-status: u"submitted",
            duration: duration
        })
        (var-set next-presentation-id (+ presentation-id u1))
        (ok presentation-id)
    ))

(define-public (accept-presentation (presentation-id uint))
    (let
        (
            (presentation (unwrap! (map-get? conference-registry presentation-id) ERR-PRESENTATION-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (get presenter presentation)) ERR-NOT-AUTHORIZED)
        (asserts! (is-eq (get submission-status presentation) u"submitted") ERR-INVALID-STATUS)
        (ok (map-set conference-registry presentation-id (merge presentation { submission-status: u"accepted" })))
    ))

(define-read-only (get-presentation (presentation-id uint))
    (ok (map-get? conference-registry presentation-id)))

(define-read-only (get-presenter (presentation-id uint))
    (ok (get presenter (unwrap! (map-get? conference-registry presentation-id) ERR-PRESENTATION-NOT-FOUND))))

(define-read-only (get-total-presentations)
    (ok (- (var-get next-presentation-id) u1)))

(define-read-only (get-submission-status (presentation-id uint))
    (ok (get submission-status (unwrap! (map-get? conference-registry presentation-id) ERR-PRESENTATION-NOT-FOUND))))