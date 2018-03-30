Feature: Unmatched Invoice Handling API - Scenario 12
Description: TXN E2E
 - Unmatched Invoice Handling = Keep
 - Invoice References = Many
 - Data Source = REM_WH_REF_ITEM
 - Invoice Id exists in REF_ITEM = Yes, New record found by CCMP
Introduced By: EDGE-15005
Last Modified By: EDGE-15005

Scenario: Scenario 12
	Given the following CUST table info:
	| CUST_ID | PARNT_CUST_ID | UNMTCH_INV_HNDL_CD |
	| 44460   | 44440         | 2                  |
	| 44440   |               | 0                  |

	Given the following CUST_REF_TYPE table info:
	| CUST_ID | SEQ_ID | REF_TYPE_ID | IR_REF_TYPE_ID |
	| 44460   | 1      | 9001        | 18             |
	| 44460   | 4      | 9002        | 7              |
	| 44460   | 5      | 9008        | 20             |
	| 44460   | 7      | 9039        | 1              |

	Given the following IR_REF_TYPE table info:
	| IR_REF_TYPE_ID | IR_REF_TYPE_DESC  | DATA_TYPE |
	| 18             | INVOICE_NUMBER    | A         |
	| 7              | INVOICE_AMOUNT    | N         |
	| 20             | DATE_REFERENCE    | D         |
	| 1              | INVOICE_REFERENCE | A         |

	Given the following LOCKBOX_CUST table info:	
	| LOCKBOX_ID | CUST_ID | 
	| 31460      | 44460   | 

	Given the following BAT table info:
	| BAT_ID | LOCKBOX_ID | PROC_DT    |
	| 548491 | 31460      | 2018-03-05 |

	Given the following TXN table info:
	| TXN_ID  | BAT_ID | PROC_DT    |
	| 5330712 | 548491 | 2018-03-05 |
		
	Given the following PYMT table info:
	| PYMT_ID | TXN_ID  |
	| 4455199 | 5330712 |

	Given the following INV table info:
	| INV_ID | TXN_ID  | INV_STS_ID | PROC_DT    | CCMP_INV_ID                          | STLMT_MSSN_IDEN |
	| 397939 | 5330712 | 100        | 5-Mar-2018 | f85e1e0b-9b51-35e5-accf-eb2176def38a |                 |
	| 397940 | 5330712 | 100        | 5-Mar-2018 | f85e1e0b-9b51-35e5-accf-eb2176def39b |                 |
	| 397941 | 5330712 | 100        | 5-Mar-2018 | f85e1e0b-9b51-35e5-accf-eb2176def40c |                 |
	| 397942 | 5330712 | 101        | 5-Mar-2018 |                                      | 2044            |

	Given the INV_STS_HST table will contain the following info:
	| INV_ID | INV_STS_ID | LOCKBOX_ID | PROC_DT    | LAST_UPDT_USR_ID |
	| 397939 | 100        | 31460      | 5-Mar-2018 | 2                |
	| 397940 | 100        | 31460      | 5-Mar-2018 | 2                |
	| 397941 | 100        | 31460      | 5-Mar-2018 | 2                |
	| 397942 | 100        | 31460      | 5-Mar-2018 | 2                |
	| 397942 | 101        | 31460      | 5-Mar-2018 | 2                |

	Given the following INV_IDEN_EXTRACT table info:
	| INV_IDEN_EXTRACT_ID | PYMT_ID | REF_ID | REF_CD | EXTRACT_VALUE | INV_ID |

	Given the following REM_WH_TXN_HST table info:
	| PYMT_ID | REM_WH_TXN_ID |
	| 4455199 | 397939        |
	| 4455199 | 397940        |
	| 4455199 | 397941        |

	Given the following REM_WH_REF_ITEM table info:
	| REM_WH_REF_ITEM_ID | REM_WH_TXN_ID | REF_ITEM_ROW_SEQ_NB | REF_ITEM_COL_SEQ_NB | REF_TYPE_ID | ALNUM_VAL_TX | NUM_VAL_AM | REF_ITEM_DT | REF_ITEM_ID | INV_ID |
	| 1957907            | 397939        | 1                   | 1                   | 9001        | INV-12345    |            |             |             | 397939 |
	| 1957808            | 397939        | 1                   | 4                   | 9002        |              | 500        |             |             | 397939 |
	| 1957909            | 397940        | 2                   | 1                   | 9001        | INV-12486    |            |             |             | 397940 |
	| 1958010            | 397940        | 2                   | 4                   | 9002        |              | 5002.5     |             |             | 397940 |
	| 1958111            | 397940        | 2                   | 5                   | 9008        |              |            | 5-Mar-18    |             | 397940 |
	| 1958212            | 397941        | 3                   | 1                   | 9001        | INV-12468    |            |             |             | 397941 |
	| 1958313            | 397941        | 3                   | 7                   | 9039        | PO-12468     |            |             |             | 397941 |

	Given the following REF_ITEM table info:
	| INV_ID | TXN_ID  | REF_ITEM_ROW_SEQ_NB | REF_ITEM_COL_SEQ_NB | ALNUM_VAL_TX | NUM_VAL_AM | REF_ITEM_DT | DOC_ID | LAST_UPDT_USR_ID | REF_TYPE_ID | CRE_BY_CD | HC_EOB_TXN_LGCL_GRP_ID | PROC_DT  |
	| 397942 | 5330712 | 1                   | 1                   | INV-12467    |            |             |        | 2                | 9001        | 0         |                        | 5-Mar-18 |
	| 397942 | 5330712 | 1                   | 4                   |              | 500.25     |             |        | 2                | 9002        | 0         |                        | 5-Mar-18 |                         

	When the client makes a post request:
	| TransactionId |
	| 5330712       |

	Then the response message will be
	| StatusCode |
	| 201        |

	And the IR_EVENT_LOG will contain the following info:
	| TXN_ID  | BAT_ID | CUST_ID | API_CD | STATUS_CD | MESSAGE |
	| 5330712 | 548491 | 44460   | 304    | 201       | Created |

	And the REF_ITEM table will contain the following info:
	| INV_ID | TXN_ID  | REF_ITEM_ROW_SEQ_NB | REF_ITEM_COL_SEQ_NB | ALNUM_VAL_TX | NUM_VAL_AM | REF_ITEM_DT | DOC_ID | LAST_UPDT_USR_ID | REF_TYPE_ID | CRE_BY_CD | HC_EOB_TXN_LGCL_GRP_ID | PROC_DT  |
	| 397939 | 5330712 | 2                   | 1                   | INV-12345    |            |             |        | 2                | 9001        | 0         |                        | 5-Mar-18 |
	| 397939 | 5330712 | 2                   | 4                   |              | 500        |             |        | 2                | 9002        | 0         |                        | 5-Mar-18 |
	| 397940 | 5330712 | 3                   | 1                   | INV-12486    |            |             |        | 2                | 9001        | 0         |                        | 5-Mar-18 |
	| 397940 | 5330712 | 3                   | 4                   |              | 5002.5     |             |        | 2                | 9002        | 0         |                        | 5-Mar-18 |
	| 397940 | 5330712 | 3                   | 5                   |              |            | 5-Mar-18    |        | 2                | 9008        | 0         |                        | 5-Mar-18 |
	| 397941 | 5330712 | 4                   | 1                   | INV-12468    |            |             |        | 2                | 9001        | 0         |                        | 5-Mar-18 |
	| 397941 | 5330712 | 4                   | 7                   | PO-12468     |            |             |        | 2                | 9039        | 0         |                        | 5-Mar-18 |
	| 397942 | 5330712 | 1                   | 1                   | INV-12467    |            |             |        | 2                | 9001        | 0         |                        | 5-Mar-18 |
	| 397942 | 5330712 | 1                   | 4                   |              | 500.25     |             |        | 2                | 9002        | 0         |                        | 5-Mar-18 |
	
	And the INV table will contain the following info:
	| INV_ID | INV_STS_ID | TXN_ID  | PROC_DT  | CCMP_INV_ID                          | STLMT_MSSN_IDEN |
	| 397939 | 106        | 5330712 | 5-Mar-18 | f85e1e0b-9b51-35e5-accf-eb2176def38a |                 |
	| 397940 | 106        | 5330712 | 5-Mar-18 | f85e1e0b-9b51-35e5-accf-eb2176def39b |                 |
	| 397941 | 106        | 5330712 | 5-Mar-18 | f85e1e0b-9b51-35e5-accf-eb2176def40c |                 |
	| 397942 | 101        | 5330712 | 5-Mar-18 |                                      | 2044            |

	And the INV_STS_HST table will contain the following info:
	| INV_ID | INV_STS_ID | LOCKBOX_ID | PROC_DT  | LAST_UPDT_USR_ID |
	| 397939 | 100        | 31460      | 5-Mar-18 | 2                |
	| 397939 | 106        | 31460      | 5-Mar-18 | 2                |
	| 397940 | 100        | 31460      | 5-Mar-18 | 2                |
	| 397940 | 106        | 31460      | 5-Mar-18 | 2                |
	| 397941 | 100        | 31460      | 5-Mar-18 | 2                |
	| 397941 | 106        | 31460      | 5-Mar-18 | 2                |
	| 397942 | 100        | 31460      | 5-Mar-18 | 2                |
	| 397942 | 101        | 31460      | 5-Mar-18 | 2                |
