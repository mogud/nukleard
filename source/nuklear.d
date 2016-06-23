/*
 Nuklear - v1.00 - public domain
 no warrenty implied; use at your own risk.
 authored from 2015-2016 by Micha Mettke

ABOUT:
    This is a minimal state immediate mode graphical user interface single header
    toolkit written in ANSI C and licensed under public domain.
    It was designed as a simple embeddable user interface for application and does
    not have any dependencies, a default renderbackend or OS window and input handling
    but instead provides a very modular library approach by using simple input state
    for input and draw commands describing primitive shapes as output.
    So instead of providing a layered library that tries to abstract over a number
    of platform and render backends it only focuses on the actual UI.

VALUES:
    - Immediate mode graphical user interface toolkit
    - Single header library
    - Written in C89 (ANSI C)
    - Small codebase (~15kLOC)
    - Focus on portability, efficiency and simplicity
    - No dependencies (not even the standard library if not wanted)
    - Fully skinnable and customizable
    - Low memory footprint with total memory control if needed or wanted
    - UTF-8 support
    - No global or hidden state
    - Customizable library modules (you can compile and use only what you need)
    - Optional font baker and vertex buffer output

USAGE:
    This library is self contained in one single header file and can be used either
    in header only mode or in implementation mode. The header only mode is used
    by default when included and allows including this header in other headers
    and does not contain the actual implementation.

    The implementation mode requires to define  the preprocessor macro
    NK_IMPLEMENTATION in *one* .c/.cpp file before #includeing this file, e.g.:

        #define NK_IMPLEMENTATION
        #include "nuklear.h"

    Also optionally define the symbols listed in the section "OPTIONAL DEFINES"
    below in header and implementation mode if you want to use additional functionality
    or need more control over the library.

FEATURES:
    - Absolutely no platform dependent code
    - Memory management control ranging from/to
        - Ease of use by allocating everything from the standard library
        - Control every byte of memory inside the library
    - Font handling control ranging from/to
        - Use your own font implementation to draw shapes/vertexes
        - Use this libraries internal font baking and handling API
    - Drawing output control ranging from/to
        - Simple shapes for more high level APIs which already having drawing capabilities
        - Hardware accessible anti-aliased vertex buffer output
    - Customizable colors and properties ranging from/to
        - Simple changes to color by filling a simple color table
        - Complete control with ability to use skinning to decorate widgets
    - Bendable UI library with widget ranging from/to
        - Basic widgets like buttons, checkboxes, slider, ...
        - Advanced widget like abstract comboboxes, contextual menus,...
    - Compile time configuration to only compile what you need
        - Subset which can be used if you do not want to link or use the standard library
    - Can be easily modified only update on user input instead of frame updates

OPTIONAL DEFINES:
    NK_PRIVATE
        If defined declares all functions as static, so they can only be accessed
        for the file that creates the implementation

    NK_INCLUDE_FIXED_TYPES
        If defined it will include header <stdint.h> for fixed sized types
        otherwise you have to select the correct types.

    NK_INCLUDE_DEFAULT_ALLOCATOR
        if defined it will include header <stdlib.h> and provide additional functions
        to use this library without caring for memory allocation control and therefore
        ease memory management.
        IMPORTANT:  this adds the standard library with malloc and free so don't define
                    if you don't want to link to the standard library!

    NK_INCLUDE_STANDARD_IO
        if defined it will include header <stdio.h> and <stdarg.h> and provide
        additional functions depending on file loading and variable arguments
        IMPORTANT:  this adds the standard library with fopen, fclose,...
                    as well as va_list,... so don't define this
                    if you don't want to link to the standard library!

    NK_INCLUDE_VERTEX_BUFFER_OUTPUT
        Defining this adds a vertex draw command list backend to this
        library, which allows you to convert queue commands into vertex draw commands.
        This is mainly if you need a hardware accessible format for OpenGL, DirectX,
        Vulkan, Metal,...

    NK_INCLUDE_FONT_BAKING
        Defining this adds the `stb_truetype` and `stb_rect_pack` implementation
        to this library and provides a default font for font loading and rendering.
        If you already have font handling or do not want to use this font handler
        you don't have to define it.

    NK_INCLUDE_DEFAULT_FONT
        Defining this adds the default font: ProggyClean.ttf font into this library
        which can be loaded into a font atlas and allows using this library without
        having a truetype font
        IMPORTANT: enabling this adds ~12kb to global stack memory

    NK_INCLUDE_COMMAND_USERDATA
        Defining this adds a userdata pointer into each command. Can be useful for
        example if you want to provide custom shader depending on the used widget.
        Can be combined with the style structures.

    NK_BUTTON_TRIGGER_ON_RELEASE
        Different platforms require button clicks occuring either on buttons being
        pressed (up to down) or released (down to up).
        By default this library will react on buttons being pressed, but if you
        define this it will only trigger if a button is released.

    NK_ASSERT
        If you don't define this, nuklear will use <assert.h> with assert().
        IMPORTANT:  it also adds the standard library so define to nothing of not wanted!

    NK_BUFFER_DEFAULT_INITIAL_SIZE
        Initial buffer size allocated by all buffers while using the default allocator
        functions included by defining NK_INCLUDE_DEFAULT_ALLOCATOR. If you don't
        want to allocate the default 4k memory then redefine it.

    NK_MAX_NUMBER_BUFFER
        Maximum buffer size for the conversion buffer between float and string
        Under normal circumstances this should be more than sufficient.

    NK_INPUT_MAX
        Defines the max number of bytes which can be added as text input in one frame.
        Under normal circumstances this should be more than sufficient.

    NK_MEMSET
        You can define this to 'memset' or your own memset implementation
        replacement. If not nuklear will use its own version.

    NK_MEMCOPY
        You can define this to 'memcpy' or your own memcpy implementation
        replacement. If not nuklear will use its own version.

    NK_SQRT
        You can define this to 'sqrt' or your own sqrt implementation
        replacement. If not nuklear will use its own slow and not highly
        accurate version.

    NK_SIN
        You can define this to 'sinf' or your own sine implementation
        replacement. If not nuklear will use its own approximation implementation.

    NK_COS
        You can define this to 'cosf' or your own cosine implementation
        replacement. If not nuklear will use its own approximation implementation.

    NK_BYTE
    NK_INT16
    NK_UINT16
    NK_INT32
    NK_UINT32
    NK_SIZE_TYPE
    NK_POINTER_TYPE
        If you compile without NK_USE_FIXED_TYPE then a number of standard types
        will be selected and compile time validated. If they are incorrect you can
        define the correct types.

CREDITS:
    Developed by Micha Mettke and every direct or indirect contributor to the GitHub.

    Embeds stb_texedit, stb_truetype and stb_rectpack by Sean Barret (public domain)
    Embeds ProggyClean.ttf font by Tristan Grimmer (MIT license).

    Big thank you to Omar Cornut (ocornut@github) for his imgui library and
    giving me the inspiration for this library, Casey Muratori for handmade hero
    and his original immediate mode graphical user interface idea and Sean
    Barret for his amazing single header libraries which restored by faith
    in libraries and brought me to create some of my own.

LICENSE:
    This software is dual-licensed to the public domain and under the following
    license: you are granted a perpetual, irrevocable license to copy, modify,
    publish and distribute this file as you see fit.
*/
module nuklear;

