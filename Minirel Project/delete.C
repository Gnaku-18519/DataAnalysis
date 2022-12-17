#include "catalog.h"
#include "query.h"


/*
 * Deletes records from a specified relation.
 *
 * Returns:
 * 	OK on success
 * 	an error code otherwise
 */

const Status QU_Delete(const string & relation, 
		       const string & attrName, 
		       const Operator op,
		       const Datatype type, 
		       const char *attrValue)
{
    // delete all tuples in relation satisfying the predicate
    // validate, similar to destroy.C
    if (relation.empty() || relation == string(RELCATNAME) || relation == string(ATTRCATNAME)) {
        return BADCATPARM;
    }

    Status status;
    HeapFileScan *hfs = new HeapFileScan(relation, status); // similar to catalog.C
    if (status != OK) { return status; }
    void *filter;
    AttrDesc attrDesc;

    int tempInt; // these values need to be declated outside, as we will need their address
    float tempFloat;
    if (attrName == "") { // no condition given
        hfs->startScan(0, 0, type, NULL, op);
    }
    else {
        if (type == STRING) {
	    filter = (void*)attrValue;
	}
	else if (type == INTEGER) {
	    tempInt = atoi(attrValue);
	    filter = &tempInt;
	}
	else if (type == FLOAT) { // type == FLOAT
	    tempFloat = atof(attrValue);
	    filter = &tempFloat;
	}

	status = attrCat->getInfo(relation, attrName, attrDesc);
	if (status != OK) { return status; }

	hfs->startScan(attrDesc.attrOffset, attrDesc.attrLen, type, (char*)filter, op);
    }

    RID tempRid;
    while (status == OK) {
        status = hfs->scanNext(tempRid);
	if (status == FILEEOF) { // reach the end and cannot do further delete
	    break;
	}
	hfs->deleteRecord();
    }
    delete hfs;

    // part 6
    return OK;
}

