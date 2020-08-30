import lxml.etree as et
from os.path import isdir, isfile, join
import os
import shutil


def merge(name):
    def copy(path):
        for data in os.listdir(path):
            data_path = join(path, data)
            if isfile(data_path):
                tree_source = et.parse(data_path, parser)
                root_source = tree_source.getroot()
                for child in root_source:
                    if child.tag == "changelog":
                        for entry in child:
                            desc_metadata.text = f"{desc_metadata.text}\n{entry.text}"
                    else:
                        root.append(child)
            elif isdir(data_path):
                copy(data_path)
    tree = et.parse("empty.xml", parser)
    root = tree.getroot()
    copy(join("data", name))
    tree.write(join("result", "data", f"{name}.xml"))


def transform(input_file, xslt_file, output_file):
    xslt_transform = et.XSLT(et.parse(xslt_file, parser))
    try:
        result = xslt_transform(et.parse(input_file, parser))
        with open(output_file, "wb") as result_file:
            result_file.write(et.tostring(result, pretty_print=True))
    except et.XSLTApplyError:
        for xslt_error in xslt_transform.error_log:
            print(xslt_error.message, xslt_error.line)
        raise


clear_files = ("autoBlueprints.xml", "bosses.xml", "dlcAnimations.xml", "dlcBlueprints.xml",
               "dlcBlueprintsOverwrite.xml", "dlcPirateBlueprints.xml", "dlcEvents.xml", "dlcEvents_anaerobic.xml",
               "dlcEventsOverwrite.xml", "events_boss.xml", "events_crystal.xml", "events_engi.xml", "events_fuel.xml",
               "events_imageList.xml", "events_mantis.xml", "events_nebula.xml", "events_pirate.xml",
               "events_rebel.xml", "events_rock.xml", "events_ships.xml", "events_slug.xml", "events_zoltan.xml",
               "nameEvents.xml", "newEvents.xml")

parser = et.XMLParser(remove_blank_text=True)

if isdir("result"):
    shutil.rmtree("result")

shutil.copytree("audio", join("result", "audio"))
shutil.copytree(join("data", "ships"), join("result", "data"))
shutil.copytree("img", join("result", "img"))

for file in os.listdir("data"):
    fullname = join("data", file)
    if isfile(fullname):
        shutil.copy(fullname, join("result", fullname))

tree_empty = et.parse("empty.xml", parser)
tree_metadata = et.parse(join("mod-appendix", "metadata.xml"), parser)
mod_title = f'{tree_metadata.getroot().findall("./title[1]")[0].text} {tree_metadata.getroot().findall("./version[1]")[0].text}'
desc_metadata = tree_metadata.getroot().findall("./description[1]")[0]

for clear_file in clear_files:
    tree_empty.write(join("result", "data", clear_file))

merge("animations")
merge("blueprints")
transform(join("result", "data", "blueprints.xml"),
          join("tools", "blueprints.xslt"),
          join("result", "data", "blueprints.xml"))
transform(join("result", "data", "blueprints.xml"),
          join("tools", "events_upgrade.xslt"),
          join("data", "events", "upgrade.xml"))

transform(join("result", "data", "animations.xml"),
          join("tools", "animations.xslt"),
          join("result", "data", "animations.xml"))
transform(join("result", "data", "sector_data.xml"),
          join("tools", "sector_data.xslt"),
          join("result", "data", "sector_data.xml"))
transform(join("result", "data", "rooms.xml"),
          join("tools", "rooms.xslt"),
          join("result", "data", "rooms.xml"))

merge("events")
# TODO check name collisions
transform(join("result", "data", "events.xml"),
          join("tools", "events", "text.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "text_events.xslt"),
          join("result", "data", "text_events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "text_delete.xslt"),
          join("result", "data", "events.xml"))

transform(join("result", "data", "events.xml"),
          join("tools", "events", "merge_eventlists.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "nest.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "teleporter_bug.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "engine_disabler.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "missile_recycler.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "count.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "optimize.xslt"),
          join("result", "data", "events.xml"))
transform(join("result", "data", "events.xml"),
          join("tools", "events", "sort.xslt"),
          join("result", "data", "events.xml"))

# TODO validate no events with choice but no text
schema_events = et.XMLSchema(et.parse(join("schema", "events.xsd")))
events = et.parse(join("result", "data", "events.xml"))
if not schema_events.validate(events):
    for error in schema_events.error_log:
        print(f"Line {error.line}: {error.message}")

if not isdir(join("result", "mod-appendix")):
    os.mkdir(join("result", "mod-appendix"))
with open(join("result", "mod-appendix", "metadata.xml"), "wb") as f:
    f.write(et.tostring(tree_metadata, pretty_print=True))

shutil.make_archive("result", 'zip', "result")
shutil.rmtree("result")
if isfile(f"{mod_title}.ftl"):
    os.remove(f"{mod_title}.ftl")
os.rename("result.zip", f"{mod_title}.ftl")
