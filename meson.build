project('mconnect', 'vala', 'c')

# dependencies
glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')
gio_unix_dep = dependency('gio-unix-2.0')
json_glib_dep = dependency('json-glib-1.0')
gee_dep = dependency('gee-0.8')
libnotify_dep = dependency('libnotify')
gdk_dep = dependency('gdk-3.0')
gtk_dep = dependency('gtk+-3.0')
atspi_dep = dependency('atspi-2')
gnutls_dep = dependency('gnutls')
posix_dep = meson.get_compiler('vala').find_library('posix')


add_project_arguments(['--vapidir',
                       join_paths(meson.current_source_dir(), 'vapi')],
                      language: 'vala')


mconnectgui_src = [
  'src/mconnectgui/main.vala',
  'src/mconnectgui/device-manager-iface.vala',
  'src/mconnectgui/device-iface.vala',
  'src/mconnectgui/battery-iface.vala',
  'src/mconnectgui/share-iface.vala'
]
executable('mconnectgui', mconnectgui_src,
           dependencies : [gtk_dep,glib_dep, gobject_dep,
                           gio_dep, gio_unix_dep],
           install: true)
