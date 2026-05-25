from scad_export.export import export
from scad_export.exportable import Folder, Model

files=Folder(
    name='scad_export/ergodox_case',
    contents=[
        Model(name='bottom_right'),
        Model(name='bottom_left'),
        Model(name='top_right'),
        Model(name='top_left'),
        Model(name='electronics_cover_right'),
        Model(name='electronics_cover_left')
    ]
)

export(files)
