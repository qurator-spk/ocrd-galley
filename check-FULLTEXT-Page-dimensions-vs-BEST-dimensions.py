"""Check FULLTEXT ALTO page dimensions against BEST image dimensions"""

import PIL.Image
import sys
from ocrd.workspace import Workspace
from ocrd.resolver import Resolver
from lxml import etree as ET


def alto_namespace(tree):
    """
    Return the ALTO namespace used in the given ElementTree.

    This relies on the assumption that, in any given ALTO file, the root
    element has the local name "alto". We do not check if the files uses any
    valid ALTO namespace.
    """
    root_name = ET.QName(tree.getroot().tag)
    if root_name.localname == 'alto':
        return root_name.namespace
    else:
        raise ValueError('Not an ALTO tree')


exit_code = 0
workspace = Workspace(Resolver(), '.')

for n, page_id in enumerate(workspace.mets.physical_pages):
    gt_file = workspace.mets.find_files(fileGrp='FULLTEXT', pageId=page_id)[0]
    img_file = workspace.mets.find_files(fileGrp='BEST', pageId=page_id)[0]
    gt_file = workspace.download_file(gt_file)
    img_file = workspace.download_file(img_file)

    tree = ET.parse(gt_file.local_filename)
    nsmap = {'alto': alto_namespace(tree)}
    alto_page = tree.find('//alto:Page', namespaces=nsmap)  # one page assumed
    gt_size = int(alto_page.attrib['WIDTH']), int(alto_page.attrib['HEIGHT'])

    img_size = PIL.Image.open(img_file.local_filename).size

    if gt_size == img_size:
        print('OK', page_id)
    else:
        print('ERR', page_id, gt_size, '!=', img_size)
        exit_code = 1

sys.exit(exit_code)
