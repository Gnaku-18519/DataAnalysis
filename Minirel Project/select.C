#include "catalog.h"
#include "query.h"
#include "stdio.h"
#include "stdlib.h"

// forward declaration
const Status ScanSelect(const string & result, 
			const int projCnt, 
			const AttrDesc projNames[],
			const AttrDesc *attrDesc, 
			const Operator op, 
			const char *filter,
			const int reclen);

/*
 * Selects records from the specified relation.
 *
 * Returns:
 * 	OK on success
 * 	an error code otherwise
 */

const Status QU_Select(const string & result, 
		       const int projCnt, 
		       const attrInfo projNames[],
		       const attrInfo *attr, 
		       const Operator op, 
		       const char *attrValue)
{
    // Qu_Select sets up things and then calls ScanSelect to do the actual work
    cout << "Doing QU_Select " << endl;

    // split cases, update variables, and the "real work" is done by ScanSelect
    Status status;
    int attrCnt, reclen = 0, attrIdx;
    AttrDesc *attrDescArray, projAttrDesc[projCnt];

    // check attribute type when attr is not NULL
    if ((attr != NULL) && (attr->attrType < 0 || attr->attrType > 2)) {
        return ATTRTYPEMISMATCH;
    }

    // get attribute data 
    if ((status = attrCat->getRelInfo(projNames[0].relName, attrCnt, attrDescArray)) != OK) {
        return status;
    }

    for (int i = 0; i < attrCnt; ++i) {
        for (int j = 0; j < projCnt; ++j) {
            // check if attibute belongs to projection
	    if (strcmp(attrDescArray[i].attrName, projNames[j].attrName) == 0) {
	        // get output attribute description from attrdesc structures
		projAttrDesc[j] = attrDescArray[i];

		// get output record length from attrdesc structures
		reclen += attrDescArray[i].attrLen;
	    }
	}

	// update attrIdx for ScanSelect input
	if (attr != NULL && strcmp(attrDescArray[i].attrName, attr->attrName) == 0) {
	    attrIdx = i;
	}
    }

    // we cannot put this case at the beginning, as we need to update projAttrDesc
    if (attr == NULL) { // unconditional scan
        return ScanSelect(result, projCnt, projAttrDesc, &projAttrDesc[0], EQ, NULL, reclen);
    }
    return ScanSelect(result, projCnt, projAttrDesc, &attrDescArray[attrIdx], op, attrValue, reclen);
}


const Status ScanSelect(const string & result, 
			const int projCnt, 
			const AttrDesc projNames[],
			const AttrDesc *attrDesc, 
			const Operator op, 
			const char *filter,
			const int reclen)
{
    cout << "Doing HeapFileScan Selection using ScanSelect()" << endl;
   
    Status status;
   
    InsertFileScan insertResult(result, status);
    if (status != OK) { return status; }
    HeapFileScan heapResult(projNames[0].relName, status);
    if (status != OK) { return status; }

    void *newFilter;
    int tempInt; // these values need to be declare outside, as we need their address
    float tempFloat;
    if (filter == NULL) { // sequential scan
        Datatype type; // we cannot initialize this -- then how to avoid "warning: ‘type’ may be used uninitialized [-Wmaybe-uninitialized]"?
	status = heapResult.startScan(attrDesc->attrOffset, attrDesc->attrLen, type, NULL, op);
    }
    else { // as we have filtered the cases in QU_Select, here it can only be 0, 1 or 2
	Datatype type;
	if (attrDesc->attrType == 0) {
	    type = STRING;
            newFilter = (void*)filter;
	}
	else if (attrDesc->attrType == 1) {
	    type = INTEGER;
	    tempInt = atoi(filter);
	    newFilter = &tempInt;
	}
	else {
	    type = FLOAT;
	    tempFloat = atof(filter);
	    newFilter = &tempFloat;
	}

	status = heapResult.startScan(attrDesc->attrOffset, attrDesc->attrLen, type, (char*)newFilter, op);
    }
    if (status != OK) { return status; }

    RID rid;
    int outputOffset;
    char outputData[reclen];
    Record resultRecord, tempRecord;
    resultRecord.data = (void*)outputData;
    resultRecord.length = reclen;
    while (heapResult.scanNext(rid) == OK) { // matching the search criteria
        status = heapResult.getRecord(tempRecord);
	if (status != OK) { return status; }

	// create a new record
	outputOffset = 0;
	for (int i = 0; i < projCnt; ++i) {
	    memcpy(outputData + outputOffset, (char *)tempRecord.data + projNames[i].attrOffset, projNames[i].attrLen);
            outputOffset += projNames[i].attrLen;
	}

	// store the new record
	RID tempRID;
	status = insertResult.insertRecord(resultRecord, tempRID);
	if (status != OK) { return status; }
    }

    return OK;
}