extern (C) {
/*
 * ==============================================================
 *
 *                          CONSTANTS
 *
 * ===============================================================
 */
enum NK_UTF_INVALID = 0xFFFD /* internal invalid utf8 rune */;
enum NK_UTF_SIZE = 4 /* describes the number of bytes a glyph consists of*/;
enum NK_INPUT_MAX = 16;
enum NK_MAX_NUMBER_BUFFER = 64;
/*
 * ===============================================================
 *
 *                          BASIC
 *
 * ===============================================================
 */
version (NK_INCLUDE_FIXED_TYPES){
    import core.stdc.stdint;
    alias nk_byte = uint8_t;
    alias nk_short = int16_t;
    alias nk_ushort = uint16_t;
    alias nk_int = int32_t;
    alias nk_uint = uint32_t;
    alias nk_hash = uint32_t;
    alias nk_size = uintptr_t;
    alias nk_ptr = uintptr_t;
    alias nk_flags = uint32_t;
    alias nk_rune = uint32_t;
} else {
    alias nk_byte = ubyte;
    alias nk_short = short;
    alias nk_ushort = ushort;
    alias nk_int = int;
    alias nk_uint = uint;
    alias nk_hash = uint;
    alias nk_size = ulong;
    alias nk_ptr = ulong;
    alias nk_flags = uint;
    alias nk_rune = uint;
}

/* ============================================================================
 *
 *                                  API
 *
 * =========================================================================== */
enum NK_UNDEFINED = -1.0f;
pragma(inline, true) {
    auto NK_FLAG(T)(T x) { return 1 << x; }
    import std.conv: to;
    auto NK_FILE_LINE(string file = __FILE__, size_t line = __LINE__)() { return file ~ ":" ~ line.to!string; }
}

enum {nk_false, nk_true}
struct nk_color {nk_byte r,g,b,a;}
struct nk_vec2 {float x,y;}
struct nk_vec2i {short x, y;}
struct nk_rect {float x,y,w,h;}
struct nk_recti {short x,y,w,h;}
alias nk_glyph = char[NK_UTF_SIZE];
union nk_handle {void *ptr; int id;}
struct nk_image {nk_handle handle; ushort w,h; ushort[4] region;};
struct nk_scroll {ushort x, y;};
enum nk_heading {NK_UP, NK_RIGHT, NK_DOWN, NK_LEFT};

alias nk_filter = int function(const(nk_text_edit) *, nk_rune unicode);
alias nk_paste_f = void function(nk_handle, nk_text_edit*);
alias nk_copy_f = void function(nk_handle, const(char) *, int len);

enum nk_button_behavior {NK_BUTTON_DEFAULT, NK_BUTTON_REPEATER};
enum nk_modify          {NK_FIXED=nk_false, NK_MODIFIABLE=nk_true};
enum nk_orientation     {NK_VERTICAL, NK_HORIZONTAL};
enum nk_collapse_states {NK_MINIMIZED=nk_false, NK_MAXIMIZED = nk_true};
enum nk_show_states     {NK_HIDDEN=nk_false, NK_SHOWN=nk_true};
enum nk_chart_type      {NK_CHART_LINES, NK_CHART_COLUMN, NK_CHART_MAX};
enum nk_chart_event     {NK_CHART_HOVERING = 0x01, NK_CHART_CLICKED = 0x02};
enum nk_color_format    {NK_RGB, NK_RGBA};
enum nk_popup_type      {NK_POPUP_STATIC, NK_POPUP_DYNAMIC};
enum nk_layout_format   {NK_DYNAMIC, NK_STATIC};
enum nk_tree_type       {NK_TREE_NODE, NK_TREE_TAB};
enum nk_anti_aliasing   {NK_ANTI_ALIASING_OFF, NK_ANTI_ALIASING_ON};

struct nk_allocator {
    nk_handle userdata;
    void* function(nk_handle, void *old, nk_size) alloc;
    void function(nk_handle, void*) free;
};

struct nk_draw_null_texture {
    nk_handle texture;/* texture handle to a texture with a white pixel */
    nk_vec2 uv; /* coordinates to a white pixel in the texture  */
};
struct nk_convert_config {
    float global_alpha; /* global alpha value */
    nk_anti_aliasing line_AA; /* line anti-aliasing flag can be turned off if you are tight on memory */
    nk_anti_aliasing shape_AA; /* shape anti-aliasing flag can be turned off if you are tight on memory */
    uint circle_segment_count; /* number of segments used for circles: default to 22 */
    uint arc_segment_count; /* number of segments used for arcs: default to 22 */
    uint curve_segment_count; /* number of segments used for curves: default to 22 */
    nk_draw_null_texture null_; /* handle to texture with a white pixel for shape drawing */
};

enum nk_symbol_type {
    NK_SYMBOL_NONE,
    NK_SYMBOL_X,
    NK_SYMBOL_UNDERSCORE,
    NK_SYMBOL_CIRCLE,
    NK_SYMBOL_CIRCLE_FILLED,
    NK_SYMBOL_RECT,
    NK_SYMBOL_RECT_FILLED,
    NK_SYMBOL_TRIANGLE_UP,
    NK_SYMBOL_TRIANGLE_DOWN,
    NK_SYMBOL_TRIANGLE_LEFT,
    NK_SYMBOL_TRIANGLE_RIGHT,
    NK_SYMBOL_PLUS,
    NK_SYMBOL_MINUS,
    NK_SYMBOL_MAX
};

enum nk_keys {
    NK_KEY_NONE,
    NK_KEY_SHIFT,
    NK_KEY_CTRL,
    NK_KEY_DEL,
    NK_KEY_ENTER,
    NK_KEY_TAB,
    NK_KEY_BACKSPACE,
    NK_KEY_COPY,
    NK_KEY_CUT,
    NK_KEY_PASTE,
    NK_KEY_UP,
    NK_KEY_DOWN,
    NK_KEY_LEFT,
    NK_KEY_RIGHT,

    /* Shortcuts: text field */
    NK_KEY_TEXT_INSERT_MODE,
    NK_KEY_TEXT_REPLACE_MODE,
    NK_KEY_TEXT_RESET_MODE,
    NK_KEY_TEXT_LINE_START,
    NK_KEY_TEXT_LINE_END,
    NK_KEY_TEXT_START,
    NK_KEY_TEXT_END,
    NK_KEY_TEXT_UNDO,
    NK_KEY_TEXT_REDO,
    NK_KEY_TEXT_WORD_LEFT,
    NK_KEY_TEXT_WORD_RIGHT,

    /* Shortcuts: scrollbar */
    NK_KEY_SCROLL_START,
    NK_KEY_SCROLL_END,
    NK_KEY_SCROLL_DOWN,
    NK_KEY_SCROLL_UP,

    NK_KEY_MAX
};

enum nk_buttons {
    NK_BUTTON_LEFT,
    NK_BUTTON_MIDDLE,
    NK_BUTTON_RIGHT,
    NK_BUTTON_MAX
};

enum nk_style_colors {
    NK_COLOR_TEXT,
    NK_COLOR_WINDOW,
    NK_COLOR_HEADER,
    NK_COLOR_BORDER,
    NK_COLOR_BUTTON,
    NK_COLOR_BUTTON_HOVER,
    NK_COLOR_BUTTON_ACTIVE,
    NK_COLOR_TOGGLE,
    NK_COLOR_TOGGLE_HOVER,
    NK_COLOR_TOGGLE_CURSOR,
    NK_COLOR_SELECT,
    NK_COLOR_SELECT_ACTIVE,
    NK_COLOR_SLIDER,
    NK_COLOR_SLIDER_CURSOR,
    NK_COLOR_SLIDER_CURSOR_HOVER,
    NK_COLOR_SLIDER_CURSOR_ACTIVE,
    NK_COLOR_PROPERTY,
    NK_COLOR_EDIT,
    NK_COLOR_EDIT_CURSOR,
    NK_COLOR_COMBO,
    NK_COLOR_CHART,
    NK_COLOR_CHART_COLOR,
    NK_COLOR_CHART_COLOR_HIGHLIGHT,
    NK_COLOR_SCROLLBAR,
    NK_COLOR_SCROLLBAR_CURSOR,
    NK_COLOR_SCROLLBAR_CURSOR_HOVER,
    NK_COLOR_SCROLLBAR_CURSOR_ACTIVE,
    NK_COLOR_TAB_HEADER,
    NK_COLOR_COUNT
};

enum nk_widget_layout_states {
    NK_WIDGET_INVALID, /* The widget cannot be seen and is completely out of view */
    NK_WIDGET_VALID, /* The widget is completely inside the window and can be updated and drawn */
    NK_WIDGET_ROM /* The widget is partially visible and cannot be updated */
};

/* widget states */
enum nk_widget_states {
    NK_WIDGET_STATE_MODIFIED    = NK_FLAG(1),
    NK_WIDGET_STATE_INACTIVE    = NK_FLAG(2), /* widget is neither active nor hovered */
    NK_WIDGET_STATE_ENTERED     = NK_FLAG(3), /* widget has been hovered on the current frame */
    NK_WIDGET_STATE_HOVER       = NK_FLAG(4), /* widget is being hovered */
    NK_WIDGET_STATE_ACTIVED     = NK_FLAG(5),/* widget is currently activated */
    NK_WIDGET_STATE_LEFT        = NK_FLAG(6), /* widget is from this frame on not hovered anymore */
    NK_WIDGET_STATE_HOVERED     = NK_WIDGET_STATE_HOVER|NK_WIDGET_STATE_MODIFIED, /* widget is being hovered */
    NK_WIDGET_STATE_ACTIVE      = NK_WIDGET_STATE_ACTIVED|NK_WIDGET_STATE_MODIFIED /* widget is currently activated */
};

/* text alignment */
enum nk_text_align {
    NK_TEXT_ALIGN_LEFT        = 0x01,
    NK_TEXT_ALIGN_CENTERED    = 0x02,
    NK_TEXT_ALIGN_RIGHT       = 0x04,
    NK_TEXT_ALIGN_TOP         = 0x08,
    NK_TEXT_ALIGN_MIDDLE      = 0x10,
    NK_TEXT_ALIGN_BOTTOM      = 0x20
};
enum nk_text_alignment {
    NK_TEXT_LEFT        = nk_text_align.NK_TEXT_ALIGN_MIDDLE|nk_text_align.NK_TEXT_ALIGN_LEFT,
    NK_TEXT_CENTERED    = nk_text_align.NK_TEXT_ALIGN_MIDDLE|nk_text_align.NK_TEXT_ALIGN_CENTERED,
    NK_TEXT_RIGHT       = nk_text_align.NK_TEXT_ALIGN_MIDDLE|nk_text_align.NK_TEXT_ALIGN_RIGHT
};

enum nk_edit_flags {
    NK_EDIT_DEFAULT                 = 0,
    NK_EDIT_READ_ONLY               = NK_FLAG(0),
    NK_EDIT_AUTO_SELECT             = NK_FLAG(1),
    NK_EDIT_SIG_ENTER               = NK_FLAG(2),
    NK_EDIT_ALLOW_TAB               = NK_FLAG(3),
    NK_EDIT_NO_CURSOR               = NK_FLAG(4),
    NK_EDIT_SELECTABLE              = NK_FLAG(5),
    NK_EDIT_CLIPBOARD               = NK_FLAG(6),
    NK_EDIT_CTRL_ENTER_NEWLINE      = NK_FLAG(7),
    NK_EDIT_NO_HORIZONTAL_SCROLL    = NK_FLAG(8),
    NK_EDIT_ALWAYS_INSERT_MODE      = NK_FLAG(9),
    NK_EDIT_MULTILINE               = NK_FLAG(11)
};
enum nk_edit_types {
    NK_EDIT_SIMPLE  = nk_edit_flags.NK_EDIT_ALWAYS_INSERT_MODE,
    NK_EDIT_FIELD   = NK_EDIT_SIMPLE
                    | cast(nk_edit_types)nk_edit_flags.NK_EDIT_SELECTABLE,
    NK_EDIT_BOX     = nk_edit_flags.NK_EDIT_ALWAYS_INSERT_MODE
                    | nk_edit_flags.NK_EDIT_SELECTABLE
                    | nk_edit_flags.NK_EDIT_MULTILINE
                    | nk_edit_flags.NK_EDIT_ALLOW_TAB,
    NK_EDIT_EDITOR  = nk_edit_flags.NK_EDIT_SELECTABLE
                    | nk_edit_flags.NK_EDIT_MULTILINE
                    | nk_edit_flags.NK_EDIT_ALLOW_TAB
                    | nk_edit_flags.NK_EDIT_CLIPBOARD
};
enum nk_edit_events {
    NK_EDIT_ACTIVE      = NK_FLAG(0), /* edit widget is currently being modified */
    NK_EDIT_INACTIVE    = NK_FLAG(1), /* edit widget is not active and is not being modified */
    NK_EDIT_ACTIVATED   = NK_FLAG(2), /* edit widget went from state inactive to state active */
    NK_EDIT_DEACTIVATED = NK_FLAG(3), /* edit widget went from state active to state inactive */
    NK_EDIT_COMMITED    = NK_FLAG(4) /* edit widget has received an enter and lost focus */
};

enum nk_panel_flags {
    NK_WINDOW_BORDER        = NK_FLAG(0), /* Draws a border around the window to visually separate the window * from the background */
    NK_WINDOW_BORDER_HEADER = NK_FLAG(1), /* Draws a border between window header and body */
    NK_WINDOW_MOVABLE       = NK_FLAG(2), /* The movable flag indicates that a window can be moved by user input or * by dragging the window header */
    NK_WINDOW_SCALABLE      = NK_FLAG(3), /* The scalable flag indicates that a window can be scaled by user input * by dragging a scaler icon at the button of the window */
    NK_WINDOW_CLOSABLE      = NK_FLAG(4), /* adds a closable icon into the header */
    NK_WINDOW_MINIMIZABLE   = NK_FLAG(5), /* adds a minimize icon into the header */
    NK_WINDOW_DYNAMIC       = NK_FLAG(6), /* special window type growing up in height while being filled to a * certain maximum height */
    NK_WINDOW_NO_SCROLLBAR  = NK_FLAG(7), /* Removes the scrollbar from the window */
    NK_WINDOW_TITLE         = NK_FLAG(8) /* Forces a header at the top at the window showing the title */
};

/* context */
version (NK_INCLUDE_DEFAULT_ALLOCATOR) {
    int nk_init_default(nk_context*, const(nk_user_font) *);
}

int nk_init_fixed(nk_context*, void *memory, nk_size size, const(nk_user_font) *);
int nk_init_custom(nk_context*, nk_buffer *cmds, nk_buffer *pool, const(nk_user_font) *);
int nk_init(nk_context*, nk_allocator*, const(nk_user_font) *);
void nk_clear(nk_context*);
void nk_free(nk_context*);

version (NK_INCLUDE_COMMAND_USERDATA) {
    void nk_set_user_data(nk_context*, nk_handle handle);
}

/* window */
int nk_begin(nk_context*, nk_panel*, const(char) *title, nk_rect bounds, nk_flags flags);
void nk_end(nk_context*);

nk_window*          nk_window_find(nk_context *ctx, const(char) *name);
nk_rect             nk_window_get_bounds(const(nk_context) *);
nk_vec2             nk_window_get_position(const(nk_context) *);
nk_vec2             nk_window_get_size(const(nk_context) *);
float               nk_window_get_width(const(nk_context) *);
float               nk_window_get_height(const(nk_context) *);
nk_panel*           nk_window_get_panel(nk_context*);
nk_rect             nk_window_get_content_region(nk_context*);
nk_vec2             nk_window_get_content_region_min(nk_context*);
nk_vec2             nk_window_get_content_region_max(nk_context*);
nk_vec2             nk_window_get_content_region_size(nk_context*);
nk_command_buffer*  nk_window_get_canvas(nk_context*);

int                 nk_window_has_focus(const(nk_context) *);
int                 nk_window_is_collapsed(nk_context*, const(char) *);
int                 nk_window_is_closed(nk_context*, const(char) *);
int                 nk_window_is_active(nk_context*, const(char) *);
int                 nk_window_is_hovered(nk_context*);
int                 nk_window_is_any_hovered(nk_context*);
int                 nk_item_is_any_active(nk_context*);

void                nk_window_set_bounds(nk_context*, nk_rect);
void                nk_window_set_position(nk_context*, nk_vec2);
void                nk_window_set_size(nk_context*, nk_vec2);
void                nk_window_set_focus(nk_context*, const(char) *name);

void                nk_window_close(nk_context *ctx, const(char) *name);
void                nk_window_collapse(nk_context*, const(char) *name, nk_collapse_states);
void                nk_window_collapse_if(nk_context*, const(char) *name, nk_collapse_states, int cond);
void                nk_window_show(nk_context*, const(char) *name, nk_show_states);
void                nk_window_show_if(nk_context*, const(char) *name, nk_show_states, int cond);

/* Layout */
void                nk_layout_row_dynamic(nk_context*, float height, int cols);
void                nk_layout_row_static(nk_context*, float height, int item_width, int cols);

void                nk_layout_row_begin(nk_context*, nk_layout_format, float row_height, int cols);
void                nk_layout_row_push(nk_context*, float value);
void                nk_layout_row_end(nk_context*);
void                nk_layout_row(nk_context*, nk_layout_format, float height, int cols, const(float) *ratio);

void                nk_layout_space_begin(nk_context*, nk_layout_format, float height, int widget_count);
void                nk_layout_space_push(nk_context*, nk_rect);
void                nk_layout_space_end(nk_context*);

nk_rect             nk_layout_space_bounds(nk_context*);
nk_vec2             nk_layout_space_to_screen(nk_context*, nk_vec2);
nk_vec2             nk_layout_space_to_local(nk_context*, nk_vec2);
nk_rect             nk_layout_space_rect_to_screen(nk_context*, nk_rect);
nk_rect             nk_layout_space_rect_to_local(nk_context*, nk_rect);

/* Layout: Group */
int                 nk_group_begin(nk_context*, nk_panel*, const(char) *title, nk_flags);
void                nk_group_end(nk_context*);

/* Layout: Tree */
pragma(inline, true) {
    auto nk_tree_push(size_t line = __LINE__)(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state) {
        return nk_tree_push_hashed(ctx, type, title, state, NK_FILE_LINE.ptr,nk_strlen(NK_FILE_LINE.ptr),line);
    }
    auto nk_tree_push_id(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state, int id) {
        return nk_tree_push_hashed(ctx, type, title, state, NK_FILE_LINE.ptr,nk_strlen(NK_FILE_LINE.ptr),id);
    }
}
int nk_tree_push_hashed(nk_context*, nk_tree_type, const(char) *title, nk_collapse_states initial_state, const(char) *hash, int len,int seed);

pragma(inline, true) {
    auto nk_tree_image_push(size_t line = __LINE__)(nk_context *ctx, nk_tree_type type, nk_image img, const(char) *title, nk_collapse_states state) {
        return nk_tree_image_push_hashed(ctx, type, img, title, state, NK_FILE_LINE.ptr,nk_strlen(NK_FILE_LINE.ptr),line);
    }
    auto nk_tree_image_push_id(nk_context *ctx, nk_tree_type type, nk_image img, const(char) *title, nk_collapse_states state, int id) {
        return nk_tree_image_push_hashed(ctx, type, img, title, state, NK_FILE_LINE.ptr,nk_strlen(NK_FILE_LINE.ptr),id);
    }
}
int                      nk_tree_image_push_hashed(nk_context*, nk_tree_type, nk_image, const(char) *title, nk_collapse_states initial_state, const(char) *hash, int len,int seed);
void                     nk_tree_pop(nk_context*);

/* Widgets */
void                     nk_text(nk_context*, const(char) *, int, nk_flags);
void                     nk_text_colored(nk_context*, const(char) *, int, nk_flags, nk_color);
void                     nk_text_wrap(nk_context*, const(char) *, int);
void                     nk_text_wrap_colored(nk_context*, const(char) *, int, nk_color);

void                     nk_label(nk_context*, const(char) *, nk_flags align_);
void                     nk_label_colored(nk_context*, const(char) *, nk_flags align_, nk_color);
void                     nk_label_wrap(nk_context*, const(char) *);
void                     nk_label_colored_wrap(nk_context*, const(char) *, nk_color);

pragma(mangle, "nk_image")
void                     nk_image_(nk_context*, nk_image);

version (NK_INCLUDE_STANDARD_IO) {
    void nk_labelf(nk_context*, nk_flags, const(char) *, ...);
    void nk_labelf_colored(nk_context*, nk_flags align_, nk_color, const(char) *,...);
    void nk_labelf_wrap(nk_context*, const(char) *,...);
    void nk_labelf_colored_wrap(nk_context*, nk_color, const(char) *,...);

    void nk_value_bool(nk_context*, const(char) *prefix, int);
    void nk_value_int(nk_context*, const(char) *prefix, int);
    void nk_value_uint(nk_context*, const(char) *prefix, uint);
    void nk_value_float(nk_context*, const(char) *prefix, float);
    void nk_value_color_byte(nk_context*, const(char) *prefix, nk_color);
    void nk_value_color_float(nk_context*, const(char) *prefix, nk_color);
    void nk_value_color_hex(nk_context*, const(char) *prefix, nk_color);
}

/* Widgets: Buttons */
int                      nk_button_text(nk_context *ctx, const(char) *title, int len, nk_button_behavior);
int                      nk_button_label(nk_context *ctx, const(char) *title, nk_button_behavior);
int                      nk_button_color(nk_context*, nk_color, nk_button_behavior);
int                      nk_button_symbol(nk_context*, nk_symbol_type, nk_button_behavior);
int                      nk_button_image(nk_context*, nk_image img, nk_button_behavior);
int                      nk_button_symbol_label(nk_context*, nk_symbol_type, const(char) *, nk_flags text_alignment, nk_button_behavior);
int                      nk_button_symbol_text(nk_context*, nk_symbol_type, const(char) *, int, nk_flags alignment, nk_button_behavior);
int                      nk_button_image_label(nk_context*, nk_image img, const(char) *, nk_flags text_alignment, nk_button_behavior);
int                      nk_button_image_text(nk_context*, nk_image img, const(char) *, int, nk_flags alignment, nk_button_behavior);

/* Widgets: Checkbox */
int                      nk_check_label(nk_context*, const(char) *, int active);
int                      nk_check_text(nk_context*, const(char) *, int,int active);
uint                     nk_check_flags_label(nk_context*, const(char) *, uint flags, uint value);
uint                     nk_check_flags_text(nk_context*, const(char) *, int, uint flags, uint value);
int                      nk_checkbox_label(nk_context*, const(char) *, int *active);
int                      nk_checkbox_text(nk_context*, const(char) *, int, int *active);
int                      nk_checkbox_flags_label(nk_context*, const(char) *, uint *flags, uint value);
int                      nk_checkbox_flags_text(nk_context*, const(char) *, int, uint *flags, uint value);

/* Widgets: Radio */
int                      nk_radio_label(nk_context*, const(char) *, int *active);
int                      nk_radio_text(nk_context*, const(char) *, int, int *active);
int                      nk_option_label(nk_context*, const(char) *, int active);
int                      nk_option_text(nk_context*, const(char) *, int, int active);

/* Widgets: Selectable */
int                      nk_selectable_label(nk_context*, const(char) *, nk_flags align_, int *value);
int                      nk_selectable_text(nk_context*, const(char) *, int, nk_flags align_, int *value);
int                      nk_selectable_image_label(nk_context*,nk_image,  const(char) *, nk_flags align_, int *value);
int                      nk_selectable_image_text(nk_context*,nk_image, const(char) *, int, nk_flags align_, int *value);

int                      nk_select_label(nk_context*, const(char) *, nk_flags align_, int value);
int                      nk_select_text(nk_context*, const(char) *, int, nk_flags align_, int value);
int                      nk_select_image_label(nk_context*, nk_image,const(char) *, nk_flags align_, int value);
int                      nk_select_image_text(nk_context*, nk_image,const(char) *, int, nk_flags align_, int value);

/* Widgets: Slider */
float                    nk_slide_float(nk_context*, float min, float val, float max, float step);
int                      nk_slide_int(nk_context*, int min, int val, int max, int step);
int                      nk_slider_float(nk_context*, float min, float *val, float max, float step);
int                      nk_slider_int(nk_context*, int min, int *val, int max, int step);

/* Widgets: Progressbar */
int                      nk_progress(nk_context*, nk_size *cur, nk_size max, int modifyable);
nk_size                  nk_prog(nk_context*, nk_size cur, nk_size max, int modifyable);

/* Widgets: Color picker */
nk_color          nk_color_picker(nk_context*, nk_color, nk_color_format);
int                      nk_color_pick(nk_context*, nk_color*, nk_color_format);

/* Widgets: Property */
void                     nk_property_float(nk_context *layout, const(char) *name, float min, float *val, float max, float step, float inc_per_pixel);
void                     nk_property_int(nk_context *layout, const(char) *name, int min, int *val, int max, int step, int inc_per_pixel);
float                    nk_propertyf(nk_context *layout, const(char) *name, float min, float val, float max, float step, float inc_per_pixel);
int                      nk_propertyi(nk_context *layout, const(char) *name, int min, int val, int max, int step, int inc_per_pixel);

/* Widgets: TextEdit */
nk_flags                 nk_edit_string(nk_context*, nk_flags, char *buffer, int *len, int max, nk_filter);
nk_flags                 nk_edit_buffer(nk_context*, nk_flags, nk_text_edit*, nk_filter);

/* Chart */
int                      nk_chart_begin(nk_context*, nk_chart_type, int num, float min, float max);
int                      nk_chart_begin_colored(nk_context*, nk_chart_type, nk_color, nk_color active, int num, float min, float max);
void                     nk_chart_add_slot(nk_context *ctx, const nk_chart_type, int count, float min_value, float max_value);
void                     nk_chart_add_slot_colored(nk_context *ctx, const nk_chart_type, nk_color, nk_color active, int count, float min_value, float max_value);
nk_flags                 nk_chart_push(nk_context*, float);
nk_flags                 nk_chart_push_slot(nk_context*, float, int);
void                     nk_chart_end(nk_context*);
void                     nk_plot(nk_context*, nk_chart_type, const(float) *values, int count, int offset);
void                     nk_plot_function(nk_context*, nk_chart_type, void *userdata, float function(void* user, int index), int count, int offset);

/* Popups */
int                      nk_popup_begin(nk_context*, nk_panel*, nk_popup_type, const(char) *, nk_flags, nk_rect bounds);
void                     nk_popup_close(nk_context*);
void                     nk_popup_end(nk_context*);

/* Combobox */
int                      nk_combo(nk_context*, const(char) **items, int count, int selected, int item_height);
int                      nk_combo_separator(nk_context*, const(char) *items_separated_by_separator, int separator, int selected, int count, int item_height);
int                      nk_combo_string(nk_context*, const(char) *items_separated_by_zeros, int selected, int count, int item_height);
int                      nk_combo_callback(nk_context*, void function(void*, int, const(char) **), void *userdata, int selected, int count, int item_height);
void                     nk_combobox(nk_context*, const(char) **items, int count, int *selected, int item_height);
void                     nk_combobox_string(nk_context*, const(char) *items_separated_by_zeros, int *selected, int count, int item_height);
void                     nk_combobox_separator(nk_context*, const(char) *items_separated_by_separator, int separator,int *selected, int count, int item_height);
void                     nk_combobox_callback(nk_context*, void function(void*, int, const(char) **), void*, int *selected, int count, int item_height);

/* Combobox: abstract */
int                      nk_combo_begin_text(nk_context*, nk_panel*, const(char) *selected, int, int max_height);
int                      nk_combo_begin_label(nk_context*, nk_panel*, const(char) *selected, int max_height);
int                      nk_combo_begin_color(nk_context*, nk_panel*, nk_color color, int max_height);
int                      nk_combo_begin_symbol(nk_context*, nk_panel*, nk_symbol_type,  int max_height);
int                      nk_combo_begin_symbol_label(nk_context*, nk_panel*, const(char) *selected, nk_symbol_type, int height);
int                      nk_combo_begin_symbol_text(nk_context*, nk_panel*, const(char) *selected, int, nk_symbol_type, int height);
int                      nk_combo_begin_image(nk_context*, nk_panel*, nk_image img,  int max_height);
int                      nk_combo_begin_image_label(nk_context*, nk_panel*, const(char) *selected, nk_image, int height);
int                      nk_combo_begin_image_text(nk_context*, nk_panel*, const(char) *selected, int, nk_image, int height);
int                      nk_combo_item_label(nk_context*, const(char) *, nk_flags alignment);
int                      nk_combo_item_text(nk_context*, const(char) *,int, nk_flags alignment);
int                      nk_combo_item_image_label(nk_context*, nk_image, const(char) *, nk_flags alignment);
int                      nk_combo_item_image_text(nk_context*, nk_image, const(char) *, int,nk_flags alignment);
int                      nk_combo_item_symbol_label(nk_context*, nk_symbol_type, const(char) *, nk_flags alignment);
int                      nk_combo_item_symbol_text(nk_context*, nk_symbol_type, const(char) *, int, nk_flags alignment);
void                     nk_combo_close(nk_context*);
void                     nk_combo_end(nk_context*);

/* Contextual */
int                      nk_contextual_begin(nk_context*, nk_panel*, nk_flags, nk_vec2, nk_rect trigger_bounds);
int                      nk_contextual_item_text(nk_context*, const(char) *, int,nk_flags align_);
int                      nk_contextual_item_label(nk_context*, const(char) *, nk_flags align_);
int                      nk_contextual_item_image_label(nk_context*, nk_image, const(char) *, nk_flags alignment);
int                      nk_contextual_item_image_text(nk_context*, nk_image, const(char) *, int len, nk_flags alignment);
int                      nk_contextual_item_symbol_label(nk_context*, nk_symbol_type, const(char) *, nk_flags alignment);
int                      nk_contextual_item_symbol_text(nk_context*, nk_symbol_type, const(char) *, int, nk_flags alignment);
void                     nk_contextual_close(nk_context*);
void                     nk_contextual_end(nk_context*);

/* Tooltip */
void                     nk_tooltip(nk_context*, const(char) *);
int                      nk_tooltip_begin(nk_context*, nk_panel*, float width);
void                     nk_tooltip_end(nk_context*);

/* Menu */
void                     nk_menubar_begin(nk_context*);
void                     nk_menubar_end(nk_context*);
int                      nk_menu_begin_text(nk_context*, nk_panel*, const(char) *, int, nk_flags align_, float width);
int                      nk_menu_begin_label(nk_context*, nk_panel*, const(char) *, nk_flags align_, float width);
int                      nk_menu_begin_image(nk_context*, nk_panel*, const(char) *, nk_image, float width);
int                      nk_menu_begin_image_text(nk_context*, nk_panel*, const(char) *, int,nk_flags align_,nk_image, float width);
int                      nk_menu_begin_image_label(nk_context*, nk_panel*, const(char) *, nk_flags align_,nk_image, float width);
int                      nk_menu_begin_symbol(nk_context*, nk_panel*, const(char) *, nk_symbol_type, float width);
int                      nk_menu_begin_symbol_text(nk_context*, nk_panel*, const(char) *, int,nk_flags align_,nk_symbol_type, float width);
int                      nk_menu_begin_symbol_label(nk_context*, nk_panel*, const(char) *, nk_flags align_,nk_symbol_type, float width);
int                      nk_menu_item_text(nk_context*, const(char) *, int,nk_flags align_);
int                      nk_menu_item_label(nk_context*, const(char) *, nk_flags alignment);
int                      nk_menu_item_image_label(nk_context*, nk_image, const(char) *, nk_flags alignment);
int                      nk_menu_item_image_text(nk_context*, nk_image, const(char) *, int len, nk_flags alignment);
int                      nk_menu_item_symbol_text(nk_context*, nk_symbol_type, const(char) *, int, nk_flags alignment);
int                      nk_menu_item_symbol_label(nk_context*, nk_symbol_type, const(char) *, nk_flags alignment);
void                     nk_menu_close(nk_context*);
void                     nk_menu_end(nk_context*);

/* Drawing*/
pragma(inline, true)
void nk_foreach(nk_context *ctx, void delegate(const(nk_command)*) block) {
    for (auto c = nk__begin(ctx); c != null; c = nk__next(ctx, c)) {
        block(c);
    }
}
version (NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
    void nk_convert(nk_context*, nk_buffer *cmds, nk_buffer *vertices, nk_buffer *elements, const(nk_convert_config) *);
    pragma(inline, true)
    void nk_draw_foreach(nk_context *ctx, const(nk_buffer) *b, void delegate(const(nk_command)*) block) {
        for (auto c = nk__draw_begin(ctx, b); c != null; c = nk__draw_next(c, b, ctx)) {
            block(c);
        }
    }
}

/* User Input */
void                     nk_input_begin(nk_context*);
void                     nk_input_motion(nk_context*, int x, int y);
void                     nk_input_key(nk_context*, nk_keys, int down);
void                     nk_input_button(nk_context*, nk_buttons, int x, int y, int down);
void                     nk_input_scroll(nk_context*, float y);
void                     nk_input_char(nk_context*, char);
void                     nk_input_glyph(nk_context*, const nk_glyph);
void                     nk_input_unicode(nk_context*, nk_rune);
void                     nk_input_end(nk_context*);

/* Style */
void                     nk_style_default(nk_context*);
void                     nk_style_from_table(nk_context*, const(nk_color) *);
const(char) *              nk_style_color_name(nk_style_colors);
void                     nk_style_set_font(nk_context*, const(nk_user_font) *);

/* Utilities */
nk_rect           nk_widget_bounds(nk_context*);
nk_vec2           nk_widget_position(nk_context*);
nk_vec2           nk_widget_size(nk_context*);
int                      nk_widget_is_hovered(nk_context*);
int                      nk_widget_is_mouse_clicked(nk_context*, nk_buttons);
int                      nk_widget_has_mouse_click_down(nk_context*, nk_buttons, int down);
void                     nk_spacing(nk_context*, int cols);

/* base widget function  */
nk_widget_layout_states nk_widget(nk_rect*, const(nk_context) *);
nk_widget_layout_states nk_widget_fitting(nk_rect*, nk_context*, nk_vec2);

/* color (conversion user --> nuklear) */
nk_color          nk_rgb(int r, int g, int b);
nk_color          nk_rgb_iv(const(int) *rgb);
nk_color          nk_rgb_bv(const(nk_byte) * rgb);
nk_color          nk_rgb_f(float r, float g, float b);
nk_color          nk_rgb_fv(const(float) *rgb);
nk_color          nk_rgb_hex(const(char) *rgb);

nk_color          nk_rgba(int r, int g, int b, int a);
nk_color          nk_rgba_u32(nk_uint);
nk_color          nk_rgba_iv(const(int) *rgba);
nk_color          nk_rgba_bv(const(nk_byte) *rgba);
nk_color          nk_rgba_f(float r, float g, float b, float a);
nk_color          nk_rgba_fv(const(float) *rgba);
nk_color          nk_rgba_hex(const(char) *rgb);

nk_color          nk_hsv(int h, int s, int v);
nk_color          nk_hsv_iv(const(int) *hsv);
nk_color          nk_hsv_bv(const(nk_byte) *hsv);
nk_color          nk_hsv_f(float h, float s, float v);
nk_color          nk_hsv_fv(const(float) *hsv);

nk_color          nk_hsva(int h, int s, int v, int a);
nk_color          nk_hsva_iv(const(int) *hsva);
nk_color          nk_hsva_bv(const(nk_byte) *hsva);
nk_color          nk_hsva_f(float h, float s, float v, float a);
nk_color          nk_hsva_fv(const(float) *hsva);

/* color (conversion nuklear --> user) */
void                     nk_color_f(float *r, float *g, float *b, float *a, nk_color);
void                     nk_color_fv(float *rgba_out, nk_color);
nk_uint                  nk_color_u32(nk_color);
void                     nk_color_hex_rgba(char *output, nk_color);
void                     nk_color_hex_rgb(char *output, nk_color);

void                     nk_color_hsv_i(int *out_h, int *out_s, int *out_v, nk_color);
void                     nk_color_hsv_b(nk_byte *out_h, nk_byte *out_s, nk_byte *out_v, nk_color);
void                     nk_color_hsv_iv(int *hsv_out, nk_color);
void                     nk_color_hsv_bv(nk_byte *hsv_out, nk_color);
void                     nk_color_hsv_f(float *out_h, float *out_s, float *out_v, nk_color);
void                     nk_color_hsv_fv(float *hsv_out, nk_color);

void                     nk_color_hsva_i(int *h, int *s, int *v, int *a, nk_color);
void                     nk_color_hsva_b(nk_byte *h, nk_byte *s, nk_byte *v, nk_byte *a, nk_color);
void                     nk_color_hsva_iv(int *hsva_out, nk_color);
void                     nk_color_hsva_bv(nk_byte *hsva_out, nk_color);
void                     nk_color_hsva_f(float *out_h, float *out_s, float *out_v, float *out_a, nk_color);
void                     nk_color_hsva_fv(float *hsva_out, nk_color);

/* image */
nk_handle                nk_handle_ptr(void*);
nk_handle                nk_handle_id(int);
nk_image          nk_image_ptr(void*);
nk_image          nk_image_id(int);
int                      nk_image_is_subimage(const(nk_image) * img);
nk_image          nk_subimage_ptr(void*, ushort w, ushort h, nk_rect sub_region);
nk_image          nk_subimage_id(int, ushort w, ushort h, nk_rect sub_region);

/* math */
nk_hash                  nk_murmur_hash(const(void) *key, int len, nk_hash seed);
void                     nk_triangle_from_direction(nk_vec2 *result, nk_rect r, float pad_x, float pad_y, nk_heading);

pragma(mangle, "nk_vec2")
nk_vec2           nk_vec2_(float x, float y);
pragma(mangle, "nk_vec2i")
nk_vec2           nk_vec2i_(int x, int y);
nk_vec2           nk_vec2v(const(float) *xy);
nk_vec2           nk_vec2iv(const(int) *xy);

nk_rect           nk_get_null_rect();
pragma(mangle, "nk_rect")
nk_rect           nk_rect_(float x, float y, float w, float h);
pragma(mangle, "nk_recti")
nk_rect           nk_recti_(int x, int y, int w, int h);
nk_rect           nk_recta(nk_vec2 pos, nk_vec2 size);
nk_rect           nk_rectv(const(float) *xywh);
nk_rect           nk_rectiv(const(int) *xywh);
nk_vec2           nk_rect_pos(nk_rect);
nk_vec2           nk_rect_size(nk_rect);

/* string*/
int                      nk_strlen(const(char) *str);
int                      nk_stricmp(const(char) *s1, const(char) *s2);
int                      nk_stricmpn(const(char) *s1, const(char) *s2, int n);
int                      nk_strtof(float *number, const(char) *buffer);
int                      nk_strfilter(const(char) *text, const(char) *regexp);
int                      nk_strmatch_fuzzy_string(const(char) *str, const(char) *pattern, int *out_score);
int                      nk_strmatch_fuzzy_text(const(char) *txt, int txt_len, const(char) *pattern, int *out_score);

version (NK_INCLUDE_STANDARD_IO) {
int                      nk_strfmt(char *buf, int len, const(char) *fmt,...);
}

/* UTF-8 */
int                      nk_utf_decode(const(char) *, nk_rune*, int);
int                      nk_utf_encode(nk_rune, char*, int);
int                      nk_utf_len(const(char) *, int byte_len);
const(char) *            nk_utf_at(const(char) *buffer, int length, int index, nk_rune *unicode, int *len);

/* ==============================================================
 *
 *                          MEMORY BUFFER
 *
 * ===============================================================*/
/*  A basic (double)-buffer with linear allocation and resetting as only
    freeing policy. The buffers main purpose is to control all memory management
    inside the GUI toolkit and still leave memory control as much as possible in
    the hand of the user while also making sure the library is easy to use if
    not as much control is needed.
    In general all memory inside this library can be provided from the user in
    three different ways.

    The first way and the one providing most control is by just passing a fixed
    size memory block. In this case all control lies in the hand of the user
    since he can exactly control where the memory comes from and how much memory
    the library should consume. Of course using the fixed size API removes the
    ability to automatically resize a buffer if not enough memory is provided so
    you have to take over the resizing. While being a fixed sized buffer sounds
    quite limiting, it is very effective in this library since the actual memory
    consumption is quite stable and has a fixed upper bound for a lot of cases.

    If you don't want to think about how much memory the library should allocate
    at all time or have a very dynamic UI with unpredictable memory consumption
    habits but still want control over memory allocation you can use the dynamic
    allocator based API. The allocator consists of two callbacks for allocating
    and freeing memory and optional userdata so you can plugin your own allocator.

    The final and easiest way can be used by defining
    NK_INCLUDE_DEFAULT_ALLOCATOR which uses the standard library memory
    allocation functions malloc and free and takes over complete control over
    memory in this library.
*/
struct nk_memory_status {
    void *memory;
    uint type;
    nk_size size;
    nk_size allocated;
    nk_size needed;
    nk_size calls;
};

enum nk_allocation_type {
    NK_BUFFER_FIXED,
    NK_BUFFER_DYNAMIC
};

enum nk_buffer_allocation_type {
    NK_BUFFER_FRONT,
    NK_BUFFER_BACK,
    NK_BUFFER_MAX
};

struct nk_buffer_marker {
    int active;
    nk_size offset;
};

struct nk_memory {void *ptr;nk_size size;};
struct nk_buffer {
    nk_buffer_marker[nk_buffer_allocation_type.NK_BUFFER_MAX] marker;
    /* buffer marker to free a buffer to a certain offset */
    nk_allocator pool;
    /* allocator callback for dynamic buffers */
    nk_allocation_type type;
    /* memory management type */
    nk_memory memory;
    /* memory and size of the current memory block */
    float grow_factor;
    /* growing factor for dynamic memory management */
    nk_size allocated;
    /* total amount of memory allocated */
    nk_size needed;
    /* totally consumed memory given that enough memory is present */
    nk_size calls;
    /* number of allocation calls */
    nk_size size;
    /* current size of the buffer */
};

version (NK_INCLUDE_DEFAULT_ALLOCATOR) {
    void nk_buffer_init_default(nk_buffer*);
}
void nk_buffer_init(nk_buffer*, const(nk_allocator) *, nk_size size);
void nk_buffer_init_fixed(nk_buffer*, void *memory, nk_size size);
void nk_buffer_info(nk_memory_status*, nk_buffer*);
void nk_buffer_push(nk_buffer*, nk_buffer_allocation_type type, void *memory, nk_size size, nk_size align_);
void nk_buffer_mark(nk_buffer*, nk_buffer_allocation_type type);
void nk_buffer_reset(nk_buffer*, nk_buffer_allocation_type type);
void nk_buffer_clear(nk_buffer*);
void nk_buffer_free(nk_buffer*);
void *nk_buffer_memory(nk_buffer*);
const(void) *nk_buffer_memory_const(const(nk_buffer) *);
nk_size nk_buffer_total(nk_buffer*);

/* ==============================================================
 *
 *                          STRING
 *
 * ===============================================================*/
/*  Basic string buffer which is only used in context with the text editor
 *  to manage and manipulate dynamic or fixed size string content. This is _NOT_
 *  the default string handling method.*/
struct nk_str {
    nk_buffer buffer;
    int len; /* in codepoints/runes/glyphs */
};

version (NK_INCLUDE_DEFAULT_ALLOCATOR) {
    void nk_str_init_default(nk_str*);
}

void nk_str_init(nk_str*, const(nk_allocator) *, nk_size size);
void nk_str_init_fixed(nk_str*, void *memory, nk_size size);
void nk_str_clear(nk_str*);
void nk_str_free(nk_str*);

int nk_str_append_text_char(nk_str*, const(char) *, int);
int nk_str_append_str_char(nk_str*, const(char) *);
int nk_str_append_text_utf8(nk_str*, const(char) *, int);
int nk_str_append_str_utf8(nk_str*, const(char) *);
int nk_str_append_text_runes(nk_str*, const(nk_rune) *, int);
int nk_str_append_str_runes(nk_str*, const(nk_rune) *);

int nk_str_insert_at_char(nk_str*, int pos, const(char) *, int);
int nk_str_insert_at_rune(nk_str*, int pos, const(char) *, int);

int nk_str_insert_text_char(nk_str*, int pos, const(char) *, int);
int nk_str_insert_str_char(nk_str*, int pos, const(char) *);
int nk_str_insert_text_utf8(nk_str*, int pos, const(char) *, int);
int nk_str_insert_str_utf8(nk_str*, int pos, const(char) *);
int nk_str_insert_text_runes(nk_str*, int pos, const(nk_rune) *, int);
int nk_str_insert_str_runes(nk_str*, int pos, const(nk_rune) *);

void nk_str_remove_chars(nk_str*, int len);
void nk_str_remove_runes(nk_str *str, int len);
void nk_str_delete_chars(nk_str*, int pos, int len);
void nk_str_delete_runes(nk_str*, int pos, int len);

char *nk_str_at_char(nk_str*, int pos);
char *nk_str_at_rune(nk_str*, int pos, nk_rune *unicode, int *len);
nk_rune nk_str_rune_at(const(nk_str) *, int pos);
const(char) *nk_str_at_char_const(const(nk_str) *, int pos);
const(char) *nk_str_at_const(const(nk_str) *, int pos, nk_rune *unicode, int *len);

char *nk_str_get(nk_str*);
const(char) *nk_str_get_const(const(nk_str) *);
int nk_str_len(nk_str*);
int nk_str_len_char(nk_str*);

/*===============================================================
 *
 *                      TEXT EDITOR
 *
 * ===============================================================*/
/* Editing text in this library is handled by either `nk_edit_string` or
 * `nk_edit_buffer`. But like almost everything in this library there are multiple
 * ways of doing it and a balance between control and ease of use with memory
 * as well as functionality controlled by flags.
 *
 * This library generally allows three different levels of memory control:
 * First of is the most basic way of just providing a simple char array with
 * string length. This method is probably the easiest way of handling simple
 * user text input. Main upside is complete control over memory while the biggest
 * downside in comparsion with the other two approaches is missing undo/redo.
 *
 * For UIs that require undo/redo the second way was created. It is based on
 * a fixed size nk_text_edit struct, which has an internal undo/redo stack.
 * This is mainly useful if you want something more like a text editor but don't want
 * to have a dynamically growing buffer.
 *
 * The final ways is using a dynamically growing nk_text_edit struct, which
 * has both a default version if you don't care were memory comes from and a
 * allocator version if you do. While the text editor is quite powerful for its
 * complexity I would not recommend editing gigabytes of data with it.
 * It is rather designed for uses cases which make sense for a GUI library not for
 * an full blown text editor.
 */
enum NK_TEXTEDIT_UNDOSTATECOUNT     = 99;

enum NK_TEXTEDIT_UNDOCHARCOUNT      = 999;

struct nk_clipboard {
    nk_handle userdata;
    nk_paste_f paste;
    nk_copy_f copy;
};

struct nk_text_undo_record {
   int where;
   short insert_length;
   short delete_length;
   short char_storage;
};

struct nk_text_undo_state {
   nk_text_undo_record undo_rec[NK_TEXTEDIT_UNDOSTATECOUNT];
   nk_rune undo_char[NK_TEXTEDIT_UNDOCHARCOUNT];
   short undo_point;
   short redo_point;
   short undo_char_point;
   short redo_char_point;
};

enum nk_text_edit_type {
    NK_TEXT_EDIT_SINGLE_LINE,
    NK_TEXT_EDIT_MULTI_LINE
};

enum nk_text_edit_mode {
    NK_TEXT_EDIT_MODE_VIEW,
    NK_TEXT_EDIT_MODE_INSERT,
    NK_TEXT_EDIT_MODE_REPLACE
};

struct nk_text_edit {
    nk_clipboard clip;
    nk_str string;
    nk_filter filter;
    nk_vec2 scrollbar;

    int cursor;
    int select_start;
    int select_end;
    ubyte mode;
    ubyte cursor_at_end_of_line;
    ubyte initialized;
    ubyte has_preferred_x;
    ubyte single_line;
    ubyte active;
    ubyte padding1;
    float preferred_x;
    nk_text_undo_state undo;
};

/* filter function */
int nk_filter_default(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_ascii(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_float(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_decimal(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_hex(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_oct(const(nk_text_edit) *, nk_rune unicode);
int nk_filter_binary(const(nk_text_edit) *, nk_rune unicode);

/* text editor */
version (NK_INCLUDE_DEFAULT_ALLOCATOR) {
    void nk_textedit_init_default(nk_text_edit*);
}

void nk_textedit_init(nk_text_edit*, nk_allocator*, nk_size size);
void nk_textedit_init_fixed(nk_text_edit*, void *memory, nk_size size);
void nk_textedit_free(nk_text_edit*);
void nk_textedit_text(nk_text_edit*, const(char) *, int total_len);
void nk_textedit_delete(nk_text_edit*, int where, int len);
void nk_textedit_delete_selection(nk_text_edit*);
void nk_textedit_select_all(nk_text_edit*);
int nk_textedit_cut(nk_text_edit*);
int nk_textedit_paste(nk_text_edit*, const(char) *, int len);
void nk_textedit_undo(nk_text_edit*);
void nk_textedit_redo(nk_text_edit*);

/* ===============================================================
 *
 *                          FONT
 *
 * ===============================================================*/
/*  Font handling in this library was designed to be quite customizable and lets
    you decide what you want to use and what you want to provide. In this sense
    there are four different degrees between control and ease of use and two
    different drawing APIs to provide for.

    So first of the easiest way to do font handling is by just providing a
    `nk_user_font` which only requires the height in pixel of the used
    font and a callback to calculate the width of a string. This way of handling
    fonts is best fitted for using the normal draw shape command API were you
    do all the text drawing yourself and the library does not require any kind
    of deeper knowledge about which font handling mechanism you use.

    While the first approach works fine if you don't want to use the optional
    vertex buffer output it is not enough if you do. To get font handling working
    for these cases you have to provide two additional parameter inside the
    `nk_user_font`. First a texture atlas handle used to draw text as subimages
    of a bigger font atlas texture and a callback to query a characters glyph
    information (offset, size, ...). So it is still possible to provide your own
    font and use the vertex buffer output.

    The final approach if you do not have a font handling functionality or don't
    want to use it in this library is by using the optional font baker. This API
    is divided into a high- and low-level API with different priorities between
    ease of use and control. Both API's can be used to create a font and
    font atlas texture and can even be used with or without the vertex buffer
    output. So it still uses the `nk_user_font` and the two different
    approaches previously stated still work.
    Now to the difference between the low level API and the high level API. The low
    level API provides a lot of control over the baking process of the font and
    provides total control over memory. It consists of a number of functions that
    need to be called from begin to end and each step requires some additional
    configuration, so it is a lot more complex than the high-level API.
    If you don't want to do all the work required for using the low-level API
    you can use the font atlas API. It provides the same functionality as the
    low-level API but takes away some configuration and all of memory control and
    in term provides a easier to use API.
*/
struct nk_user_font_glyph;
alias nk_text_width_f = float function(nk_handle, float h, const(char) *, int len);
alias nk_query_font_glyph_f = void function(nk_handle handle, float font_height,
                                    nk_user_font_glyph *glyph,
                                    nk_rune codepoint, nk_rune next_codepoint);

version (NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
    struct nk_user_font_glyph {
        nk_vec2[2] uv;
        /* texture coordinates */
        nk_vec2 offset;
        /* offset between top left and glyph */
        float width, height;
        /* size of the glyph  */
        float xadvance;
        /* offset to the next glyph */
    };
}

struct nk_user_font {
    nk_handle userdata;
    /* user provided font handle */
    float height;
    /* max height of the font */
    nk_text_width_f width;
    /* font string width in pixel callback */
version (NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
    nk_query_font_glyph_f query;
    /* font glyph callback to query drawing info */
    nk_handle texture;
    /* texture handle to the used font atlas or texture */
}
};

version (NK_INCLUDE_FONT_BAKING) {
    enum nk_font_coord_type {
        NK_COORD_UV,
        /* texture coordinates inside font glyphs are clamped between 0-1 */
        NK_COORD_PIXEL
        /* texture coordinates inside font glyphs are in absolute pixel */
    };

struct nk_baked_font {
    float height;
    /* height of the font  */
    float ascent, descent;
    /* font glyphs ascent and descent  */
    nk_rune glyph_offset;
    /* glyph array offset inside the font glyph baking output array  */
    nk_rune glyph_count;
    /* number of glyphs of this font inside the glyph baking array output */
    const(nk_rune) *ranges;
    /* font codepoint ranges as pairs of (from/to) and 0 as last element */
};

struct nk_font_config {
    void *ttf_blob;
    /* pointer to loaded TTF file memory block.
     * NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file. */
    nk_size ttf_size;
    /* size of the loaded TTF file memory block
     * NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file. */

    ubyte ttf_data_owned_by_atlas;
    /* used inside font atlas: default to: 0*/
    ubyte merge_mode;
    /* merges this font into the last font */
    ubyte pixel_snap;
    /* align very character to pixel boundary (if true set oversample (1,1)) */
    ubyte oversample_v, oversample_h;
    /* rasterize at hight quality for sub-pixel position */
    ubyte padding[3];

    float size;
    /* baked pixel height of the font */
    enum nk_font_coord_type coord_type;
    /* texture coordinate format with either pixel or UV coordinates */
    nk_vec2 spacing;
    /* extra pixel spacing between glyphs  */
    const(nk_rune) *range;
    /* list of unicode ranges (2 values per range, zero terminated) */
    nk_baked_font *font;
    /* font to setup in the baking process: NOTE: not needed for font atlas */
    nk_rune fallback_glyph;
    /* fallback glyph to use if a given rune is not found */
};

struct nk_font_glyph {
    nk_rune codepoint;
    float xadvance;
    float x0, y0, x1, y1, w, h;
    float u0, v0, u1, v1;
};

struct nk_font {
    nk_user_font handle;
    nk_baked_font info;
    float scale;
    nk_font_glyph *glyphs;
    const(nk_font_glyph) *fallback;
    nk_rune fallback_codepoint;
    nk_handle texture;
    int config;
};

enum nk_font_atlas_format {
    NK_FONT_ATLAS_ALPHA8,
    NK_FONT_ATLAS_RGBA32
};

struct nk_font_atlas {
    void *pixel;
    int tex_width;
    int tex_height;
    nk_allocator permanent;
    nk_allocator temporary;
    nk_recti custom;

    int glyph_count;
    nk_font *default_font;
    nk_font_glyph *glyphs;
    nk_font **fonts;
    nk_font_config *config;
    int font_num, font_cap;
};

/* some language glyph codepoint ranges */
const(nk_rune) *nk_font_default_glyph_ranges(void);
const(nk_rune) *nk_font_chinese_glyph_ranges(void);
const(nk_rune) *nk_font_cyrillic_glyph_ranges(void);
const(nk_rune) *nk_font_korean_glyph_ranges(void);

/* Font Atlas
 * ---------------------------------------------------------------
 * This is the high level font baking and handling API to generate an image
 * out of font glyphs used to draw text onto the screen. This API takes away
 * some control over the baking process like fine grained memory control and
 * custom baking data but provides additional functionality and easier to
 * use and manage data structures and functions. */
version (NK_INCLUDE_DEFAULT_ALLOCATOR) {
    void nk_font_atlas_init_default(nk_font_atlas*);
}

void nk_font_atlas_init(nk_font_atlas*, nk_allocator*);
void nk_font_atlas_init_custom(nk_font_atlas*, nk_allocator *persistent, nk_allocator *transient);
void nk_font_atlas_begin(nk_font_atlas*);
nk_font_config nk_font_config(float pixel_height);
nk_font *nk_font_atlas_add(nk_font_atlas*, const(nk_font_config) *);

version (NK_INCLUDE_DEFAULT_FONT) {
    nk_font* nk_font_atlas_add_default(nk_font_atlas*, float height, const(nk_font_config) *);
}

nk_font* nk_font_atlas_add_from_memory(nk_font_atlas *atlas, void *memory, nk_size size, float height, const(nk_font_config) *config);

version (NK_INCLUDE_STANDARD_IO) {
    nk_font* nk_font_atlas_add_from_file(nk_font_atlas *atlas, const(char) *file_path, float height, const(nk_font_config) *);
}

nk_font *nk_font_atlas_add_compressed(nk_font_atlas*, void *memory, nk_size size, float height, const(nk_font_config) *);
nk_font* nk_font_atlas_add_compressed_base85(nk_font_atlas*, const(char) *data, float height, const(nk_font_config) *config);
const(void) * nk_font_atlas_bake(nk_font_atlas*, int *width, int *height, nk_font_atlas_format);
void nk_font_atlas_end(nk_font_atlas*, nk_handle tex, nk_draw_null_texture*);
void nk_font_atlas_clear(nk_font_atlas*);

/* Font
 * -----------------------------------------------------------------
 * The font structure is just a simple container to hold the output of a baking
 * process in the low level API. */
void nk_font_init(nk_font*, float pixel_height, nk_rune fallback_codepoint, nk_font_glyph*, const(nk_baked_font) *, nk_handle atlas);
const(nk_font_glyph) * nk_font_find_glyph(nk_font*, nk_rune unicode);

/* Font baking (needs to be called sequentially top to bottom)
 * --------------------------------------------------------------------
 * This is a low level API to bake font glyphs into an image and is more
 * complex than the atlas API but provides more control over the baking
 * process with custom bake data and memory management. */
void nk_font_bake_memory(nk_size *temporary_memory, int *glyph_count, nk_font_config*, int count);
int nk_font_bake_pack(nk_size *img_memory, int *img_width, int *img_height, nk_recti *custom_space, void *temporary_memory, nk_size temporary_size, const(nk_font_config) *, int font_count, nk_allocator *alloc);
void nk_font_bake(void *image_memory, int image_width, int image_height, void *temporary_memory, nk_size temporary_memory_size, nk_font_glyph*, int glyphs_count, const(nk_font_config) *, int font_count);
void nk_font_bake_custom_data(void *img_memory, int img_width, int img_height, nk_recti img_dst, const(char) *image_data_mask, int tex_width, int tex_height,char white,char black);
void nk_font_bake_convert(void *out_memory, int image_width, int image_height, const(void) *in_memory);

} // version NK_INCLUDE_FONT_BAKING

/* ===============================================================
 *
 *                          DRAWING
 *
 * ===============================================================*/
/*  This library was designed to be render backend agnostic so it does
    not draw anything to screen. Instead all drawn shapes, widgets
    are made of, are buffered into memory and make up a command queue.
    Each frame therefore fills the command buffer with draw commands
    that then need to be executed by the user and his own render backend.
    After that the command buffer needs to be cleared and a new frame can be
    started. It is probably important to note that the command buffer is the main
    drawing API and the optional vertex buffer API only takes this format and
    converts it into a hardware accessible format.

    Draw commands are divided into filled shapes and shape outlines but only
    filled shapes as well as line, curves and scissor are required to be provided.
    All other shape drawing commands can be used but are not required. This was
    done to allow the maximum number of render backends to be able to use this
    library without you having to do additional work.
*/
enum nk_command_type {
    NK_COMMAND_NOP,
    NK_COMMAND_SCISSOR,
    NK_COMMAND_LINE,
    NK_COMMAND_CURVE,
    NK_COMMAND_RECT,
    NK_COMMAND_RECT_FILLED,
    NK_COMMAND_RECT_MULTI_COLOR,
    NK_COMMAND_CIRCLE,
    NK_COMMAND_CIRCLE_FILLED,
    NK_COMMAND_ARC,
    NK_COMMAND_ARC_FILLED,
    NK_COMMAND_TRIANGLE,
    NK_COMMAND_TRIANGLE_FILLED,
    NK_COMMAND_POLYGON,
    NK_COMMAND_POLYGON_FILLED,
    NK_COMMAND_POLYLINE,
    NK_COMMAND_TEXT,
    NK_COMMAND_IMAGE
};

/* command base and header of every command inside the buffer */
struct nk_command {
    nk_command_type type;
    nk_size next;
    version (NK_INCLUDE_COMMAND_USERDATA) {
        nk_handle userdata;
    }
};

struct nk_command_scissor {
    nk_command header;
    short x, y;
    ushort w, h;
};

struct nk_command_line {
    nk_command header;
    ushort line_thickness;
    nk_vec2i begin;
    nk_vec2i end;
    nk_color color;
};

struct nk_command_curve {
    nk_command header;
    ushort line_thickness;
    nk_vec2i begin;
    nk_vec2i end;
    nk_vec2i ctrl[2];
    nk_color color;
};

struct nk_command_rect {
    nk_command header;
    ushort rounding;
    ushort line_thickness;
    short x, y;
    ushort w, h;
    nk_color color;
};

struct nk_command_rect_filled {
    nk_command header;
    ushort rounding;
    short x, y;
    ushort w, h;
    nk_color color;
};

struct nk_command_rect_multi_color {
    nk_command header;
    short x, y;
    ushort w, h;
    nk_color left;
    nk_color top;
    nk_color bottom;
    nk_color right;
};

struct nk_command_triangle {
    nk_command header;
    ushort line_thickness;
    nk_vec2i a;
    nk_vec2i b;
    nk_vec2i c;
    nk_color color;
};

struct nk_command_triangle_filled {
    nk_command header;
    nk_vec2i a;
    nk_vec2i b;
    nk_vec2i c;
    nk_color color;
};

struct nk_command_circle {
    nk_command header;
    short x, y;
    ushort line_thickness;
    ushort w, h;
    nk_color color;
};

struct nk_command_circle_filled {
    nk_command header;
    short x, y;
    ushort w, h;
    nk_color color;
};

struct nk_command_arc {
    nk_command header;
    short cx, cy;
    ushort r;
    ushort line_thickness;
    float a[2];
    nk_color color;
};

struct nk_command_arc_filled {
    nk_command header;
    short cx, cy;
    ushort r;
    float a[2];
    nk_color color;
};

struct nk_command_polygon {
    nk_command header;
    nk_color color;
    ushort line_thickness;
    ushort point_count;
    nk_vec2i points[1];
};

struct nk_command_polygon_filled {
    nk_command header;
    nk_color color;
    ushort point_count;
    nk_vec2i points[1];
};

struct nk_command_polyline {
    nk_command header;
    nk_color color;
    ushort line_thickness;
    ushort point_count;
    nk_vec2i points[1];
};

struct nk_command_image {
    nk_command header;
    short x, y;
    ushort w, h;
    nk_image img;
};

struct nk_command_text {
    nk_command header;
    const(nk_user_font) *font;
    nk_color background;
    nk_color foreground;
    short x, y;
    ushort w, h;
    float height;
    int length;
    char string[1];
};

enum nk_command_clipping {
    NK_CLIPPING_OFF = nk_false,
    NK_CLIPPING_ON = nk_true
};

struct nk_command_buffer {
    nk_buffer *base;
    nk_rect clip;
    int use_clipping;
    nk_handle userdata;
    nk_size begin, end, last;
};

/* shape outlines */
void nk_stroke_line(nk_command_buffer *b, float x0, float y0, float x1, float y1, float line_thickness, nk_color);
void nk_stroke_curve(nk_command_buffer*, float, float, float, float, float, float, float, float, float line_thickness, nk_color);
void nk_stroke_rect(nk_command_buffer*, nk_rect, float rounding, float line_thickness, nk_color);
void nk_stroke_circle(nk_command_buffer*, nk_rect, float line_thickness, nk_color);
void nk_stroke_arc(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, float line_thickness, nk_color);
void nk_stroke_triangle(nk_command_buffer*, float, float, float, float, float, float, float line_thichness, nk_color);
void nk_stroke_polyline(nk_command_buffer*, float *points, int point_count, float line_thickness, nk_color col);
void nk_stroke_polygon(nk_command_buffer*, float*, int point_count, float line_thickness, nk_color);

/* filled shades */
void nk_fill_rect(nk_command_buffer*, nk_rect, float rounding, nk_color);
void nk_fill_rect_multi_color(nk_command_buffer*, nk_rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
void nk_fill_circle(nk_command_buffer*, nk_rect, nk_color);
void nk_fill_arc(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, nk_color);
void nk_fill_triangle(nk_command_buffer*, float x0, float y0, float x1, float y1, float x2, float y2, nk_color);
void nk_fill_polygon(nk_command_buffer*, float*, int point_count, nk_color);

/* misc */
void nk_push_scissor(nk_command_buffer*, nk_rect);
void nk_draw_image(nk_command_buffer*, nk_rect, const(nk_image) *);
void nk_draw_text(nk_command_buffer*, nk_rect, const(char) *text, int len, const(nk_user_font) *, nk_color, nk_color);
const(nk_command) * nk__next(nk_context*, const(nk_command) *);
const(nk_command) * nk__begin(nk_context*);

/* ===============================================================
 *
 *                          INPUT
 *
 * ===============================================================*/
struct nk_mouse_button {
    int down;
    uint clicked;
    nk_vec2 clicked_pos;
};

struct nk_mouse {
    nk_mouse_button[nk_buttons.NK_BUTTON_MAX] buttons;
    nk_vec2 pos;
    nk_vec2 prev;
    nk_vec2 delta;
    float scroll_delta;
    ubyte grab;
    ubyte grabbed;
    ubyte ungrab;
};

struct nk_key {
    int down;
    uint clicked;
};

struct nk_keyboard {
    nk_key[nk_keys.NK_KEY_MAX] keys;
    char text[NK_INPUT_MAX];
    int text_len;
};

struct nk_input {
    nk_keyboard keyboard;
    nk_mouse mouse;
};

int nk_input_has_mouse_click(const(nk_input) *, nk_buttons);
int nk_input_has_mouse_click_in_rect(const(nk_input) *, nk_buttons, nk_rect);
int nk_input_has_mouse_click_down_in_rect(const(nk_input) *, nk_buttons, nk_rect, int down);
int nk_input_is_mouse_click_in_rect(const(nk_input) *, nk_buttons, nk_rect);
int nk_input_is_mouse_click_down_in_rect(const(nk_input) *i, nk_buttons id, nk_rect b, int down);
int nk_input_any_mouse_click_in_rect(const(nk_input) *, nk_rect);
int nk_input_is_mouse_prev_hovering_rect(const(nk_input) *, nk_rect);
int nk_input_is_mouse_hovering_rect(const(nk_input) *, nk_rect);
int nk_input_mouse_clicked(const(nk_input) *, nk_buttons, nk_rect);
int nk_input_is_mouse_down(const(nk_input) *, nk_buttons);
int nk_input_is_mouse_pressed(const(nk_input) *, nk_buttons);
int nk_input_is_mouse_released(const(nk_input) *, nk_buttons);
int nk_input_is_key_pressed(const(nk_input) *, nk_keys);
int nk_input_is_key_released(const(nk_input) *, nk_keys);
int nk_input_is_key_down(const(nk_input) *, nk_keys);


/* ===============================================================
 *
 *                          DRAW LIST
 *
 * ===============================================================*/
version (NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
/*  The optional vertex buffer draw list provides a 2D drawing context
    with antialiasing functionality which takes basic filled or outlined shapes
    or a path and outputs vertexes, elements and draw commands.
    The actual draw list API is not required to be used directly while using this
    library since converting the default library draw command output is done by
    just calling `nk_convert` but I decided to still make this library accessible
    since it can be useful.

    The draw list is based on a path buffering and polygon and polyline
    rendering API which allows a lot of ways to draw 2D content to screen.
    In fact it is probably more powerful than needed but allows even more crazy
    things than this library provides by default.
*/
alias nk_draw_index = ushort;
alias nk_draw_vertex_color = nk_uint;

enum nk_draw_list_stroke {
    NK_STROKE_OPEN = nk_false,
    /* build up path has no connection back to the beginning */
    NK_STROKE_CLOSED = nk_true
    /* build up path has a connection back to the beginning */
};

struct nk_draw_vertex {
    nk_vec2 position;
    nk_vec2 uv;
    nk_draw_vertex_color col;
};

struct nk_draw_command {
    uint elem_count;
    /* number of elements in the current draw batch */
    nk_rect clip_rect;
    /* current screen clipping rectangle */
    nk_handle texture;
    /* current texture to set */
version (NK_INCLUDE_COMMAND_USERDATA) {
    nk_handle userdata;
}
};

struct nk_draw_list {
    float global_alpha;
    nk_anti_aliasing shape_AA;
    nk_anti_aliasing line_AA;
    nk_draw_null_texture null_;
    nk_rect clip_rect;
    nk_buffer *buffer;
    nk_buffer *vertices;
    nk_buffer *elements;
    uint element_count;
    uint vertex_count;
    nk_size cmd_offset;
    uint cmd_count;
    uint path_count;
    uint path_offset;
    nk_vec2[12] circle_vtx;
version (NK_INCLUDE_COMMAND_USERDATA) {
    nk_handle userdata;
}
};

/* draw list */
void nk_draw_list_init(nk_draw_list*);
void nk_draw_list_setup(nk_draw_list*, float global_alpha, nk_anti_aliasing, nk_anti_aliasing, nk_draw_null_texture, nk_buffer *cmds, nk_buffer *vert, nk_buffer *elem);
void nk_draw_list_clear(nk_draw_list*);

/* drawing */
pragma(inline, true)
void nk_draw_list_foreach(const(nk_draw_list) *can, const(nk_buffer) *b, void delegate(const(nk_draw_command)*) block) {
    for (auto c = nk__draw_list_begin(can, b); c != null; c = nk__draw_list_next(c, b, can)) {
        block(c);
    }
}
const(nk_draw_command) * nk__draw_list_begin(const(nk_draw_list) *, const(nk_buffer) *);
const(nk_draw_command) * nk__draw_list_next(const(nk_draw_command) *, const(nk_buffer) *, const(nk_draw_list) *);
const(nk_draw_command) * nk__draw_begin(const(nk_context) *, const(nk_buffer) *);
const(nk_draw_command) * nk__draw_next(const(nk_draw_command) *, const(nk_buffer) *, const(nk_context) *);

/* path */
void nk_draw_list_path_clear(nk_draw_list*);
void nk_draw_list_path_line_to(nk_draw_list *list, nk_vec2 pos);
void nk_draw_list_path_arc_to_fast(nk_draw_list*, nk_vec2 center, float radius, int a_min, int a_max);
void nk_draw_list_path_arc_to(nk_draw_list*, nk_vec2 center, float radius, float a_min, float a_max, uint segments);
void nk_draw_list_path_rect_to(nk_draw_list*, nk_vec2 a, nk_vec2 b, float rounding);
void nk_draw_list_path_curve_to(nk_draw_list*, nk_vec2 p2, nk_vec2 p3, nk_vec2 p4, uint num_segments);
void nk_draw_list_path_fill(nk_draw_list*, nk_color);
void nk_draw_list_path_stroke(nk_draw_list*, nk_color, nk_draw_list_stroke closed, float thickness);

/* stroke */
void nk_draw_list_stroke_line(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_color, float thickness);
void nk_draw_list_stroke_rect(nk_draw_list*, nk_rect rect, nk_color, float rounding, float thickness);
void nk_draw_list_stroke_triangle(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color, float thickness);
void nk_draw_list_stroke_circle(nk_draw_list*, nk_vec2 center, float radius, nk_color, uint segs, float thickness);
void nk_draw_list_stroke_curve(nk_draw_list*, nk_vec2 p0, nk_vec2 cp0, nk_vec2 cp1, nk_vec2 p1, nk_color, uint segments, float thickness);
void nk_draw_list_stroke_poly_line(nk_draw_list*, const(nk_vec2) *pnts, const uint cnt, nk_color, nk_draw_list_stroke, float thickness, nk_anti_aliasing);

/* fill */
void nk_draw_list_fill_rect(nk_draw_list*, nk_rect rect, nk_color, float rounding);
void nk_draw_list_fill_rect_multi_color(nk_draw_list *list, nk_rect rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
void nk_draw_list_fill_triangle(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color);
void nk_draw_list_fill_circle(nk_draw_list*, nk_vec2 center, float radius, nk_color col, uint segs);
void nk_draw_list_fill_poly_convex(nk_draw_list*, const(nk_vec2) *points, const uint count, nk_color, nk_anti_aliasing);

/* misc */
void nk_draw_list_add_image(nk_draw_list*, nk_image texture, nk_rect rect, nk_color);
void nk_draw_list_add_text(nk_draw_list*, const(nk_user_font) *, nk_rect, const(char) *text, int len, float font_height, nk_color);

version (NK_INCLUDE_COMMAND_USERDATA) {
    void nk_draw_list_push_userdata(nk_draw_list*, nk_handle userdata);
}

} // version NK_INCLUDE_VERTEX_BUFFER_OUTPUT

/* ===============================================================
 *
 *                          GUI
 *
 * ===============================================================*/
enum nk_style_item_type {
    NK_STYLE_ITEM_COLOR,
    NK_STYLE_ITEM_IMAGE
};

union nk_style_item_data {
    nk_image image;
    nk_color color;
};

struct nk_style_item {
    nk_style_item_type type;
    nk_style_item_data data;
};

struct nk_style_text {
    nk_color color;
    nk_vec2 padding;
};

struct nk_style_button {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* text */
    nk_color text_background;
    nk_color text_normal;
    nk_color text_hover;
    nk_color text_active;
    nk_flags text_alignment;

    /* properties */
    float border;
    float rounding;
    nk_vec2 padding;
    nk_vec2 image_padding;
    nk_vec2 touch_padding;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle userdata) draw_begin;
    void function(nk_command_buffer*, nk_handle userdata) draw_end;
};

struct nk_style_toggle {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* cursor */
    nk_style_item cursor_normal;
    nk_style_item cursor_hover;

    /* text */
    nk_color text_normal;
    nk_color text_hover;
    nk_color text_active;
    nk_color text_background;
    nk_flags text_alignment;

    /* properties */
    nk_vec2 padding;
    nk_vec2 touch_padding;
    float spacing;
    float border;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_selectable {
    /* background (inactive) */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item pressed;

    /* background (active) */
    nk_style_item normal_active;
    nk_style_item hover_active;
    nk_style_item pressed_active;

    /* text color (inactive) */
    nk_color text_normal;
    nk_color text_hover;
    nk_color text_pressed;

    /* text color (active) */
    nk_color text_normal_active;
    nk_color text_hover_active;
    nk_color text_pressed_active;
    nk_color text_background;
    nk_flags text_alignment;

    /* properties */
    float rounding;
    nk_vec2 padding;
    nk_vec2 touch_padding;
    nk_vec2 image_padding;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_slider {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* background bar */
    nk_color bar_normal;
    nk_color bar_hover;
    nk_color bar_active;
    nk_color bar_filled;

    /* cursor */
    nk_style_item cursor_normal;
    nk_style_item cursor_hover;
    nk_style_item cursor_active;

    /* properties */
    float border;
    float rounding;
    float bar_height;
    nk_vec2 padding;
    nk_vec2 spacing;
    nk_vec2 cursor_size;

    /* optional buttons */
    int show_buttons;
    nk_style_button inc_button;
    nk_style_button dec_button;
    nk_symbol_type inc_symbol;
    nk_symbol_type dec_symbol;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_progress {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* cursor */
    nk_style_item cursor_normal;
    nk_style_item cursor_hover;
    nk_style_item cursor_active;
    nk_color cursor_border_color;

    /* properties */
    float rounding;
    float border;
    float cursor_border;
    float cursor_rounding;
    nk_vec2 padding;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_scrollbar {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* cursor */
    nk_style_item cursor_normal;
    nk_style_item cursor_hover;
    nk_style_item cursor_active;
    nk_color cursor_border_color;

    /* properties */
    float border;
    float rounding;
    float border_cursor;
    float rounding_cursor;
    nk_vec2 padding;

    /* optional buttons */
    int show_buttons;
    nk_style_button inc_button;
    nk_style_button dec_button;
    nk_symbol_type inc_symbol;
    nk_symbol_type dec_symbol;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_edit {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;
    nk_style_scrollbar scrollbar;

    /* cursor  */
    nk_color cursor_normal;
    nk_color cursor_hover;
    nk_color cursor_text_normal;
    nk_color cursor_text_hover;

    /* text (unselected) */
    nk_color text_normal;
    nk_color text_hover;
    nk_color text_active;

    /* text (selected) */
    nk_color selected_normal;
    nk_color selected_hover;
    nk_color selected_text_normal;
    nk_color selected_text_hover;

    /* properties */
    float border;
    float rounding;
    float cursor_size;
    nk_vec2 scrollbar_size;
    nk_vec2 padding;
    float row_padding;
};

struct nk_style_property {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* text */
    nk_color label_normal;
    nk_color label_hover;
    nk_color label_active;

    /* symbols */
    nk_symbol_type sym_left;
    nk_symbol_type sym_right;

    /* properties */
    float border;
    float rounding;
    nk_vec2 padding;

    nk_style_edit edit;
    nk_style_button inc_button;
    nk_style_button dec_button;

    /* optional user callbacks */
    nk_handle userdata;
    void function(nk_command_buffer*, nk_handle) draw_begin;
    void function(nk_command_buffer*, nk_handle) draw_end;
};

struct nk_style_chart {
    /* colors */
    nk_style_item background;
    nk_color border_color;
    nk_color selected_color;
    nk_color color;

    /* properties */
    float border;
    float rounding;
    nk_vec2 padding;
};

struct nk_style_combo {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;
    nk_color border_color;

    /* label */
    nk_color label_normal;
    nk_color label_hover;
    nk_color label_active;

    /* symbol */
    nk_color symbol_normal;
    nk_color symbol_hover;
    nk_color symbol_active;

    /* button */
    nk_style_button button;
    nk_symbol_type sym_normal;
    nk_symbol_type sym_hover;
    nk_symbol_type sym_active;

    /* properties */
    float border;
    float rounding;
    nk_vec2 content_padding;
    nk_vec2 button_padding;
    nk_vec2 spacing;
};

struct nk_style_tab {
    /* background */
    nk_style_item background;
    nk_color border_color;
    nk_color text;

    /* button */
    nk_style_button tab_maximize_button;
    nk_style_button tab_minimize_button;
    nk_style_button node_maximize_button;
    nk_style_button node_minimize_button;
    nk_symbol_type sym_minimize;
    nk_symbol_type sym_maximize;

    /* properties */
    float border;
    float rounding;
    float indent;
    nk_vec2 padding;
    nk_vec2 spacing;
};

enum nk_style_header_align {
    NK_HEADER_LEFT,
    NK_HEADER_RIGHT
};

struct nk_style_window_header {
    /* background */
    nk_style_item normal;
    nk_style_item hover;
    nk_style_item active;

    /* button */
    nk_style_button close_button;
    nk_style_button minimize_button;
    nk_symbol_type close_symbol;
    nk_symbol_type minimize_symbol;
    nk_symbol_type maximize_symbol;

    /* title */
    nk_color label_normal;
    nk_color label_hover;
    nk_color label_active;

    /* properties */
    nk_style_header_align align_;
    nk_vec2 padding;
    nk_vec2 label_padding;
    nk_vec2 spacing;
};

struct nk_style_window {
    nk_style_window_header header;
    nk_style_item fixed_background;
    nk_color background;

    nk_color border_color;
    nk_color combo_border_color;
    nk_color contextual_border_color;
    nk_color menu_border_color;
    nk_color group_border_color;
    nk_color tooltip_border_color;

    nk_style_item scaler;
    nk_vec2 footer_padding;

    float border;
    float combo_border;
    float contextual_border;
    float menu_border;
    float group_border;
    float tooltip_border;

    float rounding;
    nk_vec2 scaler_size;
    nk_vec2 padding;
    nk_vec2 spacing;
    nk_vec2 scrollbar_size;
    nk_vec2 min_size;
};

struct nk_style {
    nk_user_font font;
    nk_style_text text;
    nk_style_button button;
    nk_style_button contextual_button;
    nk_style_button menu_button;
    nk_style_toggle option;
    nk_style_toggle checkbox;
    nk_style_selectable selectable;
    nk_style_slider slider;
    nk_style_progress progress;
    nk_style_property property;
    nk_style_edit edit;
    nk_style_chart chart;
    nk_style_scrollbar scrollh;
    nk_style_scrollbar scrollv;
    nk_style_tab tab;
    nk_style_combo combo;
    nk_style_window window;
};

nk_style_item nk_style_item_image(nk_image img);
nk_style_item nk_style_item_color(nk_color);
nk_style_item nk_style_item_hide();

/*==============================================================
 *                          PANEL
 * =============================================================*/
enum NK_CHART_MAX_SLOT = 4;

struct nk_chart_slot {
    nk_chart_type type;
    nk_color color;
    nk_color highlight;
    float min, max, range;
    int count;
    nk_vec2 last;
    int index;
};

struct nk_chart {
    nk_chart_slot[NK_CHART_MAX_SLOT] slots;
    int slot;
    float x, y, w, h;
};

struct nk_row_layout {
    int type;
    int index;
    float height;
    int columns;
    const(float) *ratio;
    float item_width, item_height;
    float item_offset;
    float filled;
    nk_rect item;
    int tree_depth;
};

struct nk_popup_buffer {
    nk_size begin;
    nk_size parent;
    nk_size last;
    nk_size end;
    int active;
};

struct nk_menu_state {
    float x, y, w, h;
    nk_scroll offset;
};

struct nk_panel {
    nk_flags flags;
    nk_rect bounds;
    nk_scroll *offset;
    float at_x, at_y, max_x;
    float width, height;
    float footer_h;
    float header_h;
    float border;
	uint has_scrolling;
    nk_rect clip;
    nk_menu_state menu;
    nk_row_layout row;
    nk_chart chart;
    nk_popup_buffer popup_buffer;
    nk_command_buffer *buffer;
    nk_panel *parent;
};

/*==============================================================
 *                          WINDOW
 * =============================================================*/
struct nk_table;
enum nk_window_flags {
    NK_WINDOW_PRIVATE       = NK_FLAG(9),
    /* dummy flag which mark the beginning of the private window flag part */
    NK_WINDOW_ROM           = NK_FLAG(10),
    /* sets the window into a read only mode and does not allow input changes */
    NK_WINDOW_HIDDEN        = NK_FLAG(11),
    /* Hides the window and stops any window interaction and drawing can be set
     * by user input or by closing the window */
    NK_WINDOW_MINIMIZED     = NK_FLAG(12),
    /* marks the window as minimized */
    NK_WINDOW_SUB           = NK_FLAG(13),
    /* Marks the window as subwindow of another window*/
    NK_WINDOW_GROUP         = NK_FLAG(14),
    /* Marks the window as window widget group */
    NK_WINDOW_POPUP         = NK_FLAG(15),
    /* Marks the window as a popup window */
    NK_WINDOW_NONBLOCK      = NK_FLAG(16),
    /* Marks the window as a nonblock popup window */
    NK_WINDOW_CONTEXTUAL    = NK_FLAG(17),
    /* Marks the window as a combo box or menu */
    NK_WINDOW_COMBO         = NK_FLAG(18),
    /* Marks the window as a combo box */
    NK_WINDOW_MENU          = NK_FLAG(19),
    /* Marks the window as a menu */
    NK_WINDOW_TOOLTIP       = NK_FLAG(20),
    /* Marks the window as a menu */
    NK_WINDOW_REMOVE_ROM    = NK_FLAG(21)
    /* Removes the read only mode at the end of the window */
};

struct nk_popup_state {
    nk_window *win;
    nk_window_flags type;
    nk_hash name;
    int active;
    uint combo_count;
    uint con_count, con_old;
    uint active_con;
};

struct nk_edit_state {
    nk_hash name;
    uint seq;
    uint old;
    int active, prev;
    int cursor;
    int sel_start;
    int sel_end;
    nk_scroll scrollbar;
    ubyte mode;
    ubyte single_line;
};

struct nk_property_state {
    int active, prev;
    char buffer[NK_MAX_NUMBER_BUFFER];
    int length;
    int cursor;
    nk_hash name;
    uint seq;
    uint old;
    int state;
};

struct nk_window {
    uint seq;
    nk_hash name;
    nk_flags flags;
    nk_rect bounds;
    nk_scroll scrollbar;
    nk_command_buffer buffer;
    nk_panel *layout;

    /* persistent widget state */
    nk_property_state property;
    nk_popup_state popup;
    nk_edit_state edit;
	uint scrolled;

    nk_table *tables;
    ushort table_count;
    ushort table_size;

    /* window list hooks */
    nk_window *next;
    nk_window *prev;
    nk_window *parent;
};

/*==============================================================
 *                          CONTEXT
 * =============================================================*/
struct nk_page_element;
struct nk_context {
/* public: can be accessed freely */
    nk_input input;
    nk_style style;
    nk_buffer memory;
    nk_clipboard clip;
    nk_flags last_widget_state;

/* private:
    should only be accessed if you
    know what you are doing */
    version (NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        nk_draw_list draw_list;
    }
    version (NK_INCLUDE_COMMAND_USERDATA) {
        nk_handle userdata;
    }
    /* text editor objects are quite big because of an internal
     * undo/redo stack. Therefore does not make sense to have one for
     * each window for temporary use cases, so I only provide *one* instance
     * for all windows. This works because the content is cleared anyway */
    nk_text_edit text_edit;

    /* windows */
    int build;
    void *pool;
    nk_window *begin;
    nk_window *end;
    nk_window *active;
    nk_window *current;
    nk_page_element *freelist;
    uint count;
    uint seq;
};

} // extern (C)
