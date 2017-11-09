# Set global optimisation options for all Paperclip models

# By default, image_optim enables all the compression binaries it supports and
# requires them to be present on your system, failing if one is actually missing.

# We disable everything by default and ignore missing ones with `skip_missing_workers`.
# This way, should a new version add support for a library we do not yet disable here,
# things won't suddenly break.

# Paperclip::PaperclipOptimizer.default_options = {
#   skip_missing_workers: true,
#   advpng: false,
#   gifsicle: false,
#   jhead: false,
#   jpegoptim: false,
#   jpegrecompress: false,
#   jpegtran: false,
#   optipng: false,
#   pngcrush: false,
#   pngout: false,
#   pngquant: false,
#   svgo: false
# }

# All available image_optim options. See https://github.com/toy/image_optim for more information

Paperclip::PaperclipOptimizer.default_options = {
    skip_missing_workers: true, # Skip workers with missing or problematic binaries (defaults to false)
    nice: 10,             # Nice level (defaults to 10)
    threads: 1,           # Number of threads or disable (defaults to number of processors)
    verbose: false,       # Verbose output (defaults to false)
    pack: nil,            # Require image_optim_pack or disable it, by default image_optim_pack will be used if available,
    # will turn on :skip-missing-workers unless explicitly disabled (defaults to nil)
    allow_lossy: true,   # Allow lossy workers and optimizations (defaults to false)
    advpng: false,
    gifsicle: {
        interlace: true,    # Interlace: true - interlace on, false - interlace off, nil - as is in original image
        # (defaults to running two instances, one with interlace off and one with on)
        level: 3,           # Compression level: 1 - light and fast, 2 - normal, 3 - heavy (slower) (defaults to 3)
        careful: false      # Avoid bugs with some software (defaults to false)
    },
    jhead: false,          # no options
    jpegoptim: {
        strip: :all,        # List of extra markers to strip: :comments, :exif, :iptc, :icc or :all (defaults to :all)
        max_quality: 85    # Maximum image quality factor 0..100 (defaults to 100)
    },
    jpegrecompress: false,
    jpegtran: false,
    optipng: false,
    pngcrush: false,
    pngout: false,
    pngquant: {
        quality: 30..50,  # min..max - don't save below min, use less colors below max (both in range 0..100; in yaml - !ruby/range 0..100) (defaults to 100..100)
        speed: 3            # speed/quality trade-off: 1 - slow, 3 - default, 11 - fast & rough (defaults to 3)
    },
    svgo: true            # no options
}