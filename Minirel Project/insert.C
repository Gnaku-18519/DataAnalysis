#include "catalog.h"
#include "query.h"


/*
 * Inserts a record into the specified relation.
 *
 * Returns:
 * 	OK on success
 * 	an error code otherwise
 */

const Status QU_Insert(const string & relation, 
	const int attrCnt, 
	const attrInfo attrList[])
{
    // insert a tuple with the given attribute values
    // validate attrInfo, might have NULL inside
    /*
    for (int i = 0; i < attrCnt; ++i) {
        if (attrList[i].attrValue == NULL) {
	    return ATTRNOTFOUND;
	}
    }
    */

    Status status;
    RelDesc rd;
    AttrDesc *attrs;
    int tempCnt;
    // similar to load.C
    // get relation data
    if ((status = relCat->getInfo(relation, rd)) != OK) return status;
    // get attribute data
    if ((status = attrCat->getRelInfo(rd.relName, tempCnt, attrs)) != OK) return status;

    int totalLength = 0; // initialize the record length for further computation
    for (int i = 0; i < attrCnt; ++i) {
        totalLength += attrs[i].attrLen;
    }
    
    // update the length and spaces needed, similar to join.C
    char outputData[totalLength];
    Record record;
    record.length = totalLength;
    record.data = &outputData;

    void *tempPtr;
    int recordOffset = 0;
    int tempInt; // these two values have to be outside the loop, as we will need their address
    float tempFloat;
    for (int i = 0; i < attrCnt; ++i) {
        for (int j = 0; j < attrCnt; ++j) {
	    if (strcmp(attrs[i].attrName, attrList[j].attrName) == 0) { // matching
                // generally, there shouldn't be any other attrType than 0, 1 or 2
		// but for safety, use if - else if - else if instead of if - else if - else
	        if (attrs[i].attrType == 0) { // string
		    tempPtr = attrList[j].attrValue;
		}
		else if (attrs[i].attrType == 1) { // integer
		    tempInt = atoi((char*)attrList[j].attrValue); // casting to char* is necessary to avoid error
		    tempPtr = &tempInt;
		}
		else if (attrs[i].attrType == 2) { // float
		    tempFloat = atof((char*)attrList[j].attrValue);
		    tempPtr = &tempFloat;
		}

		memcpy((char*)outputData + recordOffset, (char*)tempPtr, attrs[i].attrLen);
		recordOffset += attrs[i].attrLen;
	    }
	}
    }

    // similar to catalog.C
    InsertFileScan ifs(relation, status);
    RID tempRid;
    status = ifs.insertRecord(record, tempRid);
    if (status != OK) { return status; }

    // part 6
    return OK;
}

